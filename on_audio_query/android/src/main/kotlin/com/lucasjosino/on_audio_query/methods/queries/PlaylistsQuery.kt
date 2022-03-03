package com.lucasjosino.on_audio_query.methods.queries

import android.content.ContentResolver
import android.content.Context
import android.net.Uri
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.lucasjosino.on_audio_query.controllers.PermissionController
import com.lucasjosino.on_audio_query.methods.helper.QueryHelper
import com.lucasjosino.on_audio_query.types.checkPlaylistsUriType
import com.lucasjosino.on_audio_query.types.sorttypes.checkGenreSortType
import com.lucasjosino.on_audio_query.utils.playlistProjection
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

/** PlaylistsQuery */
class PlaylistsQuery : ViewModel() {

    //Main parameters
    private val helper = QueryHelper()

    // None of this methods can be null.
    private lateinit var uri: Uri
    private lateinit var resolver: ContentResolver
    private lateinit var sortType: String

    //
    fun init(
        context: Context,
        //
        result: MethodChannel.Result? = null,
        call: MethodCall? = null,
        //
        sink: EventChannel.EventSink? = null,
        args: Map<*, *>? = null
    ) {
        resolver = context.contentResolver

        val pSortType: Int?
        val pOrderType: Int
        val pIgnoreCase: Boolean

        val pUri: Int

        if (sink != null && args != null) {
            pSortType = args["sortType"] as Int?
            pOrderType = args["orderType"] as Int
            pIgnoreCase = args["ignoreCase"] as Boolean

            pUri = args["uri"] as Int
        } else {
            pSortType = call!!.argument<Int>("sortType")
            pOrderType = call.argument<Int>("orderType")!!
            pIgnoreCase = call.argument<Boolean>("ignoreCase")!!

            pUri = call.argument<Int>("uri")!!
        }

        // Sort: Type and Order.
        sortType = checkGenreSortType(
            pSortType,
            pOrderType,
            pIgnoreCase
        )
        // Check uri:
        //   * [0]: External.
        //   * [1]: Internal.
        uri = checkPlaylistsUriType(pUri)

        //
        queryPlaylists(context, result, sink)
    }

    /**
     * Method to "query" all playlists.
     */
    private fun queryPlaylists(
        context: Context,
        result: MethodChannel.Result?,
        sink: EventChannel.EventSink?
    ) {
        // Request permission status from the 'main' method.
        val hasPermission: Boolean = PermissionController().permissionStatus(context)

        // We cannot 'query' without permission so, throw a PlatformException.
        // Only one 'channel' will be 'functional'. If is null, ignore, if not, send the error.
        if (!hasPermission) {
            // Method from 'EventChannel' (observer)
            sink?.error(
                "403",
                "The app doesn't have permission to read files.",
                "Call the [permissionsRequest] method or install a external plugin to handle the app permission."
            )
            // Method from 'MethodChannel' (method)
            result?.error(
                "403",
                "The app doesn't have permission to read files.",
                "Call the [permissionsRequest] method or install a external plugin to handle the app permission."
            )

            // 'Exit' the function
            return
        }

        // Query everything in background for a better performance.
        viewModelScope.launch {
            // Start 'querying'.
            val resultPlaylistList: ArrayList<MutableMap<String, Any?>> = loadPlaylists()

            // After loading the information, send the 'result'.
            sink?.success(resultPlaylistList)
            result?.success(resultPlaylistList)
        }
    }

    //Loading in Background
    private suspend fun loadPlaylists(): ArrayList<MutableMap<String, Any?>> =
        withContext(Dispatchers.IO) {
            // Setup the cursor with [uri] and [projection].
            val cursor = resolver.query(uri, playlistProjection, null, null, null)
            // Empty list.
            val playlistList: ArrayList<MutableMap<String, Any?>> = ArrayList()

            // For each item(playlist) inside this "cursor", take one and "format"
            // into a [Map<String, dynamic>].
            while (cursor != null && cursor.moveToNext()) {
                val playlistData: MutableMap<String, Any?> = HashMap()
                for (playlistMedia in cursor.columnNames) {
                    playlistData[playlistMedia] = helper.loadPlaylistItem(playlistMedia, cursor)
                }

                // Count and add the number of songs for every playlist.
                val mediaCount = helper.getMediaCount(1, playlistData["_id"].toString(), resolver)
                playlistData["num_of_songs"] = mediaCount

                playlistList.add(playlistData)
            }

            // Close cursor to avoid memory leaks.
            cursor?.close()
            // After finish the "query", go back to the "main" thread(You can only call flutter
            // inside the main thread).
            return@withContext playlistList
        }
}

//Extras:

//I/OnPlaylistCursor[All/Audio]: [
// _data
// _id
// date_added
// date_modified
// name
// ]