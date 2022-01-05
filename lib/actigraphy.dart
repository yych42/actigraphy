
import 'dart:async';

import 'package:flutter/services.dart';

class Actigraphy {
  static const MethodChannel _channel = MethodChannel('actigraphy');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
