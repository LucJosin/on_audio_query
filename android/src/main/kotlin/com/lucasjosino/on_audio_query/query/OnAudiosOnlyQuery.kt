package com.lucasjosino.on_audio_query.query

import android.annotation.SuppressLint
import android.content.ContentResolver
import android.content.Context
import android.net.Uri
import android.provider.MediaStore
import android.util.Log
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.lucasjosino.on_audio_query.extras.loadArtwork
import com.lucasjosino.on_audio_query.types.checkAudiosOnlyType
import com.lucasjosino.on_audio_query.types.sorttypes.checkSongSortType
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class OnAudiosOnlyQuery : ViewModel() {

    //Main parameters
    private val uri: Uri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI
    private var isOnly: String? = null
    private lateinit var resolver: ContentResolver
    private lateinit var sortType: String
    @SuppressLint("StaticFieldLeak")
    private lateinit var context: Context

    //Query projection
    @SuppressLint("InlinedApi")
    private val projection = arrayOf(
            MediaStore.Audio.Media.DATA, //
            MediaStore.Audio.Media.DISPLAY_NAME,
            MediaStore.Audio.Media._ID,
            MediaStore.Audio.Media.SIZE,
            MediaStore.Audio.Media.ALBUM,
            MediaStore.Audio.Media.ALBUM_ARTIST,
            MediaStore.Audio.Media.ALBUM_ID,
//            MediaStore.Audio.Media.ALBUM_KEY,
            MediaStore.Audio.Media.ARTIST,
            MediaStore.Audio.Media.ARTIST_ID,
//            MediaStore.Audio.Media.ARTIST_KEY,
            MediaStore.Audio.Media.BOOKMARK,
            MediaStore.Audio.Media.COMPOSER,
            MediaStore.Audio.Media.DATE_ADDED,
            MediaStore.Audio.Media.DURATION,
            MediaStore.Audio.Media.TITLE,
            MediaStore.Audio.Media.TRACK,
            MediaStore.Audio.Media.YEAR,
            MediaStore.Audio.Media.IS_ALARM,
            MediaStore.Audio.Media.IS_MUSIC, // 17
            MediaStore.Audio.Media.IS_NOTIFICATION,
            MediaStore.Audio.Media.IS_PODCAST,
            MediaStore.Audio.Media.IS_RINGTONE
    )

    //querySongs and queryAudios together
    fun queryAudiosOnly(context: Context, result: MethodChannel.Result, call: MethodCall) {
        this.context = context ; resolver = context.contentResolver

        //isOnly: Specifics audios.
        isOnly = checkAudiosOnlyType(call.argument<Int>("isOnly")!!)
        //SortType: Type and Order
        sortType = checkSongSortType(call.argument<Int>("sortType")!!, call.argument<Int>("orderType")!!)

        //Query everything in the Background it's necessary for better performance
        viewModelScope.launch {
            //Start querying
            val resultAudiosOnlyList = loadAudiosOnly()

            //Flutter UI will start, but, information still loading
            result.success(resultAudiosOnlyList)
        }
    }

    //Loading in Background
    private suspend fun loadAudiosOnly() : ArrayList<MutableMap<String, Any>> = withContext(Dispatchers.IO) {
        val cursor = resolver.query(uri, projection, isOnly, null, sortType)
        val audiosOnlyList: ArrayList<MutableMap<String, Any>> = ArrayList()
        while (cursor != null && cursor.moveToNext()) {
            val audiosData: MutableMap<String, Any> = HashMap()
            for (audioMedia in cursor.columnNames) {
                if (cursor.getString(cursor.getColumnIndex(audioMedia)) != null) {
                    audiosData[audioMedia] = cursor.getString(cursor.getColumnIndex(audioMedia))
                } else audiosData[audioMedia] = ""
            }

            Log.i("Data", audiosData.toString())

            //Artwork
            val art = loadArtwork(context, audiosData["album"].toString())
            if (art.isNotEmpty()) audiosData["artwork"] = art
            audiosOnlyList.add(audiosData)
        }
        cursor?.close()
        return@withContext audiosOnlyList
    }
}