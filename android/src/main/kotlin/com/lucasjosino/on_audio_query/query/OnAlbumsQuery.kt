package com.lucasjosino.on_audio_query.query

import android.content.ContentResolver
import android.content.Context
import android.net.Uri
import android.provider.MediaStore
import androidx.annotation.NonNull
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.lucasjosino.on_audio_query.types.checkAlbumsUriType
import com.lucasjosino.on_audio_query.types.checkAudiosUriType
import com.lucasjosino.on_audio_query.types.sorttypes.checkAlbumSortType
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

/** OnAlbumsQuery */
class OnAlbumsQuery : ViewModel() {

    //Main parameters
    private lateinit var uri: Uri
    private lateinit var sortType: String
    private lateinit var resolver: ContentResolver

    //
    fun queryAlbums(@NonNull context: Context, @NonNull result: MethodChannel.Result, @NonNull call: MethodCall) {
        resolver = context.contentResolver

        //SortType: Type and Order
        sortType = checkAlbumSortType(call.argument<Int>("sortType")!!, call.argument<Int>("orderType")!!)
        uri = checkAlbumsUriType(call.argument<Int>("uri")!!)

        //Query everything in the Background it's necessary for better performance
        viewModelScope.launch {
            //Start querying
            val resultAlbumList = loadAlbums()

            //Flutter UI will start, but, information still loading
            result.success(resultAlbumList)
        }
    }

    //Loading in Background
    private suspend fun loadAlbums() : ArrayList<MutableMap<String, Any>> = withContext(Dispatchers.IO) {
        val cursor = resolver.query(uri, null, null, null, sortType)
        val albumList: ArrayList<MutableMap<String, Any>> = ArrayList()
        while (cursor != null && cursor.moveToNext()) {
            val albumData: MutableMap<String, Any> = HashMap()
            for (albumMedia in cursor.columnNames) {
                if (cursor.getString(cursor.getColumnIndex(albumMedia)) != null) {
                    albumData[albumMedia] = cursor.getString(cursor.getColumnIndex(albumMedia))
                } else albumData[albumMedia] = ""
            }

            //In Android 10 and above [album_art] will return null, to avoid problem, we remove it.
            val art = albumData["album_art"].toString()
            if (art.isEmpty()) albumData.remove("album_art")
            albumList.add(albumData)
        }
        cursor?.close()
        return@withContext albumList
    }
}

//I/OnAlbumCursor[All/Audio]: [
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