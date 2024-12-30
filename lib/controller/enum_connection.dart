part of '../core/service/zo_connectivity_watcher_service.dart';

enum ConnectivityWatcherStatus {
  /// connected to internet
  connected,

  /// disconnected from internet
  disconnected,
}

enum NoConnectivityStyle { SNACKBAR, ALERT, CUSTOM, CUSTOMALERT, NONE }
