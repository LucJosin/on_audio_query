package com.lucasjosino.on_audio_query.utils

import android.os.Build
import io.flutter.plugin.common.MethodChannel

fun queryDeviceInfo(result: MethodChannel.Result) {
    val deviceList: ArrayList<MutableMap<String, Any>> = ArrayList()
    val deviceData: MutableMap<String, Any> = HashMap()
    val fields = Build.VERSION_CODES::class.java.fields
    deviceData["device_sdk"] = Build.VERSION.SDK_INT
    deviceData["device_release"] = Build.VERSION.RELEASE
    deviceData["device_code"] = fields[Integer.parseInt(Build.VERSION.SDK_INT.toString())].name
    deviceData["device"] = "Android"
    deviceList.add(deviceData)
    result.success(deviceList)
}