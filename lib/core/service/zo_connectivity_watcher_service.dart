import 'dart:async';

import 'package:connectivity_watcher/controller/zo_connectivity_controller.dart';
import 'package:connectivity_watcher/core/manager/zo_retry_manager.dart';

import 'package:connectivity_watcher/core/interceptors/network_logger_interceptor.dart';
import 'package:connectivity_watcher/core/manager/zo_network_log_manager.dart';
import 'package:connectivity_watcher/core/models/network_log_model.dart';

import 'package:connectivity_watcher/core/service/zo_ping_service.dart';
import 'package:connectivity_watcher/screens/network_logs_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

part '../../controller/enum_connection.dart';

class ZoConnectivityWatcher {
  ZoConnectivityWatcher._();

  static final ZoConnectivityWatcher _instance = ZoConnectivityWatcher._();

  factory ZoConnectivityWatcher() {
    return _instance;
  }

  GlobalKey<NavigatorState>? _navigationKey;

  BuildContext get currentContext => _navigationKey!.currentContext!;

  final StreamController<ConnectivityWatcherStatus> _connectivityController =
      StreamController<ConnectivityWatcherStatus>.broadcast();

  final StreamController<ConnectionMode> _modeController =
      StreamController<ConnectionMode>.broadcast();

  final StreamController<ConnectivityWatcherEvent> _eventController =
      StreamController<ConnectivityWatcherEvent>.broadcast();

  /// Stream of binary internet connectivity status (connected / disconnected)
  Stream<ConnectivityWatcherStatus> get stream =>
      _connectivityController.stream;

  /// Stream of active network connection mode changes (wifi, mobile, ethernet, vpn, none, etc.)
  Stream<ConnectionMode> get connectionModeStream => _modeController.stream;

  /// Unified stream emitting both connectivity status and active connection modes
  Stream<ConnectivityWatcherEvent> get eventStream => _eventController.stream;

  ConnectionMode _connectionMode = ConnectionMode.wifi;
  List<ConnectionMode> _activeConnectionModes = [ConnectionMode.wifi];

  /// Current primary network connection mode (e.g. wifi, mobile, ethernet, none)
  ConnectionMode get connectionMode => _connectionMode;

  /// Returns the current active [ConnectionMode] directly (synchronous).
  ConnectionMode getCurrentConnectionMode() => _connectionMode;

  /// Directly queries the network hardware interfaces and returns the active [ConnectionMode] (asynchronous).
  Future<ConnectionMode> getConnectionMode() async {
    final mode = await ZoConnectivityController().getConnectionMode();
    _connectionMode = mode;
    return mode;
  }

  /// List of all currently active connection modes (e.g. [wifi, vpn])
  List<ConnectionMode> get activeConnectionModes =>
      List.unmodifiable(_activeConnectionModes);

  bool isInternetAvailable = true;

  bool isNoInternetWidgetVisible = false;

  void setNavigatorKey(GlobalKey<NavigatorState> key) {
    _navigationKey = key;
  }

  Future<void> setUp({Duration? checkInterval, Duration? timeout}) async {
    await ZoConnectivityController().setUp(
      checkInterval: checkInterval,
      timeout: timeout,
    );
  }

  /// Initialize the ping service with custom settings or target hosts.
  void initPingService({
    List<String>? targetHosts,
    String? targetHost,
    Duration? interval,
    Duration? timeout,
    String? targetIp,
    int? targetPort,
  }) {
    ZoPingService.instance.init(
      targetHosts: targetHosts,
      targetHost: targetHost,
      interval: interval,
      timeout: timeout,
      targetIp: targetIp,
      targetPort: targetPort,
    );
  }

  void setupDioLogger(Dio dio) {
    dio.interceptors.add(NetworkLoggerInterceptor());
  }

  /// Get all the stored network logs.
  List<NetworkLogModel> getNetworkLogs() {
    return ZoNetworkLogManager.instance.logs;
  }

  /// Open the Network Logs Inspector screen.
  void showNetworkLogsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ZoNetworkLogsScreen()),
    );
  }

  /// Update both internet connectivity status and connection mode.
  void updateStatusAndMode({
    required ConnectivityWatcherStatus status,
    required ConnectionMode mode,
    List<ConnectionMode>? activeModes,
  }) {
    isInternetAvailable = (status == ConnectivityWatcherStatus.connected);
    _connectionMode = mode;
    if (activeModes != null) {
      _activeConnectionModes = activeModes;
    }

    _connectivityController.sink.add(status);
    _modeController.sink.add(mode);
    _eventController.sink.add(
      ConnectivityWatcherEvent(
        status: status,
        mode: mode,
        activeModes: _activeConnectionModes,
        timestamp: DateTime.now(),
      ),
    );
  }

  /// Legacy stream update for backward compatibility.
  updateStream(ConnectivityWatcherStatus status) {
    isInternetAvailable = (status == ConnectivityWatcherStatus.connected);
    _connectivityController.sink.add(status);
    _eventController.sink.add(
      ConnectivityWatcherEvent(
        status: status,
        mode: _connectionMode,
        activeModes: _activeConnectionModes,
        timestamp: DateTime.now(),
      ),
    );
  }

  /// Optimistically notifies that internet connection is confirmed working.
  void notifyOnline() {
    ZoConnectivityController().notifyOnline();
  }

  /// Use this method to forcefully hide the no internet widget.
  Future<bool> hideNoInternet() async {
    return ZoConnectivityController().hideNoInternetScreen();
  }

  /// Checks for internet connection status and calls the provided API function.
  /// Supports callbacks with either `(bool internetStatus)` or
  /// `(bool internetStatus, ConnectionMode mode)`.
  Future<void> makeApiCall({required Function apiCall}) async {
    final status = await ZoConnectivityController().getConnectivityStatus();
    final mode = connectionMode;
    if (apiCall is Function(bool, ConnectionMode)) {
      apiCall(status, mode);
    } else if (apiCall is Function(bool)) {
      apiCall(status);
    } else {
      try {
        apiCall(status, mode);
      } catch (_) {
        apiCall(status);
      }
    }
  }

  /// Retries an API call with a specified maximum number of retries and delay duration.
  makeApiCallWithRetry({
    required Future<void> Function() apiCall,
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 2),
  }) async {
    ZoRetryManager.instance.retryWhenOnline(
      apiCall,
      maxRetries: maxRetries,
      delay: delay,
    );
  }
}
