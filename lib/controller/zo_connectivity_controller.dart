import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:connectivity_watcher/core/manager/socket_internet_checker.dart';
import 'package:connectivity_watcher/core/service/zo_connectivity_watcher_service.dart';
import 'package:connectivity_watcher/core/widgets/dialogue/native_alert.dart';
import 'package:connectivity_watcher/screens/custom_no_internet.dart';
import 'package:flutter/material.dart';

class ConnectionResolution {
  final ConnectionMode primary;
  final List<ConnectionMode> active;

  const ConnectionResolution({
    required this.primary,
    required this.active,
  });
}

class ZoConnectivityController {
  GlobalKey<NavigatorState> _contextKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get contextKey => _contextKey;

  OverlayEntry? _overlayEntry;
  BuildContext? _overlayEntryContext;
  OverlayState? _overlayState;

  CustomNoInternetWrapper? _userWidget;
  NoConnectivityStyle? _connectivityStyle;
  Widget? _customAlert;

  bool isAlertActive = false;
  BuildContext? currentContext;

  final StreamController<bool> _statusController =
      StreamController.broadcast();

  ZoConnectivityController._();

  static final ZoConnectivityController _instance =
      ZoConnectivityController._();

  factory ZoConnectivityController() {
    return _instance;
  }

  final Connectivity _connectivity = Connectivity();
  final StealthInternetChecker _stealthInternetChecker =
      StealthInternetChecker();
  final Debouncer _debouncer = Debouncer(delay: const Duration(seconds: 1));

  StreamSubscription<List<ConnectivityResult>>? _hardwareSubscription;
  StreamSubscription<bool>? _probeSubscription;
  StreamSubscription<bool>? _uiListenerSubscription;

  ConnectionMode _currentMode = ConnectionMode.wifi;
  List<ConnectionMode> _activeModes = [ConnectionMode.wifi];
  bool _isInitialCheck = true;

  ConnectionMode get currentMode => _currentMode;
  List<ConnectionMode> get activeModes => List.unmodifiable(_activeModes);

  static ConnectionMode mapResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return ConnectionMode.wifi;
      case ConnectivityResult.mobile:
        return ConnectionMode.mobile;
      case ConnectivityResult.ethernet:
        return ConnectionMode.ethernet;
      case ConnectivityResult.bluetooth:
        return ConnectionMode.bluetooth;
      case ConnectivityResult.vpn:
        return ConnectionMode.vpn;
      case ConnectivityResult.other:
        return ConnectionMode.other;
      case ConnectivityResult.none:
        return ConnectionMode.none;
      default:
        if (result.name.toLowerCase() == 'satellite') {
          return ConnectionMode.satellite;
        }
        return ConnectionMode.other;
    }
  }

  static ConnectionResolution resolveModes(List<ConnectivityResult> results) {
    if (results.isEmpty ||
        (results.length == 1 && results.first == ConnectivityResult.none)) {
      return const ConnectionResolution(
        primary: ConnectionMode.none,
        active: [ConnectionMode.none],
      );
    }

    final activeModes = results
        .where((r) => r != ConnectivityResult.none)
        .map(mapResult)
        .toSet()
        .toList();

    if (activeModes.isEmpty) {
      return const ConnectionResolution(
        primary: ConnectionMode.none,
        active: [ConnectionMode.none],
      );
    }

    ConnectionMode primary;
    if (activeModes.contains(ConnectionMode.ethernet)) {
      primary = ConnectionMode.ethernet;
    } else if (activeModes.contains(ConnectionMode.wifi)) {
      primary = ConnectionMode.wifi;
    } else if (activeModes.contains(ConnectionMode.mobile)) {
      primary = ConnectionMode.mobile;
    } else if (activeModes.contains(ConnectionMode.vpn)) {
      primary = ConnectionMode.vpn;
    } else if (activeModes.contains(ConnectionMode.bluetooth)) {
      primary = ConnectionMode.bluetooth;
    } else {
      primary = activeModes.first;
    }

    return ConnectionResolution(primary: primary, active: activeModes);
  }

  Future<void> setUp({Duration? checkInterval, Duration? timeout}) async {
    if (timeout != null) {
      _stealthInternetChecker.timeout = timeout;
    }
    if (checkInterval != null) {
      _stealthInternetChecker.checkInterval = checkInterval;
    }

    // Cancel any existing subscriptions to prevent duplicate event delivery
    await _hardwareSubscription?.cancel();
    await _probeSubscription?.cancel();

    // 1. Initial Hardware & Reachability Check
    try {
      final initialResults = await _connectivity.checkConnectivity();
      final resolution = resolveModes(initialResults);
      _currentMode = resolution.primary;
      _activeModes = resolution.active;

      bool hasInternet = false;
      if (_currentMode != ConnectionMode.none) {
        hasInternet = await _stealthInternetChecker.getCurrentStatus();
      } else {
        // Double check in case platform channel returns none prematurely during app startup
        hasInternet = await _stealthInternetChecker.getCurrentStatus();
        if (hasInternet) {
          _currentMode = ConnectionMode.wifi;
          _activeModes = [ConnectionMode.wifi];
        }
      }

      _isInitialCheck = false;

      if (hasInternet) {
        _stealthInternetChecker.notifyOnline();
        _statusController.add(true);
        ZoConnectivityWatcher().updateStatusAndMode(
          status: ConnectivityWatcherStatus.connected,
          mode: _currentMode,
          activeModes: _activeModes,
        );
      } else {
        _stealthInternetChecker.notifyOffline();
        _statusController.add(false);
        ZoConnectivityWatcher().updateStatusAndMode(
          status: ConnectivityWatcherStatus.disconnected,
          mode: _currentMode,
          activeModes: _activeModes,
        );
      }
    } catch (e) {
      _isInitialCheck = false;
      debugPrint('ZoConnectivityController: hardware check error: $e');
    }

    // 2. Hardware Change Stream (Airplane mode, Wi-Fi on/off, Cellular handover)
    _hardwareSubscription =
        _connectivity.onConnectivityChanged.listen((results) {
      _handleHardwareChange(results);
    });

    // 3. Active Probe Stream (internet reachability)
    _probeSubscription =
        _stealthInternetChecker.onStatusChange.listen((hasInternet) {
      void applyStatus() {
        _statusController.add(hasInternet);
        final status = hasInternet
            ? ConnectivityWatcherStatus.connected
            : ConnectivityWatcherStatus.disconnected;

        ZoConnectivityWatcher().updateStatusAndMode(
          status: status,
          mode: _currentMode,
          activeModes: _activeModes,
        );
      }

      if (_isInitialCheck) {
        _isInitialCheck = false;
        applyStatus();
      } else {
        _debouncer(applyStatus);
      }
    });
  }

  void _handleHardwareChange(List<ConnectivityResult> results) {
    if (_isInitialCheck) return;

    final resolution = resolveModes(results);
    final previousMode = _currentMode;
    _currentMode = resolution.primary;
    _activeModes = resolution.active;

    if (_currentMode == ConnectionMode.none) {
      // Hardware disconnected: instant 0ms offline transition
      _stealthInternetChecker.notifyOffline();
      _statusController.add(false);
      ZoConnectivityWatcher().updateStatusAndMode(
        status: ConnectivityWatcherStatus.disconnected,
        mode: ConnectionMode.none,
        activeModes: [ConnectionMode.none],
      );
    } else {
      // Hardware active: update mode immediately and trigger probe to verify internet reachability
      if (previousMode != _currentMode) {
        ZoConnectivityWatcher().updateStatusAndMode(
          status: ZoConnectivityWatcher().isInternetAvailable
              ? ConnectivityWatcherStatus.connected
              : ConnectivityWatcherStatus.disconnected,
          mode: _currentMode,
          activeModes: _activeModes,
        );
      }
      _stealthInternetChecker.triggerCheck();
    }
  }

  void notifyOnline() {
    _stealthInternetChecker.notifyOnline();
  }

  Future<void> setupConnectivityListner({
    CustomNoInternetWrapper? offlineWidget,
    GlobalKey<NavigatorState>? navigatorKey,
    NoConnectivityStyle? connectivityStyle = NoConnectivityStyle.SNACKBAR,
    Widget? customAlert,
  }) async {
    if (_hardwareSubscription == null || _probeSubscription == null) {
      await setUp();
    }

    if (connectivityStyle != NoConnectivityStyle.NONE) {
      if (navigatorKey != null) {
        _contextKey = navigatorKey;
      }
      _userWidget = offlineWidget;
      _customAlert = customAlert;
      _connectivityStyle = connectivityStyle;

      if (_connectivityStyle == NoConnectivityStyle.CUSTOM &&
          _userWidget == null) {
        throw ("widgetForNoInternet is missing");
      }

      if (_connectivityStyle == NoConnectivityStyle.CUSTOMALERT &&
          _customAlert == null) {
        throw ("customAlert  is missing");
      }
    }

    // Cancel existing UI listener to prevent duplicate handlers
    await _uiListenerSubscription?.cancel();
    _uiListenerSubscription = _statusController.stream.listen((status) {
      if (_connectivityStyle == NoConnectivityStyle.CUSTOM &&
          _contextKey.currentState?.overlay != null) {
        _overlayState = _contextKey.currentState!.overlay;
      }

      if (status) {
        if (connectivityStyle != NoConnectivityStyle.NONE) {
          _removeNoInternet();
        }
      } else {
        if (connectivityStyle != NoConnectivityStyle.NONE) {
          showNoInternet();
        }
      }
    });
  }

  Future<bool> hideNoInternetScreen() async {
    bool removed = await _removeNoInternet();
    if (removed) {
      ZoConnectivityWatcher().isNoInternetWidgetVisible = false;
    }
    return removed;
  }

  Future<void> isInternetBack({required Function(bool) internetStatus}) async {
    final isConnected = await _stealthInternetChecker.getCurrentStatus();

    if (isConnected) {
      await _removeNoInternet();
      internetStatus(true);
    } else {
      internetStatus(false);
    }
  }

  void showSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Row(
        children: const [
          Icon(Icons.wifi_off_sharp, color: Colors.white),
          SizedBox(width: 20),
          Text('No Internet'),
        ],
      ),
      backgroundColor: Colors.black,
      behavior: SnackBarBehavior.fixed,
      dismissDirection: DismissDirection.none,
      duration: const Duration(days: 1),
      action: SnackBarAction(
        label: 'Try Again',
        disabledTextColor: Colors.white,
        textColor: Colors.white,
        onPressed: () {
          isInternetBack(
            internetStatus: (value) {
              if (value) {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
              } else {
                showSnackBar(context);
              }
            },
          );
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<bool> _removeNoInternet() async {
    ZoConnectivityWatcher().isInternetAvailable = true;
    ZoConnectivityWatcher().isNoInternetWidgetVisible = false;

    currentContext = _contextKey.currentContext;
    if (_connectivityStyle == NoConnectivityStyle.CUSTOM &&
        _overlayEntryContext != null) {
      currentContext = _overlayEntryContext;
    }

    if (currentContext == null) {
      return false;
    }

    if (_connectivityStyle == NoConnectivityStyle.SNACKBAR) {
      try {
        ScaffoldMessenger.of(currentContext!).removeCurrentSnackBar();
        return true;
      } catch (e) {
        debugPrint('ZoConnectivityController: failed to remove snackbar: $e');
        return false;
      }
    }

    if ((_connectivityStyle == NoConnectivityStyle.ALERT ||
            _connectivityStyle == NoConnectivityStyle.CUSTOMALERT) &&
        isAlertActive) {
      isAlertActive = false;
      return true;
    }

    _overlayEntry?.remove();
    _overlayEntry = null;
    _overlayEntryContext = null;
    return true;
  }

  void showNoInternet() {
    if (_isInitialCheck) {
      return;
    }

    if (ZoConnectivityWatcher().isNoInternetWidgetVisible) {
      return;
    }

    currentContext = _contextKey.currentContext;
    if (currentContext == null) {
      return;
    }

    ZoConnectivityWatcher().isNoInternetWidgetVisible = true;

    if (_connectivityStyle == NoConnectivityStyle.SNACKBAR) {
      showSnackBar(currentContext!);
    } else if (_connectivityStyle == NoConnectivityStyle.ALERT &&
        !isAlertActive) {
      showPlatformAlert();
    } else if (_connectivityStyle == NoConnectivityStyle.CUSTOMALERT &&
        !isAlertActive) {
      showDialog(
        context: currentContext!,
        builder: (context) {
          isAlertActive = true;
          return _customAlert!;
        },
      );
    } else {
      _overlayEntry = OverlayEntry(
        builder: (context) {
          _overlayEntryContext = context;
          return _userWidget ??
              Container(
                color: Colors.amber,
                child: const Text("No Internet"),
              );
        },
      );
      _overlayState?.insert(_overlayEntry!);
    }
  }

  Future<bool> getConnectivityStatus() async {
    if (_currentMode == ConnectionMode.none) {
      return false;
    }
    return await _stealthInternetChecker.getCurrentStatus();
  }

  /// Directly queries the network hardware interfaces and returns the active [ConnectionMode].
  Future<ConnectionMode> getConnectionMode() async {
    try {
      final results = await _connectivity.checkConnectivity();
      final resolution = resolveModes(results);
      _currentMode = resolution.primary;
      _activeModes = resolution.active;
      return _currentMode;
    } catch (_) {
      return _currentMode;
    }
  }

  void showPlatformAlert() {
    currentContext = _contextKey.currentContext;
    if (currentContext == null) {
      return;
    }

    isAlertActive = true;
    showNativeDialogue(
      currentContext!,
      () {
        isInternetBack(
          internetStatus: (status) {
            if (status) {
              isAlertActive = false;
              Navigator.pop(currentContext!);
            } else {
              Navigator.pop(currentContext!);
              Future.delayed(
                const Duration(seconds: 1),
                showPlatformAlert,
              );
            }
          },
        );
      },
    );
  }
}
