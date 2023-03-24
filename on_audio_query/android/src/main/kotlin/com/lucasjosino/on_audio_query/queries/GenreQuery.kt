package com.lucasjosino.on_audio_query.queries

import android.content.ContentResolver
import android.content.Context
import android.net.Uri
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.lucasjosino.on_audio_query.controller.PermissionController
import com.lucasjosino.on_audio_query.queries.helper.QueryHelper
import com.lucasjosino.on_audio_query.types.checkGenresUriType
import com.lucasjosino.on_audio_query.types.sorttypes.checkGenreSortType
import com.lucasjosino.on_audio_query.utils.genreProjection
import io.flutter.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

/** OnGenresQuery */
class GenreQuery : ViewModel() {

    companion object {
        private const val TAG = "OnGenresQuery"
    }

    // Main parameters.
    private val helper = QueryHelper()

    private lateinit var uri: Uri
    private lateinit var sortType: String
    private lateinit var resolver: ContentResolver

    /**
     * Method to "query" all genres.
     *
     * Parameters:
     *   * [context]
     *   * [result]
     *   * [call]
     */
    fun queryGenres(context: Context, result: MethodChannel.Result, call: MethodCall) {
        resolver = context.contentResolver

        // Sort: Type and Order.
        sortType = checkGenreSortType(
            call.argument<Int>("sortType"),
            call.argument<Int>("orderType")!!,
            call.argument<Boolean>("ignoreCase")!!
        )

        // Check uri:
        //   * 0 -> External
        //   * 1 -> Internal
        uri = checkGenresUriType(call.argument<Int>("uri")!!)

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
            val queryResult: ArrayList<MutableMap<String, Any?>> = loadGenres()
            result.success(queryResult)
        }
    }

    // Loading in Background
    private suspend fun loadGenres(): ArrayList<MutableMap<String, Any?>> =
        withContext(Dispatchers.IO) {
            // Setup the cursor with 'uri', 'projection' and 'sortType'.
            val cursor = resolver.query(uri, genreProjection, null, null, sortType)

            val genreList: ArrayList<MutableMap<String, Any?>> = ArrayList()

            Log.d(TAG, "Cursor count: ${cursor?.count}")

            // For each item(genre) inside this "cursor", take one and "format"
            // into a 'Map<String, dynamic>'.
            while (cursor != null && cursor.moveToNext()) {
                val genreData: MutableMap<String, Any?> = HashMap()

                for (genreMedia in cursor.columnNames) {
                    genreData[genreMedia] = helper.loadGenreItem(genreMedia, cursor)
                }

                // Count and add the number of songs for every genre.
                val mediaCount = helper.getMediaCount(0, genreData["_id"].toString(), resolver)
                genreData["num_of_songs"] = mediaCount

                if (genreData["name"] != null && genreData["_id"] != 0) {
                    genreList.add(genreData)
                }
            }

            // Close cursor to avoid memory leaks.
            cursor?.close()
            return@withContext genreList
        }
}
