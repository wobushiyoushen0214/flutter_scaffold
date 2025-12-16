package com.example.flutter_getx_dio_scaffold

import android.app.Activity
import android.content.Context
import android.os.Bundle
import android.util.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject
import org.json.JSONTokener
import java.lang.StringBuilder

import com.iflytek.sparkchain.core.SparkChain
import com.iflytek.sparkchain.core.SparkChainConfig
import com.iflytek.sparkchain.core.asr.ASR
import com.iflytek.sparkchain.core.asr.AsrCallbacks

class IflytekPlugin(private val context: Context, private val channel: MethodChannel) {

    private val TAG = "IflytekPlugin"
    private var mAsr: ASR? = null
    private var mAsrResultBuilder: StringBuilder? = null
    private var mAsrFinalSent: Boolean = false

    fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "init" -> {
                val appId = call.argument<String>("appId")
                val apiKey = call.argument<String>("apiKey")
                val apiSecret = call.argument<String>("apiSecret")
                initSDK(appId, apiKey, apiSecret)
                result.success(null)
            }
            "startListening" -> {
                startListening()
                result.success(null)
            }
            "stopListening" -> {
                stopListening()
                result.success(null)
            }
            "speak" -> {
                val text = call.argument<String>("text")
                speak(text)
                result.success(null)
            }
            "stopSpeaking" -> {
                stopSpeaking()
                result.success(null)
            }
            "startChat" -> {
                // LLM 已移至 Dart 层处理
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    private fun initSDK(appId: String?, apiKey: String?, apiSecret: String?) {
        Log.d(TAG, "Initializing SparkChain SDK with AppID: $appId")
        if (appId == null) return

        try {
            val builder = SparkChainConfig.builder()
            builder.appID(appId)
            if (apiKey != null) builder.apiKey(apiKey)
            if (apiSecret != null) builder.apiSecret(apiSecret)
            
            val config = builder
            val ret = SparkChain.getInst().init(context, config)
            if (ret != 0) {
                Log.e(TAG, "SparkChain Init Error: $ret")
                (context as Activity).runOnUiThread {
                     channel.invokeMethod("onError", "初始化失败,错误码：$ret")
                }
                return
            }

            mAsr = ASR("zh_cn", "iat", "mandarin")
        } catch (e: Exception) {
            Log.e(TAG, "Init Exception: ${e.message}")
            e.printStackTrace()
        }
    }

    private fun startListening() {
        Log.d(TAG, "startListening")

        if (mAsr == null) {
            mAsr = ASR("zh_cn", "iat", "mandarin")
        }

        mAsrResultBuilder = StringBuilder()
        mAsrFinalSent = false

        mAsr?.registerCallbacks(object : AsrCallbacks {
            override fun onResult(result: ASR.ASRResult, obj: Any?) {
                val text = result.getBestMatchText()
                Log.d(TAG, "ASR onResult: $text")
                if (!text.isNullOrEmpty()) {
                    if (mAsrResultBuilder == null) {
                        mAsrResultBuilder = StringBuilder()
                    }
                    mAsrResultBuilder?.append(text)
                }
            }

            override fun onError(error: ASR.ASRError, obj: Any?) {
                Log.e(TAG, "ASR onError: $error")
                (context as Activity).runOnUiThread {
                    channel.invokeMethod("onError", "听写失败: $error")
                }
            }

            override fun onBeginOfSpeech() {
                Log.d(TAG, "onBeginOfSpeech")
            }

            override fun onEndOfSpeech() {
                Log.d(TAG, "onEndOfSpeech")
                if (!mAsrFinalSent) {
                    (context as Activity).runOnUiThread {
                        val finalText = mAsrResultBuilder?.toString() ?: ""
                        channel.invokeMethod("onResult", finalText)
                        channel.invokeMethod("onEndOfSpeech", null)
                        mAsrFinalSent = true
                    }
                }
            }

            override fun onRecordVolume(volume: Double, i: Int) {
                // volume change
            }
        })

        val ret = mAsr?.start(null) ?: -1
        Log.d(TAG, "ASR start ret: $ret")
        if (ret != 0) {
            (context as Activity).runOnUiThread {
                channel.invokeMethod("onError", "启动听写失败: $ret")
            }
        }
    }

    private fun stopListening() {
        Log.d(TAG, "stopListening")
        mAsr?.stop(true)
        if (!mAsrFinalSent) {
            (context as Activity).runOnUiThread {
                val finalText = mAsrResultBuilder?.toString() ?: ""
                channel.invokeMethod("onResult", finalText)
                channel.invokeMethod("onEndOfSpeech", null)
                mAsrFinalSent = true
            }
        }
    }

    private fun speak(text: String?) {
        Log.d(TAG, "speak: $text")
    }

    private fun stopSpeaking() {
    }
}
