import 'dart:async';
import 'dart:io';

class ZoPingService {
  ZoPingService._();
  static final ZoPingService instance = ZoPingService._();

  StreamController<int>? _pingController;
  Timer? _timer;

  static const List<String> defaultPingHosts = [
    'google.com',
    'microsoft.com',
    'cloudflare.com',
  ];

  List<String> _targetHosts = List.from(defaultPingHosts);
  int _currentHostIndex = 0;
  Duration _interval = const Duration(seconds: 2);
  Duration _timeout = const Duration(seconds: 3);

  static String sanitizeHost(String input) {
    var host = input.trim();
    if (host.isEmpty) return host;

    if (host.contains('://')) {
      try {
        final uri = Uri.parse(host);
        if (uri.host.isNotEmpty) {
          return uri.host;
        }
      } catch (_) {}
    } else if (host.contains('/') || host.contains(':')) {
      // Handle schemes omitted like "google.com/path" or "example.com:8080"
      try {
        final uri = Uri.parse('http://$host');
        if (uri.host.isNotEmpty) {
          return uri.host;
        }
      } catch (_) {}
    }

    // Strip trailing slashes, paths, and ports as fallback
    if (host.contains('/')) {
      host = host.split('/').first;
    }
    if (host.contains(':')) {
      host = host.split(':').first;
    }

    return host;
  }

  /// Returns a stream of ping latencies in milliseconds.
  Stream<int> get pingStream {
    _pingController ??= StreamController<int>.broadcast(
      onListen: _startPinging,
      onCancel: _stopPinging,
    );
    return _pingController!.stream;
  }

  /// Initialize the ping service with custom settings.
  /// Supports complete URLs, hostnames, or IP addresses with automatic extraction
  /// and failover so firewalls or content blockers never block the ping measurement.
  void init({
    List<String>? targetHosts,
    String? targetHost,
    Duration? interval,
    Duration? timeout,
    String? targetIp,
    int? targetPort,
  }) {
    if (targetHosts != null && targetHosts.isNotEmpty) {
      _targetHosts = targetHosts.map(sanitizeHost).toList();
    } else if (targetHost != null) {
      _targetHosts = [sanitizeHost(targetHost), ...defaultPingHosts];
    } else if (targetIp != null) {
      _targetHosts = [sanitizeHost(targetIp), ...defaultPingHosts];
    }
    if (interval != null) _interval = interval;
    if (timeout != null) _timeout = timeout;
    _currentHostIndex = 0;
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

    // Iterate across redundant hosts if the active host is blocked or fails
    for (int i = 0; i < _targetHosts.length; i++) {
      final hostIndex = (_currentHostIndex + i) % _targetHosts.length;
      final rawHost = _targetHosts[hostIndex];
      final host = sanitizeHost(rawHost);
      if (host.isEmpty) continue;

      try {
        final result = await InternetAddress.lookup(host).timeout(_timeout);
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          stopwatch.stop();
          // Lock onto the working host for future pings
          _currentHostIndex = hostIndex;
          _pingController?.add(stopwatch.elapsedMilliseconds);
          return;
        }
      } catch (_) {
        // Current host blocked or unreachable; seamlessly try next host in pool
        continue;
      }
    }

    stopwatch.stop();
    _pingController?.add(-1);
  }

  void dispose() {
    _stopPinging();
    _pingController?.close();
    _pingController = null;
  }
}
