import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_signal_strength_method_channel.dart';

abstract class FlutterSignalStrengthPlatform extends PlatformInterface {
  /// Constructs a FlutterSignalStrengthPlatform.
  FlutterSignalStrengthPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterSignalStrengthPlatform _instance = MethodChannelFlutterSignalStrength();

  /// The default instance of [FlutterSignalStrengthPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterSignalStrength].
  static FlutterSignalStrengthPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterSignalStrengthPlatform] when
  /// they register themselves.
  static set instance(FlutterSignalStrengthPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
