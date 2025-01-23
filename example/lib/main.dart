import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_signal_strength/flutter_signal_strength.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _flutterSignalStrength = FlutterSignalStrength();
  int _cellularSignal = -1;
  int _wifiSignal = -1;
  int _cellularDbm = 0;
  int _wifiDbm = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    // Update signal strength every 2 seconds
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _updateSignalStrengths();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    await Permission.phone.request();
    await Permission.location.request();
  }

  Future<void> _updateSignalStrengths() async {
    try {
      final cellularSignal =
          await _flutterSignalStrength.getCellularSignalStrength();
      final wifiSignal = await _flutterSignalStrength.getWifiSignalStrength();
      final cellularDbm =
          await _flutterSignalStrength.getCellularSignalStrengthDbm();
      final wifiDbm = await _flutterSignalStrength.getWifiSignalStrengthDbm();

      setState(() {
        _cellularSignal = cellularSignal;
        _wifiSignal = wifiSignal;
        _cellularDbm = cellularDbm;
        _wifiDbm = wifiDbm;
      });
    } on PlatformException catch (e) {
      debugPrint('Error getting signal strength: ${e.message}');
    }
  }

  String _getSignalDescription(int level) {
    switch (level) {
      case 0:
        return 'No Signal';
      case 1:
        return 'Poor';
      case 2:
        return 'Moderate';
      case 3:
        return 'Good';
      case 4:
        return 'Excellent';
      default:
        return 'Unknown';
    }
  }

  Widget _buildSignalIndicator(String type, int level, int dbm) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              type,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  width: 20,
                  height: 20 + (index * 5),
                  decoration: BoxDecoration(
                    color: index <= level - 1 ? Colors.green : Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),
            Text(
              _getSignalDescription(level),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              '$dbm dBm',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Signal Strength Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSignalIndicator(
                  'Cellular Signal', _cellularSignal, _cellularDbm),
              _buildSignalIndicator('WiFi Signal', _wifiSignal, _wifiDbm),
            ],
          ),
        ),
      ),
    );
  }
}
