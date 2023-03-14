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

import android.app.Activity
import android.content.Context
import android.media.MediaScannerConnection
import android.os.Build
import com.lucasjosino.on_audio_query.controller.OnAudioController
import com.lucasjosino.on_audio_query.controller.PermissionController
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** OnAudioQueryPlugin Central */
class OnAudioQueryPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

    companion object {
        // Get the current class name.
        private val TAG: String = this::class.java.name

        // Method channel name.
        private const val CHANNEL_NAME = "com.lucasjosino.on_audio_query"
    }

    private lateinit var channel: MethodChannel

    private var activity: Activity? = null
    private var binding: ActivityPluginBinding? = null

    private lateinit var context: Context
    private lateinit var controller: OnAudioController
    private lateinit var permissionController: PermissionController

    // Dart <-> Kotlin communication
    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        // Define the [context]
        context = flutterPluginBinding.applicationContext

        // Setup the method channel communication.
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME)
        channel.setMethodCallHandler(this)
    }

    // Methods will always follow the same route:
    // Receive method -> check permission -> controller -> do what's needed -> return to dart
    override fun onMethodCall(call: MethodCall, result: Result) {
        // Both [activity] and [binding] are from [onAttachedToActivity].
        if (activity == null || binding == null) {
            result.error(
                "$TAG::onMethodCall",
                "Methods [activity] or [binding] are null!",
                null
            )
        }

        controller = OnAudioController(context, call, result)

        // If user deny permission request a pop up will immediately show up
        // If [retryRequest] is null, the message will only show when call method again
        val retryRequest = call.argument<Boolean>("retryRequest") ?: false

        // Setup the [PermissionController]
        permissionController = PermissionController(retryRequest)

        when (call.method) {
            // Permissions
            "permissionsStatus" -> result.success(permissionController.permissionStatus(context))
            "permissionsRequest" -> {
                // Add to controller the ability to listen the request result.
                binding!!.addRequestPermissionsResultListener(permissionController)

                // Request the permission.
                permissionController.requestPermission(activity!!, result)
            }

            // Device information
            "queryDeviceInfo" -> {
                result.success(
                    hashMapOf<String, Any>(
                        "device_model" to Build.MODEL,
                        "device_sys_version" to Build.VERSION.SDK_INT,
                        "device_sys_type" to "Android"
                    )
                )
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
            else -> controller.call()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.activity = binding.activity
        this.binding = binding
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    // Detach all parameters.
    override fun onDetachedFromActivity() {
        // Remove the permission listener
        if (binding != null) {
            binding!!.removeRequestPermissionsResultListener(permissionController)
        }

        this.activity = null
        this.binding = null
    }
}
