package com.lucasjosino.on_audio_query.methods.queries

import android.content.ContentResolver
import android.content.Context
import android.net.Uri
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.lucasjosino.on_audio_query.controllers.PermissionController
import com.lucasjosino.on_audio_query.methods.helper.QueryHelper
import com.lucasjosino.on_audio_query.types.checkArtistsUriType
import com.lucasjosino.on_audio_query.types.sorttypes.checkArtistSortType
import com.lucasjosino.on_audio_query.utils.artistProjection
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

/** ArtistsQuery */
class ArtistsQuery : ViewModel() {

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

        // Sort: Type and Order
        sortType = checkArtistSortType(
            pSortType,
            pOrderType,
            pIgnoreCase
        )
        // Check uri:
        //   * [0]: External.
        //   * [1]: Internal.
        uri = checkArtistsUriType(pUri)

        queryArtists(context, result, sink)
    }

    /**
     * Method to "query" all artists.
     */
    private fun queryArtists(
        context: Context,
        result: MethodChannel.Result?,
        sink: EventChannel.EventSink?
    ) {
        // Query everything in background for a better performance.
        viewModelScope.launch {
            // Request permission status from the main method.
            val hasPermission = PermissionController().permissionStatus(context)
            // Empty list.
            var resultArtistList = ArrayList<MutableMap<String, Any?>>()

            // We cannot "query" without permission so, just return a empty list.
            if (hasPermission) {
                // Start querying
                resultArtistList = loadArtists()
            }

            //Flutter UI will start, but, information still loading
            if (sink != null) {
                sink.success(resultArtistList)
            } else {
                result!!.success(resultArtistList)
            }
        }
    }

    // Loading in Background
    private suspend fun loadArtists(): ArrayList<MutableMap<String, Any?>> =
        withContext(Dispatchers.IO) {
            // Setup the cursor with [uri], [projection] and [sortType].
            val cursor = resolver.query(uri, artistProjection, null, null, sortType)
            // Empty list.
            val artistList: ArrayList<MutableMap<String, Any?>> = ArrayList()

            // For each item(artist) inside this "cursor", take one and "format"
            // into a [Map<String, dynamic>].
            while (cursor != null && cursor.moveToNext()) {
                val tempData: MutableMap<String, Any?> = HashMap()
                for (artistMedia in cursor.columnNames) {
                    tempData[artistMedia] = helper.loadArtistItem(artistMedia, cursor)
                }

                artistList.add(tempData)
            }

            // Close cursor to avoid memory leaks.
            cursor?.close()
            // After finish the "query", go back to the "main" thread(You can only call flutter
            // inside the main thread).
            return@withContext artistList
        }
}

//Extras:

//I/OnArtistCursor[All/Audio]: [
// _id
// artist
// artist_key
// number_of_albums
// number_of_tracks
// ]