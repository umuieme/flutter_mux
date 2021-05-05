import Flutter
import UIKit

public class SwiftFlutterMuxPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_mux", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterMuxPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
//    var mediaMux = MediaMux()
//               if (call.argument<String>("audioPath") == null) {
//                   result.error("invalid_parameter", "Please specify audioPath", null);
//                   return;
//               }
//               if (call.argument<String>("videoPath") == null) {
//                   result.error("invalid_parameter", "Please specify videoPath", null);
//                   return;
//               }
//               if (call.argument<String>("outputPath") == null) {
//                   result.error("invalid_parameter", "Please specify outputPath", null);
//                   return;
//               }
    if let args = call.arguments as? Dictionary<String, Any> {
         // please check the "as" above  - wasn't able to test
         // handle the method
        if(args["audioPath"] == nil){
            result(FlutterError(code: "invalid_parameter", message: "Please specify audio path", details: nil));
            return;
        }
        if(args["videoPath"] == nil){
            result(FlutterError(code: "invalid_parameter", message: "Please specify video path", details: nil));
            return;
        }
        if(args["outputPath"] == nil){
                   result(FlutterError(code: "invalid_parameter", message: "Please specify output path", details: nil));
                   return;
               }
        FlutterMux().mixAudioVideo(outputFile: args["outputPath"] as! String , videoFile: args["videoPath"]as! String, audioFile: args["audioPath"] as! String, result: result)

     } else {
       result(FlutterError.init(code: "errorSetDebug", message: "data or format error", details: nil))
     }
    
  }
}
