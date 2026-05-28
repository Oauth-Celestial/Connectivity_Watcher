<img width="382" height="850" alt="WhatsAppVideo2026-05-28at2 49 00PM-ezgif com-optimize" src="https://github.com/user-attachments/assets/8756300e-e8eb-495e-9356-eba6e0a71aca" />

# connectivity_watcher

[![pub package](https://img.shields.io/pub/v/connectivity_watcher.svg)](https://pub.dev/packages/connectivity_watcher)
[![pub points](https://img.shields.io/pub/points/connectivity_watcher?color=2E8B57&label=pub%20points)](https://pub.dev/packages/connectivity_watcher/score)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)

**A lightning-fast Flutter plugin for true internet connectivity monitoring.** Most connectivity packages only check if the device's Wi-Fi or Mobile radio is "on." **ZoConnectivityWatcher** goes further by implementing a real-time **Heartbeat Strategy** (inspired by high-performance games like *Clash of Clans* and *PUBG*). It ensures your app knows when the internet is *actually* reachable, detecting "Liar Wi-Fi" (connected to a router but no data flow) in sub-second time.

| **Custom UI** | **SnackBar Style** | **Alert Dialog** |
|:-------------:|:------------------:|:----------------:|
| ![Custom](https://github.com/Oauth-Celestial/Connectivity_Watcher/assets/119127289/b72c6bcc-d782-4bbf-93fe-a7b63f8ea818) | ![SnackBar](https://github.com/Oauth-Celestial/Connectivity_Watcher/assets/119127289/af375c80-1942-4410-b7ff-cf167c131f7f) | ![Alert](https://github.com/Oauth-Celestial/Connectivity_Watcher/assets/119127289/7b50b018-d863-44e9-afb3-d627cdafd9a2) |

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
ZoConnectivityWatcher().setUp();
```

**Advanced: Custom Heartbeat & Timing**

If you want to use your own website as the source of truth (highly recommended to bypass DNS blocks), pass a StealthInternetChecker instance to the setUp method.

```dart
ZoConnectivityWatcher().setUp(
  internetChecker: StealthInternetChecker(
    heartbeatUrl: "https://your-website.com", 
    checkInterval: Duration(seconds: 10),    
    timeout: Duration(seconds: 5),           
  ),
);
```

## 🔌 Basic Usage

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

Use `ZoNetworkAwareWidget` to render UI based on real-time connectivity:

```dart
ZoNetworkAwareWidget(
  builder: (context, status) {
    return Container(
      height: 50,
      width: 250,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: MaterialButton(
        onPressed: () {},
        child: Text(
          status == ConnectivityWatcherStatus.connected ? 'Connected' : 'Disconnected',
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
      ),
    );
  },
);
```

---

## 🧪 Curl Logging for Dio

Log API requests as curl commands:

```dart
final dio = Dio();
dio.interceptors.add(CurlInterceptor());
```
<img width="382" height="850" alt="network" src="https://github.com/user-attachments/assets/f04e2307-c78d-4c53-94fa-013a2f451e85" />


---

## 🛠️ Feature Requests & Bugs

Have an idea or found a bug? Open an issue on [GitHub](https://github.com/Oauth-Celestial/Connectivity_Watcher/issues).

---

## 📦 More From Me

- [zo_micro_interactions](https://pub.dev/packages/zo_micro_interactions): A curated set of high-quality Flutter micro-interactions designed for modern, polished apps.
- [zo_animated_border](https://pub.dev/packages/zo_animated_border): Modern gradient border animations.
- [zo_screenshot](https://pub.dev/packages/zo_screenshot): Prevent screenshots and record secure areas.
- [theme_manager_plus](https://pub.dev/packages/theme_manager_plus): Manage Flutter themes with custom classes.
- [ultimate_extension](https://pub.dev/packages/ultimate_extension): Powerful utilities for Dart collections.
- [date_util_plus](https://pub.dev/packages/date_util_plus): Simplified date & time utilities.
- [pick_color](https://pub.dev/packages/pick_color): Extract colors from images by tapping.
