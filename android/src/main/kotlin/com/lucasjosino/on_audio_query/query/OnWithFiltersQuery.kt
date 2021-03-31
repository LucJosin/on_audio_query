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
    private val channelError = "on_audio_error"
    private lateinit var resolver: ContentResolver
    @SuppressLint("StaticFieldLeak")
    private lateinit var context: Context
    private lateinit var resultWithFiltersList: ArrayList<MutableMap<String, Any>>
    private lateinit var withType: Uri
    private lateinit var args: String
    private lateinit var argsKey:String

    //Uri projection
    private val withTypeProjection = arrayOf(
            MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
            MediaStore.Audio.Albums.EXTERNAL_CONTENT_URI,
            MediaStore.Audio.Playlists.EXTERNAL_CONTENT_URI,
            MediaStore.Audio.Artists.EXTERNAL_CONTENT_URI,
            MediaStore.Audio.Genres.EXTERNAL_CONTENT_URI
    )

    //Query songs projection
    @SuppressLint("InlinedApi")
    private val songProjection = arrayOf(
            MediaStore.Audio.Media.DATA, //
            MediaStore.Audio.Media.DISPLAY_NAME,
            MediaStore.Audio.Media._ID,
            MediaStore.Audio.Media.SIZE,
            MediaStore.Audio.Media.ALBUM,
            MediaStore.Audio.Media.ALBUM_ARTIST,
            MediaStore.Audio.Media.ALBUM_ID,
            MediaStore.Audio.Media.ARTIST,
            MediaStore.Audio.Media.ARTIST_ID,
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

    //Query playlists projection
    private val playlistProjection = arrayOf(
            MediaStore.Audio.Playlists.DATA,
            MediaStore.Audio.Playlists._ID,
            MediaStore.Audio.Playlists.DATE_ADDED,
            MediaStore.Audio.Playlists.DATE_MODIFIED,
            MediaStore.Audio.Playlists.NAME
    )

    //Query artists projection
    private val artistProjection = arrayOf(
            MediaStore.Audio.Artists._ID,
            MediaStore.Audio.Artists.ARTIST,
            MediaStore.Audio.Artists.NUMBER_OF_ALBUMS,
            MediaStore.Audio.Artists.NUMBER_OF_TRACKS
    )

    //Query genres projection
    private val genreProjection = arrayOf(
            MediaStore.Audio.Genres._ID,
            MediaStore.Audio.Genres.NAME
    )

    //
    fun queryWithFilters(context: Context, result: MethodChannel.Result, call: MethodCall) {
        this.context = context ;  resolver = context.contentResolver

        //Setup Type and Args
        withType = checkWithFiltersType(call.argument<Int>("withType")!!)
        args = call.argument<String>("argsVal")!! + "%"

        //
        when (withType) {
            //
            withTypeProjection[0] ->
                viewModelScope.launch { argsKey = checkSongsArgs(call.argument<Int>("args")!!)
                    resultWithFiltersList = loadSongsWithFilters() ; result.success(resultWithFiltersList) }

            //
            withTypeProjection[1] ->
                viewModelScope.launch { argsKey = checkAlbumsArgs(call.argument<Int>("args")!!)
                    resultWithFiltersList = loadAlbumsWithFilters() ; result.success(resultWithFiltersList) }

            //
            withTypeProjection[2] ->
                viewModelScope.launch { argsKey = checkPlaylistsArgs(call.argument<Int>("args")!!)
                    resultWithFiltersList = loadPlaylistsWithFilters() ; result.success(resultWithFiltersList) }

            //
            withTypeProjection[3] ->
                viewModelScope.launch { argsKey = checkArtistsArgs(call.argument<Int>("args")!!)
                    resultWithFiltersList = loadArtistsWithFilters() ; result.success(resultWithFiltersList) }

            //
            withTypeProjection[4] ->
                viewModelScope.launch { argsKey = checkGenresArgs(call.argument<Int>("args")!!)
                    resultWithFiltersList = loadGenresWithFilters() ; result.success(resultWithFiltersList) }

            //
            else -> result.error(channelError, "Filter type in [queryWithFilters] not found", null)
        }
    }

    //Loading in Background
    private suspend fun loadSongsWithFilters() : ArrayList<MutableMap<String, Any>> = withContext(Dispatchers.IO) {
        val cursor = resolver.query(withType, songProjection, argsKey, arrayOf(args), null)
        val withFiltersList: ArrayList<MutableMap<String, Any>> = ArrayList()
        while (cursor != null && cursor.moveToNext()) {
            val withFiltersData: MutableMap<String, Any> = HashMap()
            for (audioMedia in cursor.columnNames) {
                if (cursor.getString(cursor.getColumnIndex(audioMedia)) != null) {
                    withFiltersData[audioMedia] = cursor.getString(cursor.getColumnIndex(audioMedia))
                } else withFiltersData[audioMedia] = ""
            }

            //Artwork
            val art = loadArtwork(context, withFiltersData["album"].toString())
            if (art.isNotEmpty()) withFiltersData["artwork"] = art
            withFiltersList.add(withFiltersData)
        }
        cursor?.close()
        return@withContext withFiltersList
    }

    //Loading in Background
    private suspend fun loadAlbumsWithFilters() : ArrayList<MutableMap<String, Any>> = withContext(Dispatchers.IO) {
        val cursor = resolver.query(withType, null, argsKey, arrayOf(args), null)
        val withFiltersList: ArrayList<MutableMap<String, Any>> = ArrayList()
        while (cursor != null && cursor.moveToNext()) {
            val withFiltersData: MutableMap<String, Any> = HashMap()
            for (audioMedia in cursor.columnNames) {
                if (cursor.getString(cursor.getColumnIndex(audioMedia)) != null) {
                    withFiltersData[audioMedia] = cursor.getString(cursor.getColumnIndex(audioMedia))
                } else withFiltersData[audioMedia] = ""
            }
            withFiltersList.add(withFiltersData)
        }
        cursor?.close()
        return@withContext withFiltersList
    }

    //Loading in Background
    private suspend fun loadArtistsWithFilters() : ArrayList<MutableMap<String, Any>> = withContext(Dispatchers.IO) {
        val cursor = resolver.query(withType, artistProjection, argsKey, arrayOf(args), null)
        val withFiltersList: ArrayList<MutableMap<String, Any>> = ArrayList()
        while (cursor != null && cursor.moveToNext()) {
            val withFiltersData: MutableMap<String, Any> = HashMap()
            for (audioMedia in cursor.columnNames) {
                if (cursor.getString(cursor.getColumnIndex(audioMedia)) != null) {
                    withFiltersData[audioMedia] = cursor.getString(cursor.getColumnIndex(audioMedia))
                } else withFiltersData[audioMedia] = ""
            }
            withFiltersList.add(withFiltersData)
        }
        cursor?.close()
        return@withContext withFiltersList
    }

    //Loading in Background
    private suspend fun loadPlaylistsWithFilters() : ArrayList<MutableMap<String, Any>> = withContext(Dispatchers.IO) {
        val cursor = resolver.query(withType, playlistProjection, argsKey, arrayOf(args), null)
        val withFiltersList: ArrayList<MutableMap<String, Any>> = ArrayList()
        while (cursor != null && cursor.moveToNext()) {
            val withFiltersData: MutableMap<String, Any> = HashMap()
            for (audioMedia in cursor.columnNames) {
                if (cursor.getString(cursor.getColumnIndex(audioMedia)) != null) {
                    withFiltersData[audioMedia] = cursor.getString(cursor.getColumnIndex(audioMedia))
                } else withFiltersData[audioMedia] = ""
            }
            withFiltersList.add(withFiltersData)
        }
        cursor?.close()
        return@withContext withFiltersList
    }

    //Loading in Background
    private suspend fun loadGenresWithFilters() : ArrayList<MutableMap<String, Any>> = withContext(Dispatchers.IO) {
        val cursor = resolver.query(withType, genreProjection, argsKey, arrayOf(args), null)
        val withFiltersList: ArrayList<MutableMap<String, Any>> = ArrayList()
        while (cursor != null && cursor.moveToNext()) {
            val withFiltersData: MutableMap<String, Any> = HashMap()
            for (audioMedia in cursor.columnNames) {
                if (cursor.getString(cursor.getColumnIndex(audioMedia)) != null) {
                    withFiltersData[audioMedia] = cursor.getString(cursor.getColumnIndex(audioMedia))
                } else withFiltersData[audioMedia] = ""
            }
            withFiltersList.add(withFiltersData)
        }
        cursor?.close()
        return@withContext withFiltersList
    }
}