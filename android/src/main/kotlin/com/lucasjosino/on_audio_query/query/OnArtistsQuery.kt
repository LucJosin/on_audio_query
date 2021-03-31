package com.lucasjosino.on_audio_query.query

import android.content.ContentResolver
import android.content.Context
import android.net.Uri
import android.provider.MediaStore
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.lucasjosino.on_audio_query.types.checkArtistsUriType
import com.lucasjosino.on_audio_query.types.checkAudiosUriType
import com.lucasjosino.on_audio_query.types.sorttypes.checkArtistSortType
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

/** OnArtistsQuery */
class OnArtistsQuery : ViewModel() {

    //Main parameters
    private lateinit var uri: Uri
    private lateinit var resolver: ContentResolver
    private lateinit var sortType: String

    //Query projection
    private val projection = arrayOf(
            MediaStore.Audio.Artists._ID,
            MediaStore.Audio.Artists.ARTIST,
//            MediaStore.Audio.Artists.ARTIST_KEY,
            MediaStore.Audio.Artists.NUMBER_OF_ALBUMS,
            MediaStore.Audio.Artists.NUMBER_OF_TRACKS
    )

    fun queryArtists(context: Context, result: MethodChannel.Result, call: MethodCall) {
        resolver = context.contentResolver

        //SortType: Type and Order
        sortType = checkArtistSortType(call.argument<Int>("sortType")!!, call.argument<Int>("orderType")!!)
        uri = checkArtistsUriType(call.argument<Int>("uri")!!)

        //Query everything in the Background it's necessary for better performance
        viewModelScope.launch {
            //Start querying
            val resultArtistList = loadArtists()

            //Flutter UI will start, but, information still loading
            result.success(resultArtistList)
        }
    }

    //Loading in Background
    private suspend fun loadArtists() : ArrayList<MutableMap<String, Any>> = withContext(Dispatchers.IO) {
        val cursor = resolver.query(uri, projection, null, null, sortType)
        val artistList: ArrayList<MutableMap<String, Any>> = ArrayList()
        while (cursor != null && cursor.moveToNext()) {
            val artistData: MutableMap<String, Any> = HashMap()
            for (artistMedia in cursor.columnNames) {
                if (cursor.getString(cursor.getColumnIndex(artistMedia)) != null) {
                    artistData[artistMedia] = cursor.getString(cursor.getColumnIndex(artistMedia))
                } else artistData[artistMedia] = ""
            }
            artistList.add(artistData)
        }
        cursor?.close()
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