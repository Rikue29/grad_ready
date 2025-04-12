package com.example.gradready_interview

import android.media.AudioFormat
import android.media.AudioRecord
import android.media.MediaRecorder
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import java.nio.ByteBuffer
import kotlinx.coroutines.*

class AudioStreamHandler : EventChannel.StreamHandler {
    private var audioRecord: AudioRecord? = null
    private var isRecording = false
    private val scope = CoroutineScope(Dispatchers.IO + Job())
    private val sampleRate = 16000
    private val channelConfig = AudioFormat.CHANNEL_IN_MONO
    private val audioFormat = AudioFormat.ENCODING_PCM_16BIT

    override fun onListen(arguments: Any?, events: EventSink) {
        val bufferSize = AudioRecord.getMinBufferSize(sampleRate, channelConfig, audioFormat)
        
        try {
            audioRecord = AudioRecord(
                MediaRecorder.AudioSource.MIC,
                sampleRate,
                channelConfig,
                audioFormat,
                bufferSize
            )

            val buffer = ByteBuffer.allocateDirect(bufferSize)
            isRecording = true

            scope.launch {
                audioRecord?.startRecording()

                while (isRecording) {
                    val bytesRead = audioRecord?.read(buffer, bufferSize) ?: -1
                    if (bytesRead > 0) {
                        val audioData = ByteArray(bytesRead)
                        buffer.get(audioData)
                        buffer.clear()
                        
                        withContext(Dispatchers.Main) {
                            events.success(audioData)
                        }
                    }
                }
            }
        } catch (e: Exception) {
            events.error("AUDIO_RECORD_ERROR", e.message, null)
        }
    }

    override fun onCancel(arguments: Any?) {
        isRecording = false
        audioRecord?.stop()
        audioRecord?.release()
        audioRecord = null
        scope.cancel()
    }
}
