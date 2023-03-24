package com.lucasjosino.on_audio_query.queries

import android.content.ContentResolver
import android.content.Context
import android.net.Uri
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.lucasjosino.on_audio_query.controller.PermissionController
import com.lucasjosino.on_audio_query.queries.helper.QueryHelper
import com.lucasjosino.on_audio_query.types.checkArtistsUriType
import com.lucasjosino.on_audio_query.types.sorttypes.checkArtistSortType
import com.lucasjosino.on_audio_query.utils.artistProjection
import io.flutter.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

/** OnArtistsQuery */
class ArtistQuery : ViewModel() {

    companion object {
        private const val TAG = "OnArtistsQuery"
    }

    //Main parameters
    private val helper = QueryHelper()

    // None of this methods can be null.
    private lateinit var uri: Uri
    private lateinit var resolver: ContentResolver
    private lateinit var sortType: String

    /**
     * Method to "query" all artists.
     *
     * Parameters:
     *   * [context]
     *   * [result]
     *   * [call]
     */
    fun queryArtists(context: Context, result: MethodChannel.Result, call: MethodCall) {
        resolver = context.contentResolver

        // Sort: Type and Order
        sortType = checkArtistSortType(
            call.argument<Int>("sortType"),
            call.argument<Int>("orderType")!!,
            call.argument<Boolean>("ignoreCase")!!
        )

        // Check uri:
        //   * 0 -> External.
        //   * 1 -> Internal.
        uri = checkArtistsUriType(call.argument<Int>("uri")!!)

        Log.d(TAG, "Query config: ")
        Log.d(TAG, "\tsortType: $sortType")
        Log.d(TAG, "\turi: $uri")

        // We cannot 'query' without permission.
        val hasPermission: Boolean = PermissionController().permissionStatus(context)
        if (!hasPermission) {
            result.error(
                "403",
                "The app doesn't have permission to read files.",
                "Call the [permissionsRequest] method or install a external plugin to handle the app permission."
            )
            return
        }

        // Query everything in background for a better performance.
        viewModelScope.launch {
            val queryResult: ArrayList<MutableMap<String, Any?>> = loadArtists()
            result.success(queryResult)
        }
    }

    // Loading in Background
    private suspend fun loadArtists(): ArrayList<MutableMap<String, Any?>> =
        withContext(Dispatchers.IO) {
            // Setup the cursor with 'uri', 'projection' and 'sortType'.
            val cursor = resolver.query(uri, artistProjection, null, null, sortType)

            val artistList: ArrayList<MutableMap<String, Any?>> = ArrayList()

            Log.d(TAG, "Cursor count: ${cursor?.count}")

            // For each item(artist) inside this "cursor", take one and "format"
            // into a 'Map<String, dynamic>'.
            while (cursor != null && cursor.moveToNext()) {
                val tempData: MutableMap<String, Any?> = HashMap()

                for (artistMedia in cursor.columnNames) {
                    tempData[artistMedia] = helper.loadArtistItem(artistMedia, cursor)
                }

                artistList.add(tempData)
            }

            // Close cursor to avoid memory leaks.
            cursor?.close()
            return@withContext artistList
        }
}
