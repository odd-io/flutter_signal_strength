package io.odd.flutter_signal_strength

import android.content.Context
import android.telephony.TelephonyManager
import android.telephony.CellInfoGsm
import android.telephony.CellInfoLte
import android.telephony.CellInfoWcdma
import android.telephony.CellInfo
import android.net.wifi.WifiManager
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterSignalStrengthPlugin */
class FlutterSignalStrengthPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context
  private lateinit var telephonyManager: TelephonyManager
  private lateinit var wifiManager: WifiManager

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_signal_strength")
    context = flutterPluginBinding.applicationContext
    telephonyManager = context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
    wifiManager = context.getSystemService(Context.WIFI_SERVICE) as WifiManager
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "getCellularSignalStrength" -> {
        try {
          val signalStrength = telephonyManager.signalStrength
          if (signalStrength != null) {
            // Get cellular signal level (0-4)
            val level = signalStrength.level
            result.success(level)
          } else {
            result.error("UNAVAILABLE", "Signal strength information not available", null)
          }
        } catch (e: SecurityException) {
          result.error("PERMISSION_DENIED", "Required permission READ_PHONE_STATE not granted", null)
        }
      }
      "getCellularSignalStrengthDbm" -> {
        try {
          val cellInfoList = telephonyManager.allCellInfo
          if (cellInfoList != null && cellInfoList.isNotEmpty()) {
            val cellInfo = cellInfoList[0]
            val dbm = when (cellInfo) {
              is CellInfoLte -> cellInfo.cellSignalStrength.dbm
              is CellInfoGsm -> cellInfo.cellSignalStrength.dbm
              is CellInfoWcdma -> cellInfo.cellSignalStrength.dbm
              else -> null
            }
            if (dbm != null) {
              result.success(dbm)
            } else {
              result.error("UNAVAILABLE", "dBm value not available for current network type", null)
            }
          } else {
            result.error("UNAVAILABLE", "Cell info not available", null)
          }
        } catch (e: SecurityException) {
          result.error("PERMISSION_DENIED", "Required permission READ_PHONE_STATE not granted", null)
        }
      }
      "getWifiSignalStrength" -> {
        try {
          val wifiInfo = wifiManager.connectionInfo
          // Get RSSI (Received Signal Strength Indicator)
          val rssi = wifiInfo.rssi
          // Convert RSSI to level (0-4)
          val level = WifiManager.calculateSignalLevel(rssi, 5)
          result.success(level)
        } catch (e: Exception) {
          result.error("UNAVAILABLE", "WiFi signal strength information not available", null)
        }
      }
      "getWifiSignalStrengthDbm" -> {
        try {
          val wifiInfo = wifiManager.connectionInfo
          val rssi = wifiInfo.rssi
          result.success(rssi) // RSSI is already in dBm for WiFi
        } catch (e: Exception) {
          result.error("UNAVAILABLE", "WiFi signal strength information not available", null)
        }
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
