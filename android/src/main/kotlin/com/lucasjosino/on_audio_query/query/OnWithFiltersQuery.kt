package com.lucasjosino.on_audio_query.query

import android.annotation.SuppressLint
import android.content.ContentResolver
import android.content.Context
import android.net.Uri
import android.provider.MediaStore
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.lucasjosino.on_audio_query.extras.loadArtwork
import com.lucasjosino.on_audio_query.types.*
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class OnWithFiltersQuery : ViewModel() {

    //Main parameters
    private var projection: Array<String>? = arrayOf()
    private lateinit var resolver: ContentResolver
    @SuppressLint("StaticFieldLeak")
    private lateinit var context: Context
    private lateinit var resultWithFiltersList: ArrayList<MutableMap<String, Any>>
    private lateinit var withType: Uri
    private lateinit var args: String
    private lateinit var argsKey: String

    //
    fun queryWithFilters(context: Context, result: MethodChannel.Result, call: MethodCall) {
        this.context = context ;  resolver = context.contentResolver

        //Setup Type and Args
        withType = checkWithFiltersType(call.argument<Int>("withType")!!)
        args = call.argument<String>("argsVal")!! + "%"
        projection = checkProjection(withType)

        //Setup Args
        argsKey = when (withType) {
            MediaStore.Audio.Media.EXTERNAL_CONTENT_URI -> checkSongsArgs(call.argument<Int>("args")!!)
            MediaStore.Audio.Albums.EXTERNAL_CONTENT_URI -> checkAlbumsArgs(call.argument<Int>("args")!!)
            MediaStore.Audio.Playlists.EXTERNAL_CONTENT_URI -> checkPlaylistsArgs(call.argument<Int>("args")!!)
            MediaStore.Audio.Artists.EXTERNAL_CONTENT_URI -> checkArtistsArgs(call.argument<Int>("args")!!)
            MediaStore.Audio.Genres.EXTERNAL_CONTENT_URI -> checkGenresArgs(call.argument<Int>("args")!!)
            else -> throw Exception("[argsKey] returned null. Report this issue on [on_audio_query] GitHub.")
        }

        //Query everything in the Background it's necessary for better performance
        viewModelScope.launch {
            //Start querying
            resultWithFiltersList = loadSongsWithFilters()

            //
            result.success(resultWithFiltersList) }
    }

    //Loading in Background
    private suspend fun loadSongsWithFilters() : ArrayList<MutableMap<String, Any>> = withContext(Dispatchers.IO) {
        val cursor = resolver.query(withType, projection, argsKey, arrayOf(args), null)
        val withFiltersList: ArrayList<MutableMap<String, Any>> = ArrayList()
        while (cursor != null && cursor.moveToNext()) {
            val withFiltersData: MutableMap<String, Any> = HashMap()
            for (audioMedia in cursor.columnNames) {
                if (cursor.getString(cursor.getColumnIndex(audioMedia)) != null) {
                    withFiltersData[audioMedia] = cursor.getString(cursor.getColumnIndex(audioMedia))
                } else withFiltersData[audioMedia] = ""
            }

            if (withType == MediaStore.Audio.Media.EXTERNAL_CONTENT_URI) {
                //Artwork
                val art = loadArtwork(context, withFiltersData["album"].toString())
                if (art.isNotEmpty()) withFiltersData["artwork"] = art
                withFiltersList.add(withFiltersData)
            } else withFiltersList.add(withFiltersData)
        }
        cursor?.close()
        return@withContext withFiltersList
    }
}