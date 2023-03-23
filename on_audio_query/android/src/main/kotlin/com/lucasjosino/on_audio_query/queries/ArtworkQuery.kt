package com.lucasjosino.on_audio_query.queries

import android.content.ContentResolver
import android.content.ContentUris
import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.media.MediaMetadataRetriever
import android.net.Uri
import android.os.Build
import android.util.Size
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.lucasjosino.on_audio_query.controller.PermissionController
import com.lucasjosino.on_audio_query.queries.helper.QueryHelper
import com.lucasjosino.on_audio_query.types.checkArtworkFormat
import com.lucasjosino.on_audio_query.types.checkArtworkType
import io.flutter.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.io.ByteArrayOutputStream
import java.io.FileInputStream

/** OnArtworksQuery */
class ArtworkQuery : ViewModel() {

    companion object {
        private const val TAG = "OnArtworksQuery"
    }

    //Main parameters
    private val helper = QueryHelper()
    private var type: Int = -1
    private var id: Number = 0
    private var quality: Int = 100
    private var size: Int = 200

    // None of this methods can be null.
    private lateinit var uri: Uri
    private lateinit var resolver: ContentResolver
    private lateinit var format: Bitmap.CompressFormat

    /**
     * Method to "query" all albums.
     *
     * Parameters:
     *   * [context]
     *   * [result]
     *   * [call]
     */
    fun queryArtwork(context: Context, result: MethodChannel.Result, call: MethodCall) {
        resolver = context.contentResolver

        // The [id] of the song/album. If the [size] is null, will be [200].
        id = call.argument<Number>("id")!!; size = call.argument<Int>("size")!!
        // Define the quality of image.
        // The [quality] value cannot be greater than 100 so, we check and if is, set to [100].
        quality = call.argument<Int>("quality")!!
        if (quality > 100) quality = 100
        // Check format:
        //   * [0]: JPEG
        //   * [1]: PNG
        format = checkArtworkFormat(call.argument<Int>("format")!!)
        // Check uri:
        //   * [0]: Song.
        //   * [1]: Album.
        //   * [2]: Playlist.
        //   * [3]: Artist.
        //   * [4]: Genre.
        uri = checkArtworkType(call.argument<Int>("type")!!)
        // Define the [type]:
        type = call.argument<Int>("type")!!

        Log.d(TAG, "Query config: ")
        Log.d(TAG, "\tid: $id")
        Log.d(TAG, "\tquality: $quality")
        Log.d(TAG, "\tformat: $format")
        Log.d(TAG, "\turi: $uri")
        Log.d(TAG, "\ttype: $type")

        // Request permission status;
        val hasPermission: Boolean = PermissionController().permissionStatus(context)

        // We cannot 'query' without permission so, throw a PlatformException.
        if (!hasPermission) {
            result.error(
                "403",
                "The app doesn't have permission to read files.",
                "Call the [permissionsRequest] method or install a external plugin to handle the app permission."
            )
            return
        }

        // Query everything in background for a better performance.
        viewModelScope.launch {
            // Start querying
            var resultArtList: ByteArray? = loadArt()

            // Sometimes android will extract a 'wrong' or 'empty' artwork. Just set as null.
            if (resultArtList != null && resultArtList.isEmpty()) {
                Log.i(TAG, "Artwork for '$id' is empty. Returning null")
                resultArtList = null
            }

            // After loading the information, send the 'result'.
            result.success(resultArtList)
        }
    }

    //Loading in Background
    @Suppress("BlockingMethodInNonBlockingContext")
    private suspend fun loadArt(): ByteArray? = withContext(Dispatchers.IO) {
        // Empty array.
        var artData: ByteArray? = null

        // In this case we need check the [Android] version and query [type].
        //
        // If [Android] >= 29/Q:
        //   * We have a limited access to files/folders and we use [loadThumbnail].
        // If [Android] < 29/Q:
        //   * We use the [embeddedPicture] from [MediaMetadataRetriever] to get the image.
        if (Build.VERSION.SDK_INT >= 29) {
            // Try / Catch to avoid problems.
            try {
                // If [type] is 2, 3 or 4, we need to 'get' the first item from playlist or artist.
                // We'll use the first artist song to 'simulate' the artwork.
                //
                // Type:
                //   * [2]: Playlist.
                //   * [3]: Artist.
                //   * [4]: Genre.
                //
                // Due old problems with [MethodChannel] the [id] is defined as [Number].
                // Here we convert to [Long]
                val query = if (type == 2 || type == 3 || type == 4) {
                    val item = helper.loadFirstItem(type, id, resolver) ?: return@withContext null
                    ContentUris.withAppendedId(uri, item.toLong())
                } else {
                    ContentUris.withAppendedId(uri, id.toLong())
                }

                val bitmap = resolver.loadThumbnail(query, Size(size, size), null)
                artData = convertOrResize(bitmap = bitmap)!!
            } catch (e: Exception) {
                Log.w(TAG, "($id) Message: $e")
            }
        } else {
            // If [uri == Audio]:
            //   * Load the first [item] from cursor using the [id] as filter.
            // else:
            //   * Load the first [item] from [album] using the [id] as filter.
            //
            // If [item] return null, no song/album has found, just return null.
            val item = helper.loadFirstItem(type, id, resolver) ?: return@withContext null
            try {
                // I tried both [_data] and [_uri], none of them work.
                // So we use the [_data] inside the [FileInputStream] and take the
                // [fd(FileDescriptor)].
                val file = FileInputStream(item)
                val metadata = MediaMetadataRetriever()

                // Most of the cases the error occurred here.
                metadata.setDataSource(file.fd)
                val image = metadata.embeddedPicture

                // Check if [image] null.
                artData = convertOrResize(byteArray = image) ?: return@withContext null

                // [close] can only be called using [Android] >= 29/Q.
                if (Build.VERSION.SDK_INT >= 29) metadata.close()
            } catch (e: Exception) {
                Log.w(TAG, "($id) Message: $e")
            }
        }
        // After finish the "query", go back to the "main" thread(You can only call flutter
        // inside the main thread).
        return@withContext artData
    }

    //
    private fun convertOrResize(bitmap: Bitmap? = null, byteArray: ByteArray? = null): ByteArray? {
        val convertedBytes: ByteArray?
        val byteArrayBase = ByteArrayOutputStream()
        try {
            // If [bitmap] isn't null:
            //   * The image(bitmap) is from first method. (Android >= 29/Q).
            // else:
            //   * The image(bytearray) is from second method. (Android < 29/Q).
            if (bitmap != null) {
                bitmap.compress(format, quality, byteArrayBase)
            } else {
                val convertedBitmap = BitmapFactory.decodeByteArray(byteArray, 0, byteArray!!.size)
                convertedBitmap.compress(format, quality, byteArrayBase)
            }
        } catch (e: Exception) {
            Log.w(TAG, "($id) Message: $e")
        }

        convertedBytes = byteArrayBase.toByteArray()
        byteArrayBase.close()
        return convertedBytes
    }
}