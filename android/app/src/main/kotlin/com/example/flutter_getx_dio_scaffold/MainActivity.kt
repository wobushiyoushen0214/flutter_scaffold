package com.example.flutter_getx_dio_scaffold

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.flutter_getx_dio_scaffold/iflytek"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        val plugin = IflytekPlugin(this, channel)
        
        channel.setMethodCallHandler { call, result ->
            plugin.onMethodCall(call, result)
        }
    }
}
