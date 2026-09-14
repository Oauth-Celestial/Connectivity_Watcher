

# connectivity_watcher

[![pub package](https://img.shields.io/pub/v/connectivity_watcher.svg)](https://pub.dev/packages/connectivity_watcher)
[![pub points](https://img.shields.io/pub/points/connectivity_watcher?color=2E8B57&label=pub%20points)](https://pub.dev/packages/connectivity_watcher/score)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)

**A lightning-fast Flutter plugin for true internet connectivity monitoring and connection mode detection.** Most connectivity packages only check if the device's Wi-Fi or Mobile radio is "on." **ZoConnectivityWatcher** goes further by combining OS-level hardware detection (via `connectivity_plus`) with active reachability probes. It tells you the exact **Connection Mode** (Wi-Fi, Mobile Data, Ethernet, VPN, etc.) and detects "Liar Wi-Fi" (connected to a router but no data flow) in sub-second time without flooding Flutter DevTools.

<img width="382" height="650" alt="network" src="https://github.com/user-attachments/assets/f04e2307-c78d-4c53-94fa-013a2f451e85" />



---

## 🧑‍💻 Getting Started

### 1. Install the package

```yaml
dependencies:
  flutter:
    sdk: flutter
  connectivity_watcher: ^[latest_version]
```

### 2. Import it

```dart
import 'package:connectivity_watcher/connectivity_watcher.dart';
```

### 3. Initialize it in main.dart

**Basic Setup**

Initialize the watcher in your main.dart. By default, it uses DNS socket checks (Google/Cloudflare) to verify connectivity.

```dart
WidgetsFlutterBinding.ensureInitialized();
ZoConnectivityWatcher().setUp(
  checkInterval: Duration(seconds: 1)
  );
```


## 🔌 Basic Usage
| **Custom UI** | **SnackBar Style** | **Alert Dialog** |
|:-------------:|:------------------:|:----------------:|
| ![Custom](https://github.com/Oauth-Celestial/Connectivity_Watcher/assets/119127289/b72c6bcc-d782-4bbf-93fe-a7b63f8ea818) | ![SnackBar](https://github.com/Oauth-Celestial/Connectivity_Watcher/assets/119127289/af375c80-1942-4410-b7ff-cf167c131f7f) | ![Alert](https://github.com/Oauth-Celestial/Connectivity_Watcher/assets/119127289/7b50b018-d863-44e9-afb3-d627cdafd9a2) |

### Wrap Your App

Use `ZoConnectivityWrapper` at the root of your app to monitor connection changes:

```dart
ZoConnectivityWrapper(
  connectivityStyle: NoConnectivityStyle.SNACKBAR,
  builder: (context, connectionKey) {
    return MaterialApp(
      navigatorKey: connectionKey,
      home: LoginDemo(),
    );
  },
);
```

### Use Prebuilt UI Styles

#### Snackbar Style

```dart
connectivityStyle: NoConnectivityStyle.SNACKBAR,
```

#### Alert Dialog Style

```dart
connectivityStyle: NoConnectivityStyle.ALERT,
```

---

## 🧩 Custom Offline Widget

Want to show your own offline UI? Use `NoConnectivityStyle.CUSTOM`:

```dart
ZoConnectivityWrapper(
  connectivityStyle: NoConnectivityStyle.CUSTOM,
  offlineWidget: CustomNoInternetWrapper(
    builder: (context) => CustomNoInternet(),
  ),
  builder: (context, connectionKey) => MaterialApp(
    navigatorKey: connectionKey,
    home: LoginDemo(),
  ),
);
```

The widget is auto-removed once the internet is back. You can also remove it manually:

```dart
bool removed = await ZoConnectivityWatcher().hideNoInternet();
if (!removed) {
  print("Still no internet");
}
```

---

## 🔁 API Call with Retry

Automatically retries failed API calls after connectivity is restored:

```dart
ZoConnectivityWatcher().makeApiCallWithRetry(
  maxRetries: 2,
  delay: const Duration(seconds: 1),
  apiCall: () async {
    final dio = Dio();
    dio.interceptors.add(CurlInterceptor());

    final response = await dio.post(
      "https://jsonplaceholder.typicode.com/posts",
      data: {
        "title": 'foo',
        "body": 'bar',
        "userId": 1,
      },
    );
  },
);
```

---

## 🌐 Check Internet Manually

```dart
bool hasInternet = await ZoConnectivityWatcher().isInternetAvailable;
```

---

## 🧠 Network-Aware Widgets

Use `ZoNetworkAwareWidget` to render UI dynamically based on real-time internet status and connection mode:

```dart
ZoNetworkAwareWidget(
  builder: (context, status, ConnectionMode mode) {
    if (status == ConnectivityWatcherStatus.disconnected) {
      return const Text('Offline', style: TextStyle(color: Colors.red));
    }
    return Text(
      'Online via ${mode.label}', // e.g. "Online via Wi-Fi" or "Online via Mobile Data"
      style: const TextStyle(color: Colors.green),
    );
  },
);
```


---

## Connection Mode Detection

Know exactly where your user's internet is coming from (**Wi-Fi, Mobile Data, Ethernet, VPN, etc.**) so you can optimize data-heavy tasks like video streaming or background file sync:

### 1. Get Connection Mode Directly

```dart
// Asynchronous real-time hardware query
ConnectionMode mode = await ZoConnectivityWatcher().getConnectionMode();

print(mode.label);    // "Wi-Fi", "Mobile Data", "Ethernet", "VPN", etc.
print(mode.isWifi);   // true / false
print(mode.isMobile); // true / false
print(mode.isVpn);    // true / false

// Instant synchronous access
ConnectionMode currentMode = ZoConnectivityWatcher().getCurrentConnectionMode();
// or: ZoConnectivityWatcher().connectionMode;
```

### 2. Listen to Mode Changes in Real-Time

```dart
// Emits only when the network interface switches (e.g. Wi-Fi -> Mobile Data)
ZoConnectivityWatcher().connectionModeStream.listen((ConnectionMode mode) {
  print("Switched to: ${mode.label}");
});

// Unified stream emitting both connectivity status and connection mode
ZoConnectivityWatcher().eventStream.listen((ConnectivityWatcherEvent event) {
  print("Status: ${event.status}");                 // connected / disconnected
  print("Mode: ${event.mode.label}");               // "Wi-Fi", "Mobile Data"
  print("Active Interfaces: ${event.activeModes}"); // e.g. [wifi, vpn]
  print("Timestamp: ${event.timestamp}");
});
```

### 3. Make API Calls with Mode Awareness

```dart
ZoConnectivityWatcher().makeApiCall(
  apiCall: (bool isConnected, ConnectionMode mode) {
    if (isConnected && mode.isWifi) {
      // Perform large file sync on unmetered Wi-Fi
    }
  },
);
```


---

## 🧪 Curl Logging for Dio

Log API requests as curl commands in your console:

```dart
final dio = Dio();
dio.interceptors.add(CurlInterceptor());
```
---

## 🔎 In-App Network Inspector (Beta)


Monitor all HTTP traffic directly inside your app, similar to the Chrome Network Tab. You can view status codes, active connection mode (Wi-Fi, Mobile Data, etc.), request/response bodies, headers, and easily copy cURL commands.

### 1. Attach the Logger
Add the `NetworkLoggerInterceptor` to your Dio client to start tracking:

```dart
final dio = Dio();
ZoConnectivityWatcher().setupDioLogger(dio);
```

### 2. Open the Inspector
Open the UI from anywhere in your app to view the logs:

```dart
ZoConnectivityWatcher().showNetworkLogsScreen(context);
```

### 3. Manage Logs Programmatically
You can also access or clear the logs in code:

```dart
// Get all logs
final logs = ZoConnectivityWatcher().getNetworkLogs();

// Clear logs
ZoNetworkLogManager.instance.clearLogs();
```

---

## ⚡ Ping System 

Measure exact round-trip latency to servers in real-time and display it in your app, similar to AAA gaming titles (e.g. *PUBG*, *Valorant*). It uses ultra-lightweight stealth DNS resolution with automatic multi-host failover across major global networks (`google.com`, `apple.com`, `microsoft.com`, `cloudflare.com`). It **never gets blocked by corporate firewalls** and **never floods your Flutter DevTools Network tab**.

### 1. Initialize the Ping Service
Start the service in your initialization block. You can ping your own API or backend server, or leave it blank to automatically failover across globally whitelisted major backbones:

```dart
// Defaults to multi-host failover across Google, Apple, Microsoft & Cloudflare
ZoConnectivityWatcher().initPingService();

// Or measure latency to your own corporate server / API:
ZoConnectivityWatcher().initPingService(
  targetHosts: ['api.yourdomain.com', 'google.com'],
  interval: const Duration(seconds: 2),
);
```

### 2. Display the Ping Widget
Add the `ZoPingWidget` anywhere in your UI. It automatically updates and color-codes the ping in milliseconds (Green for <100ms, Orange for <200ms, Red for >200ms):

```dart
AppBar(
  actions: [
    ZoPingWidget(
      goodPingThreshold: 100,
      mediumPingThreshold: 200,
    ),
  ],
)
```

---

## 🛠️ Feature Requests & Bugs

Have an idea or found a bug? Open an issue on [GitHub](https://github.com/Oauth-Celestial/Connectivity_Watcher/issues).

---

## 📦 More From Me

- [zo_animated_border](https://pub.dev/packages/zo_animated_border): Modern gradient border animations.
- [zo_app_blocker](https://pub.dev/packages/zo_app_blocker): A Flutter plugin to block specific applications on Android.
- [zo_micro_interactions](https://pub.dev/packages/zo_micro_interactions): A curated set of high-quality Flutter micro-interactions designed for modern, polished apps.
- [zo_screenshot](https://pub.dev/packages/zo_screenshot): Prevent screenshots and record secure areas.
- [theme_manager_plus](https://pub.dev/packages/theme_manager_plus): Manage Flutter themes with custom classes.
- [ultimate_extension](https://pub.dev/packages/ultimate_extension): Powerful utilities for Dart collections.
- [date_util_plus](https://pub.dev/packages/date_util_plus): Simplified date & time utilities.
- [pick_color](https://pub.dev/packages/pick_color): Extract colors from images by tapping.
