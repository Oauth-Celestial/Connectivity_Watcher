import 'package:connectivity_watcher/core/models/network_log_model.dart';
import 'package:flutter/foundation.dart';

class ZoNetworkLogManager {
  ZoNetworkLogManager._();
  static final ZoNetworkLogManager instance = ZoNetworkLogManager._();

  final ValueNotifier<List<NetworkLogModel>> logsNotifier = ValueNotifier([]);

  List<NetworkLogModel> get logs => logsNotifier.value;

  void addLog(NetworkLogModel log) {
    final updatedList = List<NetworkLogModel>.from(logs)..insert(0, log);
    logsNotifier.value = updatedList;
  }

  void updateLog(NetworkLogModel log) {
    final index = logs.indexWhere((element) => element.id == log.id);
    if (index != -1) {
      final updatedList = List<NetworkLogModel>.from(logs);
      updatedList[index] = log;
      logsNotifier.value = updatedList;
    }
  }

  void clearLogs() {
    logsNotifier.value = [];
  }
}
