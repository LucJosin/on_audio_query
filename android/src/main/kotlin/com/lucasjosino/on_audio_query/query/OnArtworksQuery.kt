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
    private lateinit var uri: Uri
    private lateinit var resolver: ContentResolver
    private lateinit var format: Bitmap.CompressFormat

    //
    fun queryArtwork(context: Context, result: MethodChannel.Result, call: MethodCall) {
        resolver = context.contentResolver

        //Id, size, and uri
        id = call.argument<Number>("id")!!; size = call.argument<Int>("size")!!
        format = checkArtworkFormat(call.argument<Int>("format")!!)
        uri = checkArtworkType(call.argument<Int>("type")!!)

        //Query everything in the Background it's necessary for better performance
        viewModelScope.launch {
            //Start querying
            val resultArtList: ByteArray? = loadArt()

            //Flutter UI will start, but, information still loading
            result.success(resultArtList)
        }
    }

    //Loading in Background
    @Suppress("BlockingMethodInNonBlockingContext")
    private suspend fun loadArt(): ByteArray? = withContext(Dispatchers.IO) {
        var artData: ByteArray? = null
        if (Build.VERSION.SDK_INT >= 29) {
            val query = ContentUris.withAppendedId(uri, id.toLong())
            try {
                val bitmap = resolver.loadThumbnail(query, Size(size, size), null)
                artData = convertOrResize(bitmap = bitmap)!!
            } catch (e: Exception) {
//            Log.i("OnAudioError", e.toString())
            }
        } else {
            val item = OnAudioHelper().loadFirstItem(uri, id.toString(), resolver)
            if (item != null) {
                try {
                    val file = FileInputStream(item)
                    val metadata = MediaMetadataRetriever()
                    metadata.setDataSource(file.fd)
                    val image = metadata.embeddedPicture
                    if (image != null) {
                        artData = convertOrResize(byteArray = image)
                    }
                } catch (e: Exception) {
//                Log.i("on_audio_error", e.toString())
                }
            }
        }
        return@withContext artData
    }

    //
    private fun convertOrResize(bitmap: Bitmap? = null, byteArray: ByteArray? = null): ByteArray? {
        val convertedBytes: ByteArray?
        val byteArrayBase = ByteArrayOutputStream()
        try {
            if (bitmap != null) {
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