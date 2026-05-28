import 'dart:async';
import 'package:connectivity_watcher/core/manager/socket_internet_checker.dart';
import 'package:connectivity_watcher/core/service/zo_connectivity_watcher_service.dart';
import 'package:connectivity_watcher/core/widgets/dialogue/native_alert.dart';
import 'package:connectivity_watcher/screens/custom_no_internet.dart';

import 'package:flutter/material.dart';

class ZoConnectivityController {
  GlobalKey<NavigatorState> _contextKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get contextKey => _contextKey;

  OverlayEntry? _entry;

  /// list of overlay entries to all the reference of overlays drawn
  List<OverlayEntry> _entries = [];
  List<BuildContext> _overlayContext = [];

  /// Overlay state
  OverlayState? _overlayState;

  /// Custom No Internet widget provided by the user
  CustomNoInternetWrapper? _userWidget;
  NoConnectivityStyle? _connectivityStyle;

  bool isAlertActive = false;
  BuildContext? currentContext;
  Widget? _customAlert;

  StreamController<bool> _statusController = StreamController.broadcast();

  ZoConnectivityController._();

  static final ZoConnectivityController _instance =
      ZoConnectivityController._();

  factory ZoConnectivityController() {
    return _instance;
  }
  StreamSubscription<bool>? _subscription;

  StealthInternetChecker _stealthInternetChecker = StealthInternetChecker();

  Debouncer _debouncer = Debouncer(delay: Duration(seconds: 1));

  void setUp({StealthInternetChecker? internetChecker}) async {
    if (internetChecker != null) {
      _stealthInternetChecker = internetChecker;
    }
    _subscription = _stealthInternetChecker.onStatusChange.listen((status) {
      _debouncer(
        () {
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
        },
      );
    });
  }

  void setupConnectivityListner({
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
          (_contextKey.currentState?.overlay) != null) {
        _overlayState = (_contextKey.currentState!.overlay);
      }

      if (status) {
        try {
          if (connectivityStyle != NoConnectivityStyle.NONE) {
            _removeNoInternet(trusted: true);
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      } else {
        if (connectivityStyle != NoConnectivityStyle.NONE) {
          showNoInternet();
        }
      }
    });
  }

  /// removes the no internet screen when internet comes back
  Future<bool> hideNoInternetScreen() async {
    bool removed = await _removeNoInternet();
    if (removed) {
      ZoConnectivityWatcher().isNoInternetWidgetVisible = false;
    }
    return removed;
  }

  void isInternetBack({required Function(bool) internetStatus}) async {
    bool isConnected = await _stealthInternetChecker.hasInternet();

    if (isConnected) {
      _removeNoInternet();
      internetStatus(true);
    } else {
      internetStatus(false);
    }
  }

  /// Shows Snackbar
  void showSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Row(children: [
        Icon(
          Icons.wifi_off_sharp,
          color: Colors.white,
        ),
        SizedBox(
          width: 20,
        ),
        Text('No Internet'),
      ]),
      backgroundColor: Colors.black,
      behavior: SnackBarBehavior.fixed,
      dismissDirection: DismissDirection.none,
      duration: Duration(days: 1),
      action: SnackBarAction(
        label: 'Try Again',
        disabledTextColor: Colors.white,
        textColor: Colors.white,
        onPressed: () {
          isInternetBack(internetStatus: (value) {
            if (value) {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
            } else {
              showSnackBar(context);
            }
          });
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Removes the No internet widget from the tree and clears overlay entry
  Future<bool> _removeNoInternet({bool trusted = false}) async {
    if (!trusted) {
      bool isNetworkBack = await getConnectivityStatus();
      if (!isNetworkBack) {
        return false;
      }
    }

    ZoConnectivityWatcher().isInternetAvailable = true;
    ZoConnectivityWatcher().isNoInternetWidgetVisible = false;

    currentContext = _contextKey.currentContext;
    if (_connectivityStyle == NoConnectivityStyle.CUSTOM &&
        _overlayContext.isNotEmpty) {
      currentContext = _overlayContext.last;
    }
    if (currentContext != null) {
      if (_connectivityStyle == NoConnectivityStyle.SNACKBAR) {
        try {
          ScaffoldMessenger.of(currentContext!).removeCurrentSnackBar();
          return true;
        } catch (e) {
          debugPrint("error: $e");
          return false;
        }
      } else if ((_connectivityStyle == NoConnectivityStyle.ALERT ||
              _connectivityStyle == NoConnectivityStyle.CUSTOMALERT) &&
          isAlertActive) {
        isAlertActive = false;
        return true;
      } else {
        for (var entry in _entries) {
          if (entry.mounted) {
            entry.remove();
          }
        }
        _entries.clear();
        _overlayContext.clear();
        return true;
      }
    } else {
      return false;
    }
  }

  /// Responsible for getting the current context from the tree and draw the  custom widget
  void showNoInternet() {
    if (ZoConnectivityWatcher().isNoInternetWidgetVisible) {
      return;
    }
    currentContext = _contextKey.currentContext;
    if (currentContext != null) {
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
        if (_connectivityStyle == NoConnectivityStyle.CUSTOM &&
            _contextKey.currentState?.overlay != null) {
          _overlayState = _contextKey.currentState!.overlay;
        } else if (_overlayState == null) {
          _overlayState = Overlay.of(currentContext!);
        }

        _entry = OverlayEntry(builder: (context) {
          _overlayContext.add(context);
          return _userWidget ??
              Container(
                color: Colors.amber,
                child: Text("No Internet"),
              );
        });
        _entries.add(_entry!);
        _overlayState?.insert(_entry!);
      }
    }
  }

  /// Get status of conncetion
  Future<bool> getConnectivityStatus() async {
    bool isconnected = await _stealthInternetChecker.hasInternet();
    return isconnected;
  }

  void showPlatformAlert() {
    currentContext = _contextKey.currentContext;
    if (currentContext != null) {
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
                  Duration(seconds: 1),
                  () {
                    showPlatformAlert();
                  },
                );
              }
            },
          );
        },
      );
    }
  }
}
