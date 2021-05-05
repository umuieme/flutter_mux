package com.umuieme.flutter_mux

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterMuxPlugin */
class FlutterMuxPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_mux")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "mixAudioVideo") {
            var mediaMux = MediaMux()
            if (call.argument<String>("audioPath") == null) {
                result.error("invalid_parameter", "Please specify audioPath", null);
                return;
            }
            if (call.argument<String>("videoPath") == null) {
                result.error("invalid_parameter", "Please specify videoPath", null);
                return;
            }
            if (call.argument<String>("outputPath") == null) {
                result.error("invalid_parameter", "Please specify outputPath", null);
                return;
            }
            var status = mediaMux.muxAudioAndVideo(call.argument("outputPath")!!, call.argument("audioPath")!!, call.argument("videoPath")!!)
            result.success(status)
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
