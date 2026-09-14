import 'dart:async';
import 'dart:io';
import 'dart:ui';

class StealthInternetChecker {
  Duration checkInterval;
  Duration timeout;
  final int failureThreshold;

  static const List<String> defaultLookupHosts = [
    'google.com',
    'apple.com',
    'microsoft.com',
    'cloudflare.com',
  ];

  static final List<Uri> defaultProbeEndpoints = [
    Uri.parse('http://connectivitycheck.gstatic.com/generate_204'),
    Uri.parse('http://captive.apple.com/hotspot-detect.html'),
    Uri.parse('https://cp.cloudflare.com/generate_204'),
    Uri.parse('http://www.msftconnecttest.com/connecttest.txt'),
  ];

  List<String> lookupHosts;
  List<Uri> probeEndpoints;

  late final StreamController<bool> _controller;
  bool _lastStatus = true;
  int _consecutiveFailures = 0;
  bool _isChecking = false;
  Timer? _timer;

  StealthInternetChecker({
    this.checkInterval = const Duration(seconds: 2),
    this.timeout = const Duration(seconds: 2),
    this.failureThreshold = 2,
    List<String>? hosts,
    List<Uri>? endpoints,
    InternetAddress? target,
    int port = 53,
  })  : lookupHosts = hosts ?? List.from(defaultLookupHosts),
        probeEndpoints = endpoints ?? List.from(defaultProbeEndpoints) {
    _controller = StreamController<bool>.broadcast(
      onListen: _start,
      onCancel: _stop,
    );
  }

  Future<bool> getCurrentStatus() async {
    return await _hasInternet();
  }

  Stream<bool> get onStatusChange => _controller.stream;

  bool get lastStatus => _lastStatus;

  void _start() {
    _timer?.cancel();
    _timer = Timer.periodic(checkInterval, (_) => _checkInternet());
    _checkInternet(); // initial check
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
  }

  /// Externally notify that network is confirmed working (e.g. from successful HTTP responses).
  void notifyOnline() {
    _consecutiveFailures = 0;
    if (!_lastStatus) {
      _lastStatus = true;
      _controller.add(true);
    }
  }

  /// Externally notify that hardware is disconnected (e.g. Airplane Mode / No SIM / Wi-Fi off).
  void notifyOffline() {
    _consecutiveFailures = failureThreshold;
    if (_lastStatus) {
      _lastStatus = false;
      _controller.add(false);
    }
  }

  /// Triggers an immediate connectivity check out-of-band (e.g. when network interface changes).
  Future<void> triggerCheck() async {
    await _checkInternet();
  }

  Future<void> _checkInternet() async {
    if (_isChecking) return;
    _isChecking = true;

    try {
      bool isConnected = await _hasInternet();
      if (isConnected) {
        _consecutiveFailures = 0;
        if (!_lastStatus) {
          _lastStatus = true;
          _controller.add(true);
        }
      } else {
        _consecutiveFailures++;
        if (_consecutiveFailures >= failureThreshold) {
          if (_lastStatus) {
            _lastStatus = false;
            _controller.add(false);
          }
        }
      }
    } finally {
      _isChecking = false;
    }
  }

  Future<bool> _hasInternet() async {
    // 1. Primary Stealth Check: OS-level DNS resolution via InternetAddress.lookup.
    // This utilizes getaddrinfo() without creating HttpClient or Socket objects in
    // Dart VM, making it 100% invisible to the Flutter DevTools Network profiler.
    for (final host in lookupHosts) {
      try {
        final result = await InternetAddress.lookup(host).timeout(timeout);
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          return true;
        }
      } catch (_) {
        continue;
      }
    }

    // 2. Secondary fallback: HTTP 204 probes (only invoked if DNS resolution fails)
    for (final uri in probeEndpoints) {
      HttpClient? client;
      try {
        client = HttpClient()..connectionTimeout = timeout;
        final request = await client.getUrl(uri);
        final response = await request.close().timeout(timeout);
        if (response.statusCode == 204 || response.statusCode == 200) {
          return true;
        }
      } catch (_) {
        continue;
      } finally {
        try {
          client?.close(force: true);
        } catch (_) {}
      }
    }

    return false;
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
