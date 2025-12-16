import Flutter
import UIKit

// 真实接入需要 import iflyMSC
// 如果报错 "No such module 'iflyMSC'"，请确保已下载 SDK 并添加到项目中
import iflyMSC

// SparkChain (假设有 SparkChain iOS SDK)
// import SparkChain

class IflytekPlugin: NSObject, IFlySpeechRecognizerDelegate, IFlySpeechSynthesizerDelegate {
    var channel: FlutterMethodChannel
    var iFlySpeechRecognizer: IFlySpeechRecognizer?
    var iFlySpeechSynthesizer: IFlySpeechSynthesizer?
    // var sparkLLM: LLM?
    
    init(channel: FlutterMethodChannel) {
        self.channel = channel
        super.init()
    }
    
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "init" {
            let args = call.arguments as? [String: Any]
            let appId = args?["appId"] as? String
            let apiKey = args?["apiKey"] as? String
            let apiSecret = args?["apiSecret"] as? String
            initSDK(appId: appId, apiKey: apiKey, apiSecret: apiSecret)
            result(nil)
        } else if call.method == "startListening" {
            startListening()
            result(nil)
        } else if call.method == "stopListening" {
            stopListening()
            result(nil)
        } else if call.method == "speak" {
            let args = call.arguments as? [String: Any]
            let text = args?["text"] as? String
            speak(text: text)
            result(nil)
        } else if call.method == "stopSpeaking" {
            stopSpeaking()
            result(nil)
        } else if call.method == "startChat" {
            // LLM 已移至 Dart 层处理，此处仅作为占位或保留空实现
            result(nil)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
    
    func initSDK(appId: String?, apiKey: String?, apiSecret: String?) {
        guard let appId = appId else { return }
        print("Initializing iOS SDK with AppID: \(appId)")
        
        // 设置 sdk 的 log 等级，log 保存在 Library/cache/iflyMSC.log 中
        IFlySetting.setLogFile(LVL_ALL)
        
        // 打开输出在 console 的 log 开关
        IFlySetting.showLogcat(true)
        
        // 创建语音配置,appid 必须要传入，仅执行一次则可
        let initString = "appid=\(appId)"
        IFlySpeechUtility.createUtility(initString)
        
        // 识别
        iFlySpeechRecognizer = IFlySpeechRecognizer.sharedInstance() as? IFlySpeechRecognizer
        iFlySpeechRecognizer?.delegate = self
        iFlySpeechRecognizer?.setParameter("iat", forKey: IFlySpeechConstant.IFLY_DOMAIN())
        iFlySpeechRecognizer?.setParameter("iat.pcm", forKey: IFlySpeechConstant.ASR_AUDIO_PATH())
        // 设置结果格式为 json
        iFlySpeechRecognizer?.setParameter("json", forKey: IFlySpeechConstant.RESULT_TYPE())
        
        // 合成
        iFlySpeechSynthesizer = IFlySpeechSynthesizer.sharedInstance() as? IFlySpeechSynthesizer
        iFlySpeechSynthesizer?.delegate = self
    }
    
    func startChat(text: String?) {
        // LLM 已移至 Dart 层处理
    }
    
    func startListening() {
        print("startListening")
        
        if iFlySpeechRecognizer == nil {
             // 尝试重新获取或初始化
             iFlySpeechRecognizer = IFlySpeechRecognizer.sharedInstance() as? IFlySpeechRecognizer
             iFlySpeechRecognizer?.delegate = self
        }

        iFlySpeechRecognizer?.setParameter(IFlySpeechConstant.TYPE_CLOUD(), forKey: IFlySpeechConstant.ENGINE_TYPE())
        iFlySpeechRecognizer?.setParameter("zh_cn", forKey: IFlySpeechConstant.LANGUAGE())
        iFlySpeechRecognizer?.setParameter("mandarin", forKey: IFlySpeechConstant.ACCENT())
        iFlySpeechRecognizer?.setParameter("0", forKey: IFlySpeechConstant.ASR_PTT())
        
        let ret = iFlySpeechRecognizer?.startListening()
        if ret == false {
            channel.invokeMethod("onError", arguments: "启动听写失败")
        }
    }
    
    func stopListening() {
        iFlySpeechRecognizer?.stopListening()
    }
    
    func speak(text: String?) {
        guard let text = text else { return }
        print("speak: \(text)")
        
        if iFlySpeechSynthesizer == nil {
            iFlySpeechSynthesizer = IFlySpeechSynthesizer.sharedInstance() as? IFlySpeechSynthesizer
            iFlySpeechSynthesizer?.delegate = self
        }

        iFlySpeechSynthesizer?.setParameter(IFlySpeechConstant.TYPE_CLOUD(), forKey: IFlySpeechConstant.ENGINE_TYPE())
        iFlySpeechSynthesizer?.setParameter("xiaoyan", forKey: IFlySpeechConstant.VOICE_NAME())
        iFlySpeechSynthesizer?.startSpeaking(text)
    }
    
    func stopSpeaking() {
        iFlySpeechSynthesizer?.stopSpeaking()
    }
    
    // MARK: - IFlySpeechRecognizerDelegate
    
    func onError(_ errorCode: IFlySpeechError!) {
        channel.invokeMethod("onError", arguments: errorCode.errorDesc)
    }
    
    func onResults(_ results: [Any]!, isLast: Bool) {
        var result = ""
        if let results = results {
            if let dic = results[0] as? [String: Any] {
                for (key, _) in dic {
                    result += key
                }
            }
        }
        
        // 解析 JSON
        var parsedText = ""
        if let data = result.data(using: .utf8) {
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let ws = json["ws"] as? [[String: Any]] {
                    for w in ws {
                        if let cw = w["cw"] as? [[String: Any]] {
                            for c in cw {
                                if let wStr = c["w"] as? String {
                                    parsedText += wStr
                                }
                            }
                        }
                    }
                }
            } catch {
                print("JSON parsing error: \(error)")
            }
        }
        
        // 如果解析为空（可能不是 json 格式），则直接返回原串（虽然通常不会）
        if parsedText.isEmpty && !result.isEmpty {
            // 某些情况下可能返回非 JSON，视 SDK 版本而定，但设置了 json result type 应该是 json
            // parsedText = result 
        }

        channel.invokeMethod("onResult", arguments: parsedText)
    }
    
    func onEndOfSpeech() {
        channel.invokeMethod("onEndOfSpeech", arguments: nil)
    }
    
    func onVolumeChanged(_ volume: Int32) {
    }
    
    func onBeginOfSpeech() {
    }
    
    func onCancel() {
    }
    
    // MARK: - IFlySpeechSynthesizerDelegate
    
    func onCompleted(_ error: IFlySpeechError!) {
        if error == nil {
            channel.invokeMethod("onSpeakCompleted", arguments: nil)
        } else {
            channel.invokeMethod("onError", arguments: error.errorDesc)
        }
    }
    
    func onSpeakBegin() {
        channel.invokeMethod("onSpeakBegin", arguments: nil)
    }
    
    func onBufferProgress(_ progress: Int32, message msg: String!) {}
    
    func onSpeakProgress(_ progress: Int32, beginPos: Int32, endPos: Int32) {}
    
    func onSpeakPaused() {}
    
    func onSpeakResumed() {}
    
    func onSpeakCancel() {}
}
