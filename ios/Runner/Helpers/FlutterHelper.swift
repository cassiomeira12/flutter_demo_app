import Foundation
import Flutter

public class FlutterHelper {
    public static var shared = FlutterHelper()
    
    var flutterEngine = FlutterEngine(name: "main")
    var methodChannel : FlutterMethodChannel?
    
    func loadMethodChannel(controller: FlutterViewController) {
        self.methodChannel = FlutterMethodChannel(name: "flutter", binaryMessenger: controller.binaryMessenger)
        self.methodChannel?.setMethodCallHandler {(call: FlutterMethodCall, result: FlutterResult) -> Void in
            print("\(String(describing: call.method)) data RECEIVED from flutter: \(String(describing: call.arguments))")
            switch(call.method) {
                case "changeLocale":
                    let language : String = call.arguments as! String
                    self.changeLocale(flutterResult: result, newLanguage: language)
                    break
                default:
                    result(FlutterMethodNotImplemented)
                    return
            }
        }
    }

    func setData(data: Any) {
        self.methodChannel?.invokeMethod("setData", arguments: data)
    }

    private func changeLocale(flutterResult result: FlutterResult, newLanguage language: String) {
        do {
            UserDefaults.standard.set([language], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            result(language)
            self.killApp()
        } catch {
            result(FlutterError(code: "ERROR", message: error.localizedDescription, details: nil))
        }
    }

    private func killApp() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { exit(0) }
    }
}