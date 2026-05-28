import 'dart:async';
import 'dart:io';

class ZoPingService {
  ZoPingService._();
  static final ZoPingService instance = ZoPingService._();

  StreamController<int>? _pingController;
  Timer? _timer;
  
  String _targetIp = '8.8.8.8';
  int _targetPort = 443;
  Duration _interval = const Duration(seconds: 2);
  Duration _timeout = const Duration(seconds: 3);

  /// Returns a stream of ping latencies in milliseconds.
  Stream<int> get pingStream {
    _pingController ??= StreamController<int>.broadcast(
      onListen: _startPinging,
      onCancel: _stopPinging,
    );
    return _pingController!.stream;
  }

  /// Initialize the ping service with custom settings.
  /// If not called, defaults to pinging Google DNS (8.8.8.8:443) every 2 seconds.
  void init({
    String? targetIp,
    int? targetPort,
    Duration? interval,
    Duration? timeout,
  }) {
    if (targetIp != null) _targetIp = targetIp;
    if (targetPort != null) _targetPort = targetPort;
    if (interval != null) _interval = interval;
    if (timeout != null) _timeout = timeout;
  }

  void _startPinging() {
    _measurePing();
    _timer = Timer.periodic(_interval, (_) => _measurePing());
  }

  void _stopPinging() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _measurePing() async {
    if (_pingController == null || !_pingController!.hasListener) return;

    final stopwatch = Stopwatch()..start();
    try {
      final socket = await Socket.connect(_targetIp, _targetPort, timeout: _timeout);
      socket.destroy();
      stopwatch.stop();
      _pingController?.add(stopwatch.elapsedMilliseconds);
    } catch (_) {
      // If it fails or times out, we can emit a -1 to indicate failure, or emit the timeout duration
      _pingController?.add(-1);
    }
  }

  void dispose() {
    _stopPinging();
    _pingController?.close();
    _pingController = null;
  }
}
