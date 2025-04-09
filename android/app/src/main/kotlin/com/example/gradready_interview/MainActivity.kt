package com.example.gradready_interview

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val methodChannelName = "com.example.grad_ready/audio_stream"
    private val eventChannelName = "com.example.grad_ready/audio_stream_events"
    private var audioStreamHandler: AudioStreamHandler? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Set up Method Channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, methodChannelName).setMethodCallHandler { call, result ->
            when (call.method) {
                "startAudioStream" -> {
                    try {
                        audioStreamHandler = AudioStreamHandler()
                        EventChannel(flutterEngine.dartExecutor.binaryMessenger, eventChannelName).setStreamHandler(
                            audioStreamHandler
                        )
                        result.success(null)
                    } catch (e: Exception) {
                        result.error("AUDIO_STREAM_ERROR", e.message, null)
                    }
                }
                "stopAudioStream" -> {
                    try {
                        audioStreamHandler?.onCancel(null)
                        audioStreamHandler = null
                        result.success(null)
                    } catch (e: Exception) {
                        result.error("AUDIO_STREAM_ERROR", e.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onDestroy() {
        audioStreamHandler?.onCancel(null)
        audioStreamHandler = null
        super.onDestroy()
    }
}
