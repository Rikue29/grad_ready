package com.example.grad_ready

import android.media.AudioFormat
import android.media.AudioRecord
import android.media.MediaRecorder
import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.nio.ByteBuffer

class AudioStreamPlugin: FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private var audioRecord: AudioRecord? = null
    private var isRecording = false
    private var eventSink: EventChannel.EventSink? = null
    private val TAG = "AudioStreamPlugin"
    private val mainHandler = Handler(Looper.getMainLooper())

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        Log.d(TAG, "onAttachedToEngine called")
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.example.grad_ready/audio_stream")
        channel.setMethodCallHandler(this)

        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "com.example.grad_ready/audio_stream_events")
        eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                Log.d(TAG, "onListen called")
                eventSink = events
            }

            override fun onCancel(arguments: Any?) {
                Log.d(TAG, "onCancel called")
                eventSink = null
            }
        })
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        Log.d(TAG, "onMethodCall: ${call.method}")
        when (call.method) {
            "startAudioStream" -> {
                startAudioStream(result)
            }
            "stopAudioStream" -> {
                stopAudioStream(result)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun startAudioStream(result: Result) {
        Log.d(TAG, "startAudioStream called")
        if (isRecording) {
            Log.d(TAG, "Already recording, returning")
            result.success(null)
            return
        }

        try {
            val sampleRate = 16000
            val channelConfig = AudioFormat.CHANNEL_IN_MONO
            val audioFormat = AudioFormat.ENCODING_PCM_16BIT
            val bufferSize = AudioRecord.getMinBufferSize(sampleRate, channelConfig, audioFormat)
            
            Log.d(TAG, "Buffer size: $bufferSize")

            audioRecord = AudioRecord(
                MediaRecorder.AudioSource.MIC,
                sampleRate,
                channelConfig,
                audioFormat,
                bufferSize
            )

            if (audioRecord?.state != AudioRecord.STATE_INITIALIZED) {
                Log.e(TAG, "Failed to initialize audio recorder")
                result.error("AUDIO_ERROR", "Failed to initialize audio recorder", null)
                return
            }

            Log.d(TAG, "Starting recording")
            audioRecord?.startRecording()
            isRecording = true

            Thread {
                val buffer = ByteArray(bufferSize)
                while (isRecording) {
                    val read = audioRecord?.read(buffer, 0, bufferSize) ?: 0
                    if (read > 0) {
                        // Create a copy of the buffer to avoid data race
                        val data = buffer.copyOf(read)
                        // Post the audio data to the main thread
                        mainHandler.post {
                            eventSink?.success(data)
                        }
                    }
                }
            }.start()

            Log.d(TAG, "Recording started successfully")
            result.success(null)
        } catch (e: Exception) {
            Log.e(TAG, "Error starting audio stream", e)
            result.error("AUDIO_ERROR", "Error starting audio stream: ${e.message}", null)
        }
    }

    private fun stopAudioStream(result: Result) {
        Log.d(TAG, "stopAudioStream called")
        if (!isRecording) {
            Log.d(TAG, "Not recording, returning")
            result.success(null)
            return
        }

        try {
            isRecording = false
            audioRecord?.stop()
            audioRecord?.release()
            audioRecord = null
            Log.d(TAG, "Recording stopped successfully")
            result.success(null)
        } catch (e: Exception) {
            Log.e(TAG, "Error stopping audio stream", e)
            result.error("AUDIO_ERROR", "Error stopping audio stream: ${e.message}", null)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        Log.d(TAG, "onDetachedFromEngine called")
        channel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
    }
} 