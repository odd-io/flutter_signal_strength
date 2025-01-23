# Flutter Signal Strength

A Flutter plugin to get cellular and WiFi signal strength information for Android devices. The plugin provides both normalized signal levels (0-4) and raw dBm values.

## Features

- Get cellular signal strength (level 0-4 and dBm)
- Get WiFi signal strength (level 0-4 and dBm)
- Detailed error handling for permission and availability issues

## Getting Started

### Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_signal_strength: ^0.0.1
```

### Required Permissions

Add these permissions to your Android app's `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.READ_PHONE_STATE" />
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
```

### Usage

First, ensure you have the required permissions. You can use any permission handling package (like `permission_handler`) to request permissions:

```dart
// Request permissions before using the plugin
// Example using permission_handler package:
await Permission.phone.request();
await Permission.location.request();
```

Then use the plugin:

```dart
final signalStrength = FlutterSignalStrength();

// Get cellular signal level (0-4)
try {
  final level = await signalStrength.getCellularSignalStrength();
  print('Cellular signal level: $level');
} on PlatformException catch (e) {
  print('Failed to get cellular signal: ${e.message}');
}

// Get cellular signal in dBm
try {
  final dbm = await signalStrength.getCellularSignalStrengthDbm();
  print('Cellular signal strength: $dbm dBm');
} on PlatformException catch (e) {
  print('Failed to get cellular signal: ${e.message}');
}

// Get WiFi signal level (0-4)
try {
  final level = await signalStrength.getWifiSignalStrength();
  print('WiFi signal level: $level');
} on PlatformException catch (e) {
  print('Failed to get WiFi signal: ${e.message}');
}

// Get WiFi signal in dBm
try {
  final dbm = await signalStrength.getWifiSignalStrengthDbm();
  print('WiFi signal strength: $dbm dBm');
} on PlatformException catch (e) {
  print('Failed to get WiFi signal: ${e.message}');
}
```

## Error Handling

The plugin throws `PlatformException` in the following cases:

- Required permissions are not granted
- Device services (cellular/WiFi) are not available
- Signal strength information cannot be retrieved

## Example

Check out the [example](example) directory for a complete sample app demonstrating all features.

## Platform Support

| Android | iOS | MacOS | Web | Linux | Windows |
|---------|-----|-------|-----|--------|----------|
| ✅      | ❌   | ❌     | ❌   | ❌      | ❌        |

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
Made with ❤️ by odd.io
