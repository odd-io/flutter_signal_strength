import 'package:flutter/services.dart';

/// A Flutter plugin to get cellular and WiFi signal strength information.
///
/// IMPORTANT: This plugin requires the following Android permissions:
/// - READ_PHONE_STATE: For cellular signal information
/// - ACCESS_WIFI_STATE: For WiFi signal information
/// - ACCESS_FINE_LOCATION: Required on newer Android versions for WiFi information
///
/// It is the responsibility of the app using this plugin to request these permissions
/// from the user before calling the methods. The plugin will throw a PlatformException
/// if the required permissions are not granted.
class FlutterSignalStrength {
  static const MethodChannel _channel =
      MethodChannel('flutter_signal_strength');

  /// Get cellular signal strength level (0-4)
  /// 0 = No signal
  /// 1 = Poor
  /// 2 = Moderate
  /// 3 = Good
  /// 4 = Great
  ///
  /// Required Android permission: READ_PHONE_STATE
  /// Throws PlatformException if permission is not granted or service is unavailable
  Future<int> getCellularSignalStrength() async {
    final int level = await _channel.invokeMethod('getCellularSignalStrength');
    return level;
  }

  /// Get cellular signal strength in dBm
  /// The value typically ranges from -50 dBm (excellent signal) to -120 dBm (very poor signal)
  ///
  /// Required Android permission: READ_PHONE_STATE
  /// Throws PlatformException if permission is not granted or service is unavailable
  Future<int> getCellularSignalStrengthDbm() async {
    final int dbm = await _channel.invokeMethod('getCellularSignalStrengthDbm');
    return dbm;
  }

  /// Get WiFi signal strength level (0-4)
  /// 0 = No signal
  /// 1 = Poor
  /// 2 = Moderate
  /// 3 = Good
  /// 4 = Great
  ///
  /// Required Android permissions: ACCESS_WIFI_STATE, ACCESS_FINE_LOCATION
  /// Throws PlatformException if WiFi is disabled or service is unavailable
  Future<int> getWifiSignalStrength() async {
    final int level = await _channel.invokeMethod('getWifiSignalStrength');
    return level;
  }

  /// Get WiFi signal strength in dBm (RSSI)
  /// The value typically ranges from -30 dBm (excellent signal) to -90 dBm (very poor signal)
  ///
  /// Required Android permissions: ACCESS_WIFI_STATE, ACCESS_FINE_LOCATION
  /// Throws PlatformException if WiFi is disabled or service is unavailable
  Future<int> getWifiSignalStrengthDbm() async {
    final int rssi = await _channel.invokeMethod('getWifiSignalStrengthDbm');
    return rssi;
  }
}
