import UIKit
import Flutter
import WidgetKit

private let groupId = "group.com.vnappmob.qrquick"
private let widgetKind = "com.vnappmob.qrquick.kind1"
private let methodChannel = "com.vnappmob.qrquick/UserDefaultsChannel"

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let UserDefaultsChannel = FlutterMethodChannel(
            name: methodChannel,
            binaryMessenger: controller.binaryMessenger
        )
        
        UserDefaultsChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if call.method == "updateAppTheme" {
                return
            } else if call.method == "updateWidget" {
                if let widgetName = UserDefaults.standard.string(forKey: "flutter.widgetName") {
                    if let userDefaults = UserDefaults(suiteName: groupId) {
                        userDefaults.set(widgetName, forKey: "widgetName")
                        result(true)
                    }
                }
                if let widgetContent = UserDefaults.standard.string(forKey: "flutter.widgetContent") {
                    print(widgetContent)
                    if let userDefaults = UserDefaults(suiteName: groupId) {
                        userDefaults.set(widgetContent, forKey: "widgetContent")
                        result(true)
                    }
                }
                print("going to update widget")
                WidgetCenter.shared.reloadTimelines(ofKind: widgetKind)
                return
            } else if call.method == "imageScan" {
                guard let args = call.arguments else {
                    result("")
                    return
                };
                let filePath: String = (args as! [String: Any])["file_path"] as! String;
                let qrContent = self.imageScan(path: filePath);
                result(qrContent);
            } else{
                result(FlutterMethodNotImplemented)
                return
            }
        })
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    public func imageScan(path: String) -> String? {
        
        let image: UIImage? = UIImage.init(contentsOfFile: path);
        if (image == nil) {
            return nil;
        }
        
        let ciContext: CIContext = CIContext.init();
        let ciDetector: CIDetector? = CIDetector.init(ofType: CIDetectorTypeQRCode, context: ciContext, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh]);
        let ciImage: CIImage? = CIImage.init(image: image!);
        let ciFeature: [CIFeature]? = ciDetector?.features(in: ciImage!);
        
        if (ciFeature?.count == 0) {
            return nil;
        }
        
        for feature in ciFeature! {
            if (feature is CIQRCodeFeature) {
                return (feature as! CIQRCodeFeature).messageString;
            }
        }
        
        return nil;
        
    }
}
