import Foundation
import Flutter
import IDwallToolkit

public class FlutterHelper {
    public static var shared = FlutterHelper()
    
    var flutterEngine = FlutterEngine(name: "main")
    var methodChannel : FlutterMethodChannel?

    func initEngine() {
        flutterEngine.run()
    }

    func loadMethodChannel(controller: FlutterViewController) {
        self.methodChannel = FlutterMethodChannel(name: "flutter", binaryMessenger: controller.binaryMessenger)
        self.methodChannel?.setMethodCallHandler {(call: FlutterMethodCall, result: FlutterResult) -> Void in
            switch(call.method) {
                case "":
                    break
                default:
                    print("MethodChannel not implemented in FlutterHelper.")
                    break
            }
        }
    }

    func setData(data: Any) {
        self.methodChannel?.invokeMethod("setData", arguments: data)
    }
}