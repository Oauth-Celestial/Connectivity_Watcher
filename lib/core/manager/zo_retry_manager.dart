import 'dart:async';
import 'package:connectivity_watcher/core/service/zo_connectivity_watcher_service.dart';

class ZoRetryManager {
  ZoRetryManager._();
  static final instance = ZoRetryManager._();

  final _tasks = <_RetryTask>[];
  bool _listening = false;
  StreamSubscription? _sub;

  void retryWhenOnline(
    Future<void> Function() task, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 2),
  }) async {
    if (await ZoConnectivityWatcher().isInternetAvailable) {
      _tryRun(task, maxRetries, delay);
    } else {
      _tasks.add(_RetryTask(task, maxRetries, delay));
      _listen();
    }
  }

  void _listen() {
    if (_listening) return;
    _listening = true;
    _sub = ZoConnectivityWatcher().stream.listen((_) async {
      if (await ZoConnectivityWatcher().isInternetAvailable) _runQueue();
    });
  }

  Future<void> _runQueue() async {
    final tasks = List.of(_tasks);
    _tasks.clear();

    for (final task in tasks) {
      _tryRun(task.fn, task.left, task.delay);
    }

    if (_tasks.isEmpty) _stop();
  }

  Future<void> _tryRun(
      Future<void> Function() fn, int left, Duration delay) async {
    try {
      await fn();
    } catch (_) {
      if (left > 1) {
        _tasks.add(_RetryTask(fn, left - 1, delay));
        await Future.delayed(delay);
      }
    }
  }

  void _stop() {
    _sub?.cancel();
    _sub = null;
    _listening = false;
  }

  void dispose() {
    _stop();
    _tasks.clear();
  }
}

class _RetryTask {
  final Future<void> Function() fn;
  final int left;
  final Duration delay;
  _RetryTask(this.fn, this.left, this.delay);
}
