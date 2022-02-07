/*
=============
Author: Lucas Josino
Github: https://github.com/LucJosin
Website: https://www.lucasjosino.com/
=============
Plugin/Id: on_audio_query#0
Homepage: https://github.com/LucJosin/on_audio_query
Pub: https://pub.dev/packages/on_audio_query
License: https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/LICENSE
Copyright: © 2021, Lucas Josino. All rights reserved.
=============
*/

package com.lucasjosino.on_audio_query

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import android.media.MediaScannerConnection
import android.os.Build
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.lucasjosino.on_audio_query.controller.QueryController
import com.lucasjosino.on_audio_query.interfaces.PermissionManagerInterface
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

/** OnAudioQueryPlugin Central */
class OnAudioQueryPlugin : FlutterPlugin, MethodCallHandler, ActivityAware,
    PermissionManagerInterface, PluginRegistry.RequestPermissionsResultListener {

    // Dart <-> Kotlin communication
    private val channelName = "com.lucasjosino.on_audio_query"
    private lateinit var channel: MethodChannel

    // Main parameters
    private var retryRequest: Boolean = false
    private lateinit var context: Context
    private lateinit var activity: Activity
    private lateinit var result: Result
    private lateinit var queryController: QueryController

    //
    private val onPermission = arrayOf(
        Manifest.permission.READ_EXTERNAL_STORAGE,
        Manifest.permission.WRITE_EXTERNAL_STORAGE
    )

    // This is only important for initialization
    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        this.context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, channelName)
        channel.setMethodCallHandler(this)
    }

    // Methods will always follow the same route:
    // Receive method -> check permission -> controller -> do what's needed -> return to dart
    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        this.result = result; queryController = QueryController(context, call, result)

        // If user deny permission request a pop up will immediately show up
        // If [retryRequest] is null, the message will only show when call method again
        retryRequest = call.argument<Boolean>("retryRequest") ?: false

        //
        when (call.method) {
            // Permissions
            "permissionsStatus" -> result.success(onPermissionStatus())
            "permissionsRequest" -> onRequestPermission()

            // Device information
            "queryDeviceInfo" -> {
                val deviceData: MutableMap<String, Any> = HashMap()
                deviceData["device_model"] = Build.MODEL
                deviceData["device_sys_version"] = Build.VERSION.SDK_INT
                deviceData["device_sys_type"] = "Android"
                result.success(deviceData)
            }

            // This method will scan the given path to update the 'state'.
            // When deleting a file using 'dart:io', call this method to update the file 'state'.
            "scan" -> {
                val sPath: String? = call.argument<String>("path")

                // Check if the given file is null or empty.
                if (sPath == null || sPath.isEmpty()) result.success(false)

                // Scan and return
                MediaScannerConnection.scanFile(context, arrayOf(sPath), null) { _, _ ->
                    result.success(true)
                }
            }

            // All others methods
            else -> queryController.onAudioController()
        }
    }

    // This is only important for initialization - Start
    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.activity = binding.activity
        binding.addRequestPermissionsResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {}

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}

    override fun onDetachedFromActivity() {}
    // End

    // OnPermissionController
    // TODO Find another solution for Permission Request

    //
    private val onRequestCode: Int = 88560

    override fun onPermissionStatus(context: Context?): Boolean = onPermission.all {
        // After "leaving" this class, context will be null so, we need this context argument to
        // call the [checkSelfPermission].
        return ContextCompat.checkSelfPermission(
            context ?: this.context,
            it
        ) == PackageManager.PERMISSION_GRANTED
    }

    override fun onRequestPermission() {
        ActivityCompat.requestPermissions(activity, onPermission, onRequestCode)
    }

    // Second requestPermission, this one with the option "Never Ask Again".
    override fun onRetryRequestPermission() {
        if (ActivityCompat.shouldShowRequestPermissionRationale(activity, onPermission[0])
            || ActivityCompat.shouldShowRequestPermissionRationale(activity, onPermission[1])
        ) {
            retryRequest = false
            onRequestPermission()
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>?,
        grantResults: IntArray?
    ): Boolean {
        // When [result] is not initialized the permission request did not originate from the
        // [on_audio_query] plugin, so return [false] to indicate the [on_audio_query] plugin is not
        // handling the request result and Android should continue executing other registered handlers.
        if (!this::result.isInitialized) return false

        // When the incoming request code doesn't match the request codes defined by the on_audio_query
        // plugin return [false] to indicate the [on_audio_query] plugin is not handling the request
        // result and Android should continue executing other registered handlers.
        if (requestCode != onRequestCode) return false

        // Check permission
        val isPermissionGranted = if (grantResults != null) grantResults.isNotEmpty()
                && grantResults[0] == PackageManager.PERMISSION_GRANTED else false

        // After all checks, we can handle the permission request.
        when {
            isPermissionGranted -> result.success(true)
            retryRequest -> onRetryRequestPermission()
            else -> result.success(false)
        }

        // Return [true] here to indicate that the [on_audio_query] plugin handled the permission request
        // result and Android should not continue executing other registered handlers.
        return true
    }
}
