import 'dart:async';
import 'package:connectivity_watcher/core/manager/socket_internet_checker.dart';
import 'package:connectivity_watcher/core/service/zo_connectivity_watcher_service.dart';
import 'package:connectivity_watcher/core/widgets/dialogue/native_alert.dart';
import 'package:connectivity_watcher/screens/custom_no_internet.dart';

import 'package:flutter/material.dart';

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

  StreamSubscription<bool>? _subscription;

  final StealthInternetChecker _stealthInternetChecker =
      StealthInternetChecker();

  final Debouncer _debouncer = Debouncer(delay: Duration(seconds: 1));

  Future<void> setUp({ Duration? checkInterval,
   Duration? timeout}) async {
  

    if(timeout!= null){
      _stealthInternetChecker.timeout = timeout;
    }
    if(checkInterval!= null){
       _stealthInternetChecker.checkInterval = checkInterval;
    }
    _subscription = _stealthInternetChecker.onStatusChange.listen((status) {
      _debouncer(() {
        _statusController.add(status);

        if (status) {
          ZoConnectivityWatcher().isInternetAvailable = true;
          ZoConnectivityWatcher()
              .updateStream(ConnectivityWatcherStatus.connected);
        } else {
          ZoConnectivityWatcher().isInternetAvailable = false;
          ZoConnectivityWatcher()
              .updateStream(ConnectivityWatcherStatus.disconnected);
        }
      });
    });
  }

  Future<void> setupConnectivityListner({
    CustomNoInternetWrapper? offlineWidget,
    GlobalKey<NavigatorState>? navigatorKey,
    NoConnectivityStyle? connectivityStyle = NoConnectivityStyle.SNACKBAR,
    Widget? customAlert,
  }) async {
    if (_subscription == null) {
      setUp();
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

    _statusController.stream.listen((status) {
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
    final isNetworkBack = await getConnectivityStatus();
    if (!isNetworkBack) {
      return false;
    }

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
    return await _stealthInternetChecker.getCurrentStatus();
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
