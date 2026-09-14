import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:connectivity_watcher/connectivity_watcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ConnectionMode enum tests', () {
    test('ConnectionMode getters and labels', () {
      expect(ConnectionMode.wifi.isWifi, isTrue);
      expect(ConnectionMode.wifi.label, 'Wi-Fi');
      expect(ConnectionMode.wifi.isConnected, isTrue);

      expect(ConnectionMode.mobile.isMobile, isTrue);
      expect(ConnectionMode.mobile.label, 'Mobile Data');
      expect(ConnectionMode.mobile.isConnected, isTrue);

      expect(ConnectionMode.ethernet.isEthernet, isTrue);
      expect(ConnectionMode.ethernet.label, 'Ethernet');

      expect(ConnectionMode.vpn.isVpn, isTrue);
      expect(ConnectionMode.vpn.label, 'VPN');

      expect(ConnectionMode.bluetooth.isBluetooth, isTrue);
      expect(ConnectionMode.bluetooth.label, 'Bluetooth');

      expect(ConnectionMode.satellite.isSatellite, isTrue);
      expect(ConnectionMode.satellite.label, 'Satellite');

      expect(ConnectionMode.none.isConnected, isFalse);
      expect(ConnectionMode.none.label, 'None');
    });
  });

  group('ConnectionMode mapping & resolution', () {
    test('mapResult maps correctly', () {
      expect(
          ZoConnectivityController.mapResult(ConnectivityResult.wifi),
          ConnectionMode.wifi);
      expect(
          ZoConnectivityController.mapResult(ConnectivityResult.mobile),
          ConnectionMode.mobile);
      expect(
          ZoConnectivityController.mapResult(ConnectivityResult.ethernet),
          ConnectionMode.ethernet);
      expect(
          ZoConnectivityController.mapResult(ConnectivityResult.vpn),
          ConnectionMode.vpn);
      expect(
          ZoConnectivityController.mapResult(ConnectivityResult.none),
          ConnectionMode.none);
    });

    test('resolveModes handles empty and none', () {
      final resEmpty = ZoConnectivityController.resolveModes([]);
      expect(resEmpty.primary, ConnectionMode.none);
      expect(resEmpty.active, [ConnectionMode.none]);

      final resNone =
          ZoConnectivityController.resolveModes([ConnectivityResult.none]);
      expect(resNone.primary, ConnectionMode.none);
      expect(resNone.active, [ConnectionMode.none]);
    });

    test('resolveModes prioritizes ethernet over wifi', () {
      final res = ZoConnectivityController.resolveModes(
          [ConnectivityResult.wifi, ConnectivityResult.ethernet]);
      expect(res.primary, ConnectionMode.ethernet);
      expect(res.active, containsAll([ConnectionMode.ethernet, ConnectionMode.wifi]));
    });

    test('resolveModes prioritizes wifi over mobile', () {
      final res = ZoConnectivityController.resolveModes(
          [ConnectivityResult.mobile, ConnectivityResult.wifi]);
      expect(res.primary, ConnectionMode.wifi);
      expect(res.active, containsAll([ConnectionMode.wifi, ConnectionMode.mobile]));
    });

    test('resolveModes handles wifi with vpn', () {
      final res = ZoConnectivityController.resolveModes(
          [ConnectivityResult.wifi, ConnectivityResult.vpn]);
      expect(res.primary, ConnectionMode.wifi);
      expect(res.active, containsAll([ConnectionMode.wifi, ConnectionMode.vpn]));
    });
  });

  group('ConnectivityWatcherEvent', () {
    test('Event equality and helpers', () {
      final now = DateTime.now();
      final event1 = ConnectivityWatcherEvent(
        status: ConnectivityWatcherStatus.connected,
        mode: ConnectionMode.wifi,
        activeModes: [ConnectionMode.wifi],
        timestamp: now,
      );
      final event2 = ConnectivityWatcherEvent(
        status: ConnectivityWatcherStatus.connected,
        mode: ConnectionMode.wifi,
        activeModes: [ConnectionMode.wifi],
        timestamp: now,
      );

      expect(event1, equals(event2));
      expect(event1.hasInternet, isTrue);
      expect(event1.mode.label, 'Wi-Fi');
    });

    test('getConnectionMode and getCurrentConnectionMode return ConnectionMode',
        () async {
      final syncMode = ZoConnectivityWatcher().getCurrentConnectionMode();
      expect(syncMode, isA<ConnectionMode>());

      final propertyMode = ZoConnectivityWatcher().connectionMode;
      expect(propertyMode, isA<ConnectionMode>());

      final asyncMode = await ZoConnectivityWatcher().getConnectionMode();
      expect(asyncMode, isA<ConnectionMode>());
    });

    test('ZoPingService.sanitizeHost handles complete URLs and hosts', () {
      expect(ZoPingService.sanitizeHost('https://api.example.com/v1/ping?foo=bar'),
          'api.example.com');
      expect(ZoPingService.sanitizeHost('http://192.168.1.1:8080/health'),
          '192.168.1.1');
      expect(ZoPingService.sanitizeHost('google.com:443'), 'google.com');
      expect(ZoPingService.sanitizeHost('example.com/some/path'), 'example.com');
      expect(ZoPingService.sanitizeHost('google.com'), 'google.com');
      expect(ZoPingService.sanitizeHost('  https://cloudflare.com/  '),
          'cloudflare.com');
    });
  });

  group('ZoNetworkAwareWidget tests', () {
    testWidgets('renders correctly with 3-arg builder (status + mode)',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ZoNetworkAwareWidget(
              builder: (context, status, ConnectionMode mode) {
                return Text('Status: ${status.name}, Mode: ${mode.label}');
              },
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.textContaining('Status:'), findsOneWidget);
    });

    testWidgets('renders correctly with legacy 2-arg builder',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ZoNetworkAwareWidget(
              builder: (context, ConnectivityWatcherStatus status) {
                return Text('Legacy Status: ${status.name}');
              },
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.textContaining('Legacy Status:'), findsOneWidget);
    });
  });
}
