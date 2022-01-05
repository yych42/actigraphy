// WARNING: Not tested on real device yet.

import Flutter
import UIKit

public class SwiftActigraphyPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "actigraphy", binaryMessenger: registrar.messenger())
    let instance = SwiftActigraphyPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    /// Handle checkIfActigraphyIsAvailable
    if (call.method.elementsEqual("checkIfActigraphyIsAvailable")) {
      checkIfActigraphyIsAvailable(result: result)
    }

    /// Handle checkAuthorizationStatus
    if (call.method.elementsEqual("checkAuthorizationStatus")) {
      checkAuthorizationStatus(result: result)
    }

    /// Handle getActigraphyData
    if (call.method.elementsEqual("getActigraphyData")) {
      getActiographyData(call:call, result: result)
    }
  }

  func getActiographyData(call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as! [String: Any]
    let fromDaysAgo = args["fromDaysAgo"] as! Int

    let now = Date()
    let startDate = now.addingTimeInterval(-TimeInterval(fromDaysAgo * 24 * 60 * 60))

    let activityData: String = "activityStartDate,activityType,confidence\n"
    
    let activityManager = CMMotionActivityManager()
    activityManager.queryActivityStarting(from:startDate, to: now, to: OperationQueue.init()) {
        (activities, error) in
        if error != nil {
            activityData = "Error: \(error!.localizedDescription)"
        } else {
            for activity in activities! {
                let startDate = activity.startDate
                let type = determineActivityType(activity: activity)
                let confidence = standardizeConfidence(activity: activity.confidence)
                activityData += "\(startDate),\(type),\(confidence)\n"
            }
        }
    }
    result(activityData)
  }

  func determineActivityType(activity: CMMotionActivity) -> String {
    // Activity types are not mutually exclusive, so we have to check for all possible cases.
    // Return 'stationary' only if the activity is exclusively stationary.
    if activity.unknown {
        return "unknown"
    } else if activity.walking {
        return "walking"
    } else if activity.running {
        return "running"
    } else if activity.automotive {
        return "automotive"
    } else if activity.cycling {
        return "cycling"
    } else if activity.stationary {
        return "stationary"
    } else {
        return "NULL"
    }
  }

  func standardizeConfidence(activity: CMMotionActivityConfidence) -> String {
    switch activity {
    case .high:
        return "3"
    case .medium:
        return "2"
    case .low:
        return "1"
    default:
        return "NULL"
    }
  }
  
  func checkIfActigraphyIsAvailable(result: @escaping FlutterResult) {
    let activityManager = CMMotionActivityManager()
    if activityManager.isActivityAvailable {
        result(true)
    } else {
        result(false)
    }
  }

  func checkAuthorizationStatus(result: @escaping FlutterResult) {
    let activityManager = CMMotionActivityManager()
    let statusRaw = activityManager.authorizationStatus()
    if statusRaw == .authorized {
        result(true)
    } else {
        result(false)
    }
  }
}