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
                result("displayGameScore")
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
    private func resetThreesGame() {
        basicSenderChannel?.sendMessage("resetThreesGame")
        displayGameScore(0)
    }

    // MARK: - Config FlutterViewController

    private func configUI() {

        let screenWidth = UIScreen.main.bounds.width

        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController;

        scoreLabel.frame = CGRect(x: 40, y: 80, width: 100, height: 50)
        scoreLabel.text = "Score: 0"
        scoreLabel.backgroundColor = UIColor(red: 177 / 255.0, green: 212 / 255.0, blue: 212 / 255.0, alpha: 1.0)
        scoreLabel.layer.cornerRadius = 10
        scoreLabel.clipsToBounds = true
        scoreLabel.textAlignment = .center
        scoreLabel.textColor = UIColor.white
        scoreLabel.font = UIFont.systemFont(ofSize: 20)
        controller.view.addSubview(scoreLabel)

        stopButton.backgroundColor = UIColor(red: 251 / 255.0, green: 57 / 255.0, blue: 98 / 255.0, alpha: 1.0)
        stopButton.layer.cornerRadius = 10
        stopButton.clipsToBounds = true
        stopButton.setTitle("Reset", for: .normal)
        stopButton.frame = CGRect(x: screenWidth - 140, y: 80, width: 100, height: 50)
        stopButton.addTarget(self, action: #selector(resetThreesGame), for: .touchUpInside)
        stopButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        controller.view.addSubview(stopButton)
    }
}
