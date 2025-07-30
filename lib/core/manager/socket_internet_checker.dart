import 'dart:async';
import 'dart:io';
import 'dart:ui';

class StealthInternetChecker {
  final Duration checkInterval;
  final Duration timeout;
  InternetAddress? target;
  final int port;

  late final StreamController<bool> _controller;
  bool _lastStatus = false;
  Timer? _timer;

  StealthInternetChecker({
    this.checkInterval = const Duration(seconds: 2),
    this.timeout = const Duration(seconds: 2),
    InternetAddress? target,
    this.port = 53, // DNS port
  }) {
    this.target = target ?? InternetAddress('8.8.8.8');
    _controller = StreamController<bool>.broadcast(
      onListen: _start,
      onCancel: _stop,
    );
  }
  Future<bool> getCurrentStatus() async {
    return await _hasInternet();
  }

  Stream<bool> get onStatusChange => _controller.stream;

  void _start() {
    _timer = Timer.periodic(checkInterval, (_) => _checkInternet());
    _checkInternet(); // initial check
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _checkInternet() async {
    bool isConnected = await _hasInternet();
    if (isConnected != _lastStatus) {
      _lastStatus = isConnected;
      _controller.add(isConnected);
    }
  }

  Future<bool> _hasInternet() async {
    try {
      final socket = await Socket.connect(target, port, timeout: timeout);
      socket.destroy();
      return true;
    } catch (_) {
      return false;
    }
  }

  void dispose() {
    _stop();
    _controller.close();
  }
}

class Debouncer {
  final Duration delay;
  VoidCallback? _action;
  Timer? _timer;

  Debouncer({required this.delay});

  void call(VoidCallback action) {
    _timer?.cancel(); // Cancel previous timer
    _action = action;
    _timer = Timer(delay, () {
      _action?.call();
    });
  }

  void cancel() {
    _timer?.cancel();
  }
}
