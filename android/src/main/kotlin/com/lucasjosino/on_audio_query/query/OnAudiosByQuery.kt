package com.lucasjosino.on_audio_query.query

import android.annotation.SuppressLint
import android.content.ContentResolver
import android.content.ContentUris
import android.content.Context
import android.net.Uri
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.lucasjosino.on_audio_query.types.checkAudiosUriType
import com.lucasjosino.on_audio_query.types.checkSongsByType
import com.lucasjosino.on_audio_query.types.songProjection
import com.lucasjosino.on_audio_query.utils.getExtraInfo
import com.lucasjosino.on_audio_query.utils.loadArtwork
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class OnAudiosByQuery : ViewModel() {

    //Main parameters
    private lateinit var uri: Uri
    private lateinit var resolver: ContentResolver
    private lateinit var where: String
    private lateinit var whereVal: ArrayList<String>
    @SuppressLint("StaticFieldLeak")
    private lateinit var context: Context

    fun querySongsBy(context: Context, result: MethodChannel.Result, call: MethodCall) {
        this.context = context ; this.resolver = context.contentResolver

        uri = checkAudiosUriType(call.argument<Int>("uri")!!)
        where = checkSongsByType(call.argument<Int>("by")!!)
        whereVal = call.argument("values")!!

        //Query everything in the Background it's necessary for better performance
        viewModelScope.launch {
            //Start querying
            val resultSongsByList = loadSongsBy()

            //Flutter UI will start, but, information still loading
            result.success(resultSongsByList)
        }
    }

    private suspend fun loadSongsBy() : ArrayList<MutableMap<String, Any>> = withContext(Dispatchers.IO) {
        val songByList: ArrayList<MutableMap<String, Any>> = ArrayList()
        for (value in whereVal) {
            val cursor = resolver.query(uri, songProjection, where, arrayOf(value), null)
            while (cursor != null && cursor.moveToNext()) {
                val songsByData: MutableMap<String, Any> = HashMap()
                for (audioMedia in cursor.columnNames) {
                    if (cursor.getString(cursor.getColumnIndex(audioMedia)) != null) {
                        songsByData[audioMedia] = cursor.getString(cursor.getColumnIndex(audioMedia))
                    } else songsByData[audioMedia] = ""
                }

                //Artwork
                val art = loadArtwork(context, songsByData["album"].toString())
                if (art.isNotEmpty()) songsByData["artwork"] = art

                //Extra information from song
                val extraInfo = getExtraInfo(songsByData["_data"].toString())
                songsByData.putAll(extraInfo)

                //
                val uri = ContentUris.withAppendedId(uri, songsByData["_id"].toString().toLong())
                songsByData["_uri"] = uri.toString()

                songByList.add(songsByData)
            }
            cursor?.close()
        }
        return@withContext songByList
    }
}