import 'dart:async';
import 'package:connectivity_watcher/controller/zo_connectivity_controller.dart';
import 'package:connectivity_watcher/core/service/zo_connectivity_watcher_service.dart';
import 'package:connectivity_watcher/screens/custom_no_internet.dart';
import 'package:flutter/material.dart';

typedef ConnectionBuilder = Widget Function(
    BuildContext, GlobalKey<NavigatorState>);

class ZoConnectivityWrapper extends StatefulWidget {
  /// No internet widget that is to be shown
  final CustomNoInternetWrapper? offlineWidget;

  /// Connection Style for the Wrapper : Default to snackbar
  final NoConnectivityStyle? connectivityStyle;

  final ConnectionBuilder builder;

  /// If you already have the navigator key you can pass it here.
  /// If not passed, the package will assign its own key.
  final GlobalKey<NavigatorState>? navigationKey;

  final Widget? customAlert;

  /// Optional callback invoked when connectivity status or connection mode changes
  final void Function(ConnectivityWatcherStatus status, ConnectionMode mode)?
      onConnectivityChanged;

  /// Optional callback invoked when the connection mode changes (e.g. Wi-Fi to Mobile)
  final void Function(ConnectionMode mode)? onConnectionModeChanged;

  const ZoConnectivityWrapper({
    super.key,
    required this.builder,
    this.navigationKey,
    this.offlineWidget,
    this.customAlert,
    this.connectivityStyle = NoConnectivityStyle.SNACKBAR,
    this.onConnectivityChanged,
    this.onConnectionModeChanged,
  });

  @override
  State<ZoConnectivityWrapper> createState() => _ZoConnectivityWrapperState();
}

class _ZoConnectivityWrapperState extends State<ZoConnectivityWrapper> {
  final ZoConnectivityController _controller = ZoConnectivityController();
  StreamSubscription<ConnectivityWatcherEvent>? _eventSubscription;

  @override
  void initState() {
    super.initState();
    _initListener();
    _setupEventCallbacks();
  }

  void _initListener() {
    _controller.setupConnectivityListner(
      offlineWidget: widget.offlineWidget,
      navigatorKey: widget.navigationKey,
      customAlert: widget.customAlert,
      connectivityStyle: widget.connectivityStyle,
    );
    ZoConnectivityWatcher().setNavigatorKey(_controller.contextKey);
  }

  void _setupEventCallbacks() {
    if (widget.onConnectivityChanged != null ||
        widget.onConnectionModeChanged != null) {
      _eventSubscription =
          ZoConnectivityWatcher().eventStream.listen((event) {
        widget.onConnectivityChanged?.call(event.status, event.mode);
        widget.onConnectionModeChanged?.call(event.mode);
      });
    }
  }

  @override
  void didUpdateWidget(covariant ZoConnectivityWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.connectivityStyle != widget.connectivityStyle ||
        oldWidget.offlineWidget != widget.offlineWidget ||
        oldWidget.customAlert != widget.customAlert ||
        oldWidget.navigationKey != widget.navigationKey) {
      _initListener();
    }
  }

  @override
  void dispose() {
    _eventSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _controller.contextKey);
  }
}
