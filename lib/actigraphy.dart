
import 'dart:async';

import 'package:flutter/services.dart';

class Actigraphy {
  static const MethodChannel _channel = MethodChannel('actigraphy');

  /// platformVersion
  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// getActigraphyData(int fromDaysAgo)
  /// fromDaysAgo: number of days ago to start the query
  /// returns: a csv string of the data
  /// 
  /// TODO: return a list of ActigraphyData objects instead
  static Future<String?> getActigraphyData(int fromDaysAgo) async {
    final String? data = await _channel.invokeMethod('getActigraphyData', <String, dynamic>{
      'fromDaysAgo': fromDaysAgo,
    });
    return data;
  }

  /// isAvailable
  /// returns: true if the device can provide data
  static Future<bool> get isAvailable async {
    final bool available = await _channel.invokeMethod('checkIfActigraphyIsAvailable');
    return available;
  }

  /// isAuthorized
  /// returns: true if the user has authorized the app to access data
  static Future<bool> get isAuthorized async {
    final bool authorized = await _channel.invokeMethod('checkAuthorizationStatus');
    return authorized;
  }
}
