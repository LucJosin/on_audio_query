package com.lucasjosino.on_audio_query.query

import android.annotation.SuppressLint
import android.content.ContentResolver
import android.content.Context
import android.net.Uri
import android.provider.MediaStore
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.lucasjosino.on_audio_query.utils.loadArtwork
import com.lucasjosino.on_audio_query.types.checkAudiosOnlyType
import com.lucasjosino.on_audio_query.types.songProjection
import com.lucasjosino.on_audio_query.types.sorttypes.checkSongSortType
import com.lucasjosino.on_audio_query.utils.getExtraInfo
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.io.File

class OnAudiosOnlyQuery : ViewModel() {

    //Main parameters
    private val uri: Uri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI
    private var isOnly: String? = null
    private lateinit var resolver: ContentResolver
    private lateinit var sortType: String
    @SuppressLint("StaticFieldLeak")
    private lateinit var context: Context

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
        val cursor = resolver.query(uri, songProjection, isOnly, null, sortType)
        val audiosOnlyList: ArrayList<MutableMap<String, Any>> = ArrayList()
        while (cursor != null && cursor.moveToNext()) {
            val audiosData: MutableMap<String, Any> = HashMap()
            for (audioMedia in cursor.columnNames) {
                if (cursor.getString(cursor.getColumnIndex(audioMedia)) != null) {
                    audiosData[audioMedia] = cursor.getString(cursor.getColumnIndex(audioMedia))
                } else audiosData[audioMedia] = ""
            }

            //Artwork
            val art = loadArtwork(context, audiosData["album"].toString())
            if (art.isNotEmpty()) audiosData["artwork"] = art

            //Extra information from song
            val extraInfo = getExtraInfo(audiosData["_data"].toString())
            audiosData.putAll(extraInfo)

            audiosOnlyList.add(audiosData)
        }
        cursor?.close()
        return@withContext audiosOnlyList
    }
}