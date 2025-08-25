package ru.example.app
import android.os.Bundle
import android.content.Context
import android.media.AudioManager
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
        audioManager.abandonAudioFocus(null)
        audioManager.mode = AudioManager.MODE_NORMAL
    }
}



