package com.lucasjosino.on_audio_query.query

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
import com.lucasjosino.on_audio_query.OnAudioQueryPlugin
import com.lucasjosino.on_audio_query.query.helper.OnAudioHelper
import com.lucasjosino.on_audio_query.types.checkArtworkFormat
import com.lucasjosino.on_audio_query.types.checkArtworkType
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.io.ByteArrayOutputStream
import java.io.FileInputStream
import kotlin.properties.Delegates

/** OnArtworksQuery */
class OnArtworksQuery : ViewModel() {

    //Main parameters
    private var id: Number = 0
    private var size by Delegates.notNull<Int>()

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
        // Check format:
        //   * [0]: JPEG
        //   * [1]: PNG
        format = checkArtworkFormat(call.argument<Int>("format")!!)
        // Check uri:
        //   * [0]: Song.
        //   * [1]: Album.
        uri = checkArtworkType(call.argument<Int>("type")!!)

        // Query everything in background for a better performance.
        viewModelScope.launch {
            // Request permission status from the main method.
            val hasPermission = OnAudioQueryPlugin().onPermissionStatus(context)
            // Empty array.
            var resultArtList: ByteArray? = null

            // We cannot "query" without permission so, just return null.
            if (hasPermission) {
                // Start querying
                resultArtList = loadArt()
            }

            //Flutter UI will start, but, information still loading
            result.success(resultArtList)
        }
    }

    //Loading in Background
    @Suppress("BlockingMethodInNonBlockingContext")
    private suspend fun loadArt(): ByteArray? = withContext(Dispatchers.IO) {
        // Empty array.
        var artData: ByteArray? = null

        // In this case we need check the [Android] version and then, "query" the artwork.
        //
        // If [Android] >= 29/Q:
        //   * We have a limited access to files/folders and we use [loadThumbnail].
        // If [Android] < 29/Q:
        //   * We use the [embeddedPicture] from [MediaMetadataRetriever] to get the image.
        if (Build.VERSION.SDK_INT >= 29) {
            // Due old problems with [MethodChannel] the [id] is defined as [Number].
            // Here we convert to [Long]
            val query = ContentUris.withAppendedId(uri, id.toLong())

            // Try / Catch to avoid problems.
            try {
                val bitmap = resolver.loadThumbnail(query, Size(size, size), null)
                artData = convertOrResize(bitmap = bitmap)!!
            } catch (e: Exception) {
                // Some problem can occur, we hide to not "flood" the terminal.
//                Log.i("on_audio_error: ", e.toString())
            }

        } else {
            // If [uri == Audio]:
            //   * Load the first [item] from cursor using the [id] as filter.
            // else:
            //   * Load the first [item] from [album] using the [id] as filter.
            //
            // If [item] return null, no song/album has found, just return null.
            val item = OnAudioHelper().loadFirstItem(uri, id.toString(), resolver)
            if (item != null) {

                // Try / Catch to avoid problems.
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
                    if (image != null) artData = convertOrResize(byteArray = image)

                    // [close] can only be called using [Android] >= 29/Q.
                    if (Build.VERSION.SDK_INT >= 29) metadata.close()
                } catch (e: Exception) {
                    // Some problem can occur, we hide to not "flood" the terminal.
//                Log.i("on_audio_error: ", e.toString())
                }

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
                // TODO: Add option to choose the image quality.
                bitmap.compress(format, 100, byteArrayBase)
            } else {
                val convertedBitmap = BitmapFactory.decodeByteArray(byteArray, 0, byteArray!!.size)
                convertedBitmap.compress(format, 100, byteArrayBase)
            }
        } catch (e: Exception) {
            //Log.i("Error", e.toString())
        }
        convertedBytes = byteArrayBase.toByteArray()
        byteArrayBase.close()
        return convertedBytes
    }
}