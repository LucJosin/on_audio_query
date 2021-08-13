package com.lucasjosino.on_audio_query.interfaces

/** OnPermissionManagerInterface */
interface OnPermissionManagerInterface {
    fun onPermissionStatus() : Boolean
    fun onRequestPermission()
    fun onRetryRequestPermission()
}