package com.lucasjosino.on_audio_query.methods.queries

import android.content.ContentResolver
import android.content.Context
import android.net.Uri
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.lucasjosino.on_audio_query.controllers.PermissionController
import com.lucasjosino.on_audio_query.methods.helper.QueryHelper
import com.lucasjosino.on_audio_query.types.checkAlbumsUriType
import com.lucasjosino.on_audio_query.types.sorttypes.checkAlbumSortType
import com.lucasjosino.on_audio_query.utils.albumProjection
import com.lucasjosino.on_audio_query.utils.songProjection
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

/** AlbumsQuery */
class AlbumsQuery : ViewModel() {

    // Main parameters.
    private val helper = QueryHelper()
    private var selection: String = ""

    // None of this methods can be null.
    private lateinit var uri: Uri
    private lateinit var sortType: String
    private lateinit var resolver: ContentResolver

    @Suppress("UNCHECKED_CAST")
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

        val toQuery: MutableMap<Int, ArrayList<String>>
        val toRemove: MutableMap<Int, ArrayList<String>>

        if (sink != null && args != null) {
            pSortType = args["sortType"] as Int?
            pOrderType = args["orderType"] as Int
            pIgnoreCase = args["ignoreCase"] as Boolean
            pUri = args["uri"] as Int

            toQuery = args["toQuery"] as MutableMap<Int, ArrayList<String>>
            toRemove = args["toRemove"] as MutableMap<Int, ArrayList<String>>
        } else {
            pSortType = call!!.argument<Int>("sortType")
            pOrderType = call.argument<Int>("orderType")!!
            pIgnoreCase = call.argument<Boolean>("ignoreCase")!!
            pUri = call.argument<Int>("uri")!!

            toQuery = call.argument<MutableMap<Int, ArrayList<String>>>("toQuery")!!
            toRemove = call.argument<MutableMap<Int, ArrayList<String>>>("toRemove")!!
        }

        // Sort: Type and Order.
        sortType = checkAlbumSortType(
            pSortType,
            pOrderType,
            pIgnoreCase
        )

        // Check uri:
        //   * [0]: External.
        //   * [1]: Internal.
        uri = checkAlbumsUriType(pUri)

        // Add item/items to 'query'.
        for ((id, values) in toQuery) {
            for (value in values) {
                selection += albumProjection[id] + " LIKE '%" + value + "%' " + "AND "
            }
        }

        // Remove item/items from 'query'.
        for ((id, values) in toRemove) {
            for (value in values) {
                selection += albumProjection[id] + " NOT LIKE '%" + value + "%' " + "AND "
            }
        }

        // Remove the 'AND ' keyword from selection.
        selection = selection.removeSuffix("AND ")

        //
        queryAlbums(context, result, sink)
    }

    /**
     * Method to "query" all albums.
     */
    private fun queryAlbums(
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
            val resultAlbumList: ArrayList<MutableMap<String, Any?>> = loadAlbums()

            // After loading the information, send the 'result'.
            sink?.success(resultAlbumList)
            result?.success(resultAlbumList)
        }
    }

    // Loading in Background
    private suspend fun loadAlbums(): ArrayList<MutableMap<String, Any?>> =
        withContext(Dispatchers.IO) {
            // Setup the cursor.
            val cursor = resolver.query(uri, albumProjection, selection, null, sortType)
            // Empty list.
            val albumList: ArrayList<MutableMap<String, Any?>> = ArrayList()

            // For each item(album) inside this "cursor", take one and "format"
            // into a [Map<String, dynamic>].
            while (cursor != null && cursor.moveToNext()) {
                val tempData: MutableMap<String, Any?> = HashMap()
                for (albumMedia in cursor.columnNames) {
                    tempData[albumMedia] = helper.loadAlbumItem(albumMedia, cursor)
                }
                // In Android 10 and above [album_art] will return null, to avoid problem,
                // we remove it. Use [queryArtwork] instead.
                val art = tempData["album_art"].toString()
                if (art.isEmpty()) tempData.remove("album_art")
                albumList.add(tempData)
            }

            // Close cursor to avoid memory leaks.
            cursor?.close()
            // After finish the "query", go back to the "main" thread(You can only call flutter
            // inside the main thread).
            return@withContext albumList
        }
}

//I/AlbumCursor: [
// numsongs,
// artist,
// numsongs_by_artist,
// _id,
// album,
// album_art,
// album_key,
// artist_id,
// maxyear,
// minyear,
// album_id,
// ]