package net.tangibleidea.instangible.instangible

import android.content.Intent
import android.net.Uri
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity: FlutterActivity() {
    private val INSTA_CHANNEL= "instangible/shareinsta"
    private lateinit var channel: MethodChannel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        channel= MethodChannel(flutterEngine.dartExecutor.binaryMessenger, INSTA_CHANNEL)
        channel.setMethodCallHandler { call, result ->
            when(call.method) {
                "sharePhotoToInstagram"-> {
                    val imagePath: String? = call.argument("imagePath")

                    if (imagePath != null) {
                        //val imageUri = getUri(imagePath)
                        createInstagramIntent("image/*", imagePath)
                        result.success("Share feed success")
                        return@setMethodCallHandler
                    }
                }
                "getPlatformVersion" -> {
                    result.success("Android ${android.os.Build.VERSION.RELEASE}")
                    return@setMethodCallHandler
                }

                "shareInstagramImageStoryWithSticker" -> {

                    val stickerPath: String? = call.argument("imagePath")

                    if (stickerPath != null) {
                        val stickerUri = getUri(stickerPath)
                        shareInstagramImageStoryWithSticker(stickerUri)

                        result.success("Send video and sticker with success22222")
                        return@setMethodCallHandler
                    }
                }
                else-> result.notImplemented()
            }

        }
    }

    private fun createInstagramIntent(type: String, mediaPath: String) {

        // Create the new Intent using the 'Send' action.
        val share = Intent(Intent.ACTION_SEND)

        // Set the MIME type
        share.setType(type)

        // Create the URI from the media
        val media = File(mediaPath)
        val uri: Uri = Uri.fromFile(media)

        // Add the URI to the Intent.
        share.putExtra(Intent.EXTRA_STREAM, uri)

        // Broadcast the Intent.
        startActivity(Intent.createChooser(share, "Share to"))
    }

    private fun getUri(filePath: String): Uri {
        val file = File(filePath)
        return FileProvider.getUriForFile(
            context,
            context.packageName.toString() + ".provider",
            file
        )
    }


    private fun shareInstagramImageStoryWithSticker(uriSticker: Uri) {

        val storiesIntent = Intent("com.instagram.share.ADD_TO_STORY").apply {
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            setPackage("com.instagram.android")
            setDataAndType(uriSticker, "image/*")
            //putExtra("interactive_asset_uri", uriSticker)
            putExtra("content_url", "something")
            putExtra("top_background_color", "#000000")
            putExtra("bottom_background_color", "#000000")
        }

        context.grantUriPermission(
            "com.instagram.android",
            uriSticker,
            Intent.FLAG_GRANT_READ_URI_PERMISSION
        )
        context.startActivity(storiesIntent)
    }

}
