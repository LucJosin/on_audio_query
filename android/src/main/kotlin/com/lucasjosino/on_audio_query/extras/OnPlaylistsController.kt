package com.lucasjosino.on_audio_query.extras

import android.content.ContentResolver
import android.content.ContentUris
import android.content.ContentValues
import android.content.Context
import android.net.Uri
import android.provider.MediaStore
import android.util.Log
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

/** OnPlaylistsController */
class OnPlaylistsController : ViewModel() {

    //Main parameters
    private val uri = MediaStore.Audio.Playlists.EXTERNAL_CONTENT_URI
    private val contentValues = ContentValues()
    private val channelError = "on_audio_error"
    private var sUri: Uri = MediaStore.Audio.Playlists.EXTERNAL_CONTENT_URI
    private val projection = arrayOf("max(" + MediaStore.Audio.Playlists.Members.PLAY_ORDER + ")")
    private lateinit var resolver: ContentResolver

    //Query projection
    private val columns = arrayOf(
            "count(*)"
    )

    //
    fun createPlaylist(context: Context, result: MethodChannel.Result, call: MethodCall) {
        this.resolver = context.contentResolver
        val playlistName = call.argument<String>("playlistName")!!

        //For create we don't check if name already exist
        contentValues.put(MediaStore.Audio.Playlists.NAME, playlistName)
        contentValues.put(MediaStore.Audio.Playlists.DATE_ADDED, System.currentTimeMillis())
        resolver.insert(uri, contentValues)
        result.success(true)
    }

    //
    fun removePlaylist(context: Context, result: MethodChannel.Result, call: MethodCall) {
        this.resolver = context.contentResolver
        val playlistId = call.argument<Int>("playlistId")!!

        //Check if Playlist exists based in Id
        if (!checkPlaylistId(playlistId)) result.success(false)
        else {
            val delUri = ContentUris.withAppendedId(uri, playlistId.toLong())
            resolver.delete(delUri, null, null)
            result.success(true)
        }
    }

    //TODO option for list
    //TODO Fix error on Android 10
    fun addToPlaylist(context: Context, result: MethodChannel.Result, call: MethodCall) {
        this.resolver = context.contentResolver
        val playlistId = call.argument<Int>("playlistId")!!
        val audioId = call.argument<Int>("audioId")!!

        //Check if Playlist exists based in Id
        if (!checkPlaylistId(playlistId)) result.success(false)
        else {
            val uri = MediaStore.Audio.Playlists.Members.getContentUri("external", playlistId.toLong())
            val cursor = resolver.query(uri, projection, null, null, null)
            var count = 0
            while (cursor != null && cursor.moveToNext()) {
                count = cursor.getInt(0) + 1
            }
            cursor?.close()
            //
            try {
                contentValues.put(MediaStore.Audio.Playlists.Members.PLAY_ORDER, count)
                contentValues.put(MediaStore.Audio.Playlists.Members.AUDIO_ID, audioId.toLong())
                resolver.insert(uri, contentValues)
                result.success(true)
            } catch (e: Exception) { Log.i(channelError, e.toString()) }
        }
    }

    //
    fun removeFromPlaylist(context: Context, result: MethodChannel.Result, call: MethodCall) {
        this.resolver = context.contentResolver
        val playlistId = call.argument<Int>("playlistId")!!
        val audioId = call.argument<Int>("audioId")!!

        //Check if Playlist exists based in Id
        if (!checkPlaylistId(playlistId)) result.success(false)
        else {
            val uri = MediaStore.Audio.Playlists.Members.getContentUri("external", playlistId.toLong())
            resolver.delete(uri, MediaStore.Audio.Playlists.Members.AUDIO_ID + " = " + audioId.toLong(), null)
            result.success(true)
        }
    }

    fun audiosFromPlaylist(context: Context, result: MethodChannel.Result, call: MethodCall) {
        this.resolver = context.contentResolver
        val playlistId = call.argument<Int>("playlistId")!!

        //Check if Playlist exists based in Id
        if (!checkPlaylistId(playlistId)) result.success(false)
        else {
            sUri = MediaStore.Audio.Playlists.Members.getContentUri("external", playlistId.toLong())

            //Query everything in the Background it's necessary for better performance
            viewModelScope.launch {
                //Start querying
                val resultSongsFromPl = loadSongsInPlaylist()

                //Flutter UI will start, but, information still loading
                result.success(resultSongsFromPl)
            }
        }
    }

    private suspend fun loadSongsInPlaylist() : ArrayList<MutableMap<String, Any>> = withContext(Dispatchers.IO) {
        val cursor = resolver.query(sUri, columns, null, null, null)
        val songsFromPlaylist: ArrayList<MutableMap<String, Any>> = ArrayList()
        while (cursor != null && cursor.moveToNext()) {
            val songFromPlData: MutableMap<String, Any> = HashMap()
            for (playlistMedia in cursor.columnNames) {
                if (cursor.getString(cursor.getColumnIndex(playlistMedia)) != null) {
                    songFromPlData[playlistMedia] = cursor.getString(cursor.getColumnIndex(playlistMedia))
                } else songFromPlData[playlistMedia] = ""
            }
            songsFromPlaylist.add(songFromPlData)
        }
        cursor?.close()
        Log.i("Pl", songsFromPlaylist.size.toString())
        return@withContext songsFromPlaylist
    }

    //TODO("Need tests")
    fun moveItemTo(context: Context, result: MethodChannel.Result, call: MethodCall) {
        this.resolver = context.contentResolver
        val playlistId = call.argument<Int>("playlistId")!!
        val from = call.argument<Int>("from")!!
        val to = call.argument<Int>("to")!!

        //Check if Playlist exists based in Id
        if (!checkPlaylistId(playlistId)) result.success(false)
        else {
            MediaStore.Audio.Playlists.Members.moveItem(resolver, playlistId.toLong(), from, to)
            result.success(true)
        }
    }

    //
    fun renamePlaylist(context: Context, result: MethodChannel.Result, call: MethodCall) {
        this.resolver = context.contentResolver
        val playlistId = call.argument<Int>("playlistId")!!
        val newPlaylistName = call.argument<String>("newPlName")!!

        //Check if Playlist exists based in Id
        if (!checkPlaylistId(playlistId)) result.success(false)
        else {
            contentValues.put(MediaStore.Audio.Playlists.NAME, newPlaylistName)
            contentValues.put(MediaStore.Audio.Playlists.DATE_MODIFIED, System.currentTimeMillis())
            resolver.update(uri, contentValues, "_id=${playlistId.toLong()}", null)
            result.success(true)
        }
    }

    //Return true if playlist already exist, false if don't exist
    private fun checkPlaylistId(plId: Int) : Boolean {
        val cursor = resolver.query(uri, arrayOf(MediaStore.Audio.Playlists.NAME, MediaStore.Audio.Playlists._ID), null, null, null)
        while (cursor != null && cursor.moveToNext()) {
            val playListId = cursor.getInt(1) //Id
            if (playListId == plId) return true
        }
        cursor?.close()
        return false
    }
}

//Extras:

//I/PlaylistCursor[All]: [
//  title_key
// instance_id
// playlist_id
// duration
// is_ringtone
// album_artist
// orientation
// artist
// height
// is_drm
// bucket_display_name
// is_audiobook
// owner_package_name
// volume_name
// title_resource_uri
// date_modified
// date_expires
// composer
// _display_name
// datetaken
// mime_type
// is_notification
// _id
// year
// _data
// _hash
// _size
// album
// is_alarm
// title
// track
// width
// is_music
// album_key
// is_trashed
// group_id
// document_id
// artist_id
// artist_key
// is_pending
// date_added
// audio_id
// is_podcast
// album_id
// primary_directory
// secondary_directory
// original_document_id
// bucket_id
// play_order
// bookmark
// relative_path
// ]