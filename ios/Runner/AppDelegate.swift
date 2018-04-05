import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

    private var eventSink: FlutterEventSink?
    private let scoreLabel = UILabel()
    private let stopButton = UIButton(type: .custom)
    private var basicSenderChannel: FlutterBasicMessageChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController;

    let threesChannel = FlutterMethodChannel.init(name: "diov.github.io/threes_channel", binaryMessenger: controller)
    threesChannel.setMethodCallHandler({
        (call: FlutterMethodCall, result: FlutterResult) -> Void in
        if "displayGameScore" == call.method {
            if let score = call.arguments as? Int {
                self.displayGameScore(score)
            }
        } else {
            result(FlutterMethodNotImplemented)
        }
    });

    basicSenderChannel = FlutterBasicMessageChannel(name: "diov.github.io/threes_channel", binaryMessenger: controller)

    configUI()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    // MARK: - Actions

    private func displayGameScore(_ score: Int) {
        scoreLabel.text = "Score: \(score)"
    }

    @objc
    private func stopThreesGame() {
        basicSenderChannel?.sendMessage("stopThreesGame")
        displayGameScore(0)
    }

    // MARK: - Config FlutterViewController

    private func configUI() {

        let screenWidth = UIScreen.main.bounds.width

        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController;

        scoreLabel.frame = CGRect(x: 40, y: 100, width: 100, height: 40)
        scoreLabel.text = "Score: 0"
        scoreLabel.backgroundColor = UIColor(red: 66 / 255.0, green: 185 / 255.0, blue: 254 / 255.0, alpha: 1.0)
        scoreLabel.layer.cornerRadius = 20
        scoreLabel.clipsToBounds = true
        scoreLabel.textAlignment = .center
        scoreLabel.textColor = UIColor.white
        controller.view.addSubview(scoreLabel)

        stopButton.backgroundColor = UIColor(red: 251 / 255.0, green: 57 / 255.0, blue: 98 / 255.0, alpha: 1.0)
        stopButton.layer.cornerRadius = 20
        stopButton.clipsToBounds = true
        stopButton.setTitle("Stop", for: .normal)
        stopButton.frame = CGRect(x: screenWidth - 140, y: 100, width: 100, height: 40)
        stopButton.addTarget(self, action: #selector(stopThreesGame), for: .touchUpInside)
        controller.view.addSubview(stopButton)
    }
}
