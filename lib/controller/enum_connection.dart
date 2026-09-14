part of '../core/service/zo_connectivity_watcher_service.dart';

enum ConnectivityWatcherStatus {
  /// connected to internet
  connected,

  /// disconnected from internet
  disconnected;

  String get name =>
      this == ConnectivityWatcherStatus.connected ? 'connected' : 'disconnected';

  bool get isConnected => this == ConnectivityWatcherStatus.connected;
  bool get isDisconnected => this == ConnectivityWatcherStatus.disconnected;
}

enum NoConnectivityStyle { SNACKBAR, ALERT, CUSTOM, CUSTOMALERT, NONE }

/// Represents the network connection mode through which device reaches the network.
enum ConnectionMode {
  wifi,
  mobile,
  ethernet,
  bluetooth,
  vpn,
  satellite,
  other,
  none;

  String get name => toString().split('.').last;

  bool get isWifi => this == ConnectionMode.wifi;
  bool get isMobile => this == ConnectionMode.mobile;
  bool get isEthernet => this == ConnectionMode.ethernet;
  bool get isBluetooth => this == ConnectionMode.bluetooth;
  bool get isVpn => this == ConnectionMode.vpn;
  bool get isSatellite => this == ConnectionMode.satellite;
  bool get isOther => this == ConnectionMode.other;
  bool get isConnected => this != ConnectionMode.none;

  String get label {
    switch (this) {
      case ConnectionMode.wifi:
        return 'Wi-Fi';
      case ConnectionMode.mobile:
        return 'Mobile Data';
      case ConnectionMode.ethernet:
        return 'Ethernet';
      case ConnectionMode.bluetooth:
        return 'Bluetooth';
      case ConnectionMode.vpn:
        return 'VPN';
      case ConnectionMode.satellite:
        return 'Satellite';
      case ConnectionMode.other:
        return 'Other';
      case ConnectionMode.none:
        return 'None';
    }
  }
}

/// Unified connectivity event containing both internet status and active connection modes.
class ConnectivityWatcherEvent {
  final ConnectivityWatcherStatus status;
  final ConnectionMode mode;
  final List<ConnectionMode> activeModes;
  final DateTime timestamp;

  const ConnectivityWatcherEvent({
    required this.status,
    required this.mode,
    required this.activeModes,
    required this.timestamp,
  });

  bool get hasInternet => status == ConnectivityWatcherStatus.connected;

  @override
  String toString() =>
      'ConnectivityWatcherEvent(status: $status, mode: $mode, activeModes: $activeModes, timestamp: $timestamp)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConnectivityWatcherEvent &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          mode == other.mode &&
          timestamp == other.timestamp;

  @override
  int get hashCode => status.hashCode ^ mode.hashCode ^ timestamp.hashCode;
}
