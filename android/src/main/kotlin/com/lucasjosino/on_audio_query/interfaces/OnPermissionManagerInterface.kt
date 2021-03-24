package com.lucasjosino.on_audio_query.interfaces

/** OnPermissionManagerInterface */
interface OnPermissionManagerInterface {
    fun onCheckPermission(requestPermission: Boolean)
    fun onPermissionStatus() : Boolean
    fun onRequestPermission(IorE: String)
    fun onRetryRequestPermission()
}