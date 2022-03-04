package com.lucasjosino.on_audio_query.methods.queries

import android.content.ContentResolver
import android.content.Context
import android.net.Uri
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.lucasjosino.on_audio_query.controllers.PermissionController
import com.lucasjosino.on_audio_query.methods.helper.QueryHelper
import com.lucasjosino.on_audio_query.types.checkGenresUriType
import com.lucasjosino.on_audio_query.types.sorttypes.checkGenreSortType
import com.lucasjosino.on_audio_query.utils.genreProjection
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

/** GenresQuery */
class GenresQuery : ViewModel() {

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
        sortType = checkGenreSortType(
            pSortType,
            pOrderType,
            pIgnoreCase
        )
        // Check uri:
        //   * [0]: External.
        //   * [1]: Internal.
        uri = checkGenresUriType(pUri)

        // Add item/items to 'query'.
        for ((id, values) in toQuery) {
            for (value in values) {
                selection += genreProjection[id] + " LIKE '%" + value + "%' " + "AND "
            }
        }

        // Remove item/items from 'query'.
        for ((id, values) in toRemove) {
            for (value in values) {
                selection += genreProjection[id] + " NOT LIKE '%" + value + "%' " + "AND "
            }
        }

        // Remove the 'AND ' keyword from selection.
        selection = selection.removeSuffix("AND ")

        //
        queryGenres(context, result, sink)
    }

    /**
     * Method to "query" all genres.
     */
    private fun queryGenres(
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
            val resultGenreList: ArrayList<MutableMap<String, Any?>> = loadGenres()

            // After loading the information, send the 'result'.
            sink?.success(resultGenreList)
            result?.success(resultGenreList)
        }
    }

    //Loading in Background
    private suspend fun loadGenres(): ArrayList<MutableMap<String, Any?>> =
        withContext(Dispatchers.IO) {
            // Setup the cursor with [uri], [projection] and [sortType].
            val cursor = resolver.query(uri, genreProjection, selection, null, sortType)
            // Empty list.
            val genreList: ArrayList<MutableMap<String, Any?>> = ArrayList()

            // For each item(genre) inside this "cursor", take one and "format"
            // into a [Map<String, dynamic>].
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
            // After finish the "query", go back to the "main" thread(You can only call flutter
            // inside the main thread).
            return@withContext genreList
        }
}

//Extras:

//I/OnGenreCursor[All/Audio]: [
// _id
// name
// ]