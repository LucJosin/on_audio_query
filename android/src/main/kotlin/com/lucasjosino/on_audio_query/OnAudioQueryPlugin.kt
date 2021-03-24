/*
Author: Lucas Josino
Github: https://github.com/LucasPJS
Plugin: on_audio_query
Homepage: https://github.com/LucasPJS/on_audio_query
Copyright: © 2021, Lucas Josino. All rights reserved.
License: https://github.com/LucasPJS/on_audio_query/blob/main/LICENSE
*/

package com.lucasjosino.on_audio_query

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.lucasjosino.on_audio_query.controller.OnAudioController
import com.lucasjosino.on_audio_query.interfaces.OnPermissionManagerInterface
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry


/** OnAudioQueryPlugin Central */
class OnAudioQueryPlugin: FlutterPlugin, MethodCallHandler, ActivityAware,
        OnPermissionManagerInterface, PluginRegistry.RequestPermissionsResultListener {

  //Dart <-> Kotlin communication
  private val channelName = "com.lucasjosino.on_audio_query"
  private val channelError = "on_audio_error"
  private lateinit var channel : MethodChannel

  //Main parameters
  private var retryRequest: Boolean = false
  private lateinit var pContext: Context
  private lateinit var pActivity: Activity
  private lateinit var pResult: Result
  private lateinit var onAudioController: OnAudioController

  //
  private val onPermission = arrayOf(
          Manifest.permission.READ_EXTERNAL_STORAGE,
          Manifest.permission.WRITE_EXTERNAL_STORAGE
  )

  //This is only important for initialization
  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    this.pContext = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, channelName)
    channel.setMethodCallHandler(this)
  }

  //Methods will always follow the same route:
  //Receive method -> check permission -> controller -> do what's needed -> return to dart
  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    pResult = result ; onAudioController = OnAudioController(pContext, call, result)

    //Request will be null(*For kotlin) when permissions methods are called, so, it's important to check.
    //*For Kotlin: Actually request won't be null, Dart already have a request check.
    val request = if (call.argument<Boolean>("requestPermission") == null) false
    else call.argument<Boolean>("requestPermission")!!
    //If user deny permission request a pop up will immediately show up
    //If [retryRequest] is null, the message will only show when call method again
    retryRequest = if (call.argument<Boolean>("retryRequest") == null) false
    else call.argument<Boolean>("retryRequest")!!

    //
    when (call.method) {
      //Permissions
      "permissionsStatus" -> result.success(onPermissionStatus())
      "permissionsRequest" -> onRequestPermission("E")
      //Device information
      //Permissions and Storage in Android are very complicated, get device info may help
      "getDeviceSDK" -> result.success(Build.VERSION.SDK_INT)
      "getDeviceRelease" -> result.success(Build.VERSION.RELEASE)
      "getDeviceCode" -> {
        val fields = Build.VERSION_CODES::class.java.fields
        result.success(fields[Integer.parseInt(Build.VERSION.SDK_INT.toString())].name)
      }
      else -> { onCheckPermission(request) } //All others methods
    }

  }

  //This is only important for initialization - Start
  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    this.pActivity = binding.activity
    binding.addRequestPermissionsResultListener(this)
  }

  override fun onDetachedFromActivityForConfigChanges() {}

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}

  override fun onDetachedFromActivity() {}
  //End

  //OnPermissionController
  //TODO Find another solution for Permission Request
  // if [OnPermissionController] is in another class, [onRequestPermissionsResult]
  // won't listen to Call and Result parameters

  //
  private val onRequestCode: Int = 88560
  private val onExternalRequestCode: Int = 88561

  override fun onCheckPermission(requestPermission: Boolean) {
    if (!requestPermission || onPermissionStatus()) onAudioController.onAudioController()
    else onRequestPermission("I")
  }

  override fun onPermissionStatus(): Boolean = onPermission.all {
    return ContextCompat.checkSelfPermission(pContext, it) == PackageManager.PERMISSION_GRANTED
  }

  override fun onRequestPermission(IorE: String) {
    //[I] -> Internal -> From Kotlin ; [E] -> External -> From Dart
    when (IorE) {
      "I" -> {
        ActivityCompat.requestPermissions(pActivity, onPermission, onRequestCode)
      }
      "E" -> {
        ActivityCompat.requestPermissions(pActivity, onPermission, onExternalRequestCode)
      }
    }
  }

  //Second requestPermission, this one with option "Never Ask Again"
  override fun onRetryRequestPermission() {
    if (ActivityCompat.shouldShowRequestPermissionRationale(pActivity, onPermission[0])
            || ActivityCompat.shouldShowRequestPermissionRationale(pActivity, onPermission[1])) {
      onRequestPermission("I")
    }
  }

  override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>?, grantResults: IntArray?): Boolean {
    val isPermissionGranted = if (grantResults != null) grantResults.isNotEmpty()
            && grantResults[0] == PackageManager.PERMISSION_GRANTED else false
    when (requestCode) {
      onRequestCode -> if (isPermissionGranted) onAudioController.onAudioController()
      else if (retryRequest) onRetryRequestPermission()
      //
      onExternalRequestCode -> if (isPermissionGranted) pResult.success(true)
      else if (retryRequest) onRetryRequestPermission() else pResult.success(false)
      //
      else -> pResult.error(channelError, "RequestCode: [$requestCode] don't exist, probably my fault, open a issue in GitHub", null)
    }
    return false
  }
}
