package com.lucasjosino.on_audio_query.query

import android.content.ContentResolver
import android.content.Context
import android.net.Uri
import android.provider.MediaStore
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.lucasjosino.on_audio_query.types.sorttypes.checkGenreSortType
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

/** OnGenresQuery */
class OnGenresQuery : ViewModel() {

    //Main parameters
    private val uri: Uri = MediaStore.Audio.Genres.EXTERNAL_CONTENT_URI
    private lateinit var sortType: String
    private lateinit var resolver: ContentResolver

    //Query projection
    private val projection = arrayOf(
            MediaStore.Audio.Genres._ID,
            MediaStore.Audio.Genres.NAME
    )

    //
    fun queryGenres(context: Context, result: MethodChannel.Result, call: MethodCall) {
        resolver = context.contentResolver

        //SortType: Type and Order
        sortType = checkGenreSortType(call.argument<Int>("sortType")!!, call.argument<Int>("orderType")!!)

        //Query everything in the Background it's necessary for better performance
        viewModelScope.launch {
            //Start querying
            val resultGenreList = loadGenres()

            //Flutter UI will start, but, information still loading
            result.success(resultGenreList)
        }
    }

    //Loading in Background
    private suspend fun loadGenres() : ArrayList<MutableMap<String, Any>> = withContext(Dispatchers.IO) {
        val cursor = resolver.query(uri, projection, null, null, sortType)
        val genreList: ArrayList<MutableMap<String, Any>> = ArrayList()
        while (cursor != null && cursor.moveToNext()) {
            val genreData: MutableMap<String, Any> = HashMap()
            for (genreMedia in cursor.columnNames) {
                if (cursor.getString(cursor.getColumnIndex(genreMedia)) != null) {
                    genreData[genreMedia] = cursor.getString(cursor.getColumnIndex(genreMedia))
                } else genreData[genreMedia] = ""
            }
            genreList.add(genreData)
        }
        cursor?.close()
        return@withContext genreList
    }
 }

//Extras:

//I/OnGenreCursor[All/Audio]: [
// _id
// name
// ]