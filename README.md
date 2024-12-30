# connectivity_watcher

[![pub package](https://img.shields.io/pub/v/connectivity_watcher.svg)](https://pub.dev/packages/connectivity_watcher)
[![pub points](https://img.shields.io/pub/points/connectivity_watcher?color=2E8B57&label=pub%20points)](https://pub.dev/packages/connectivity_watcher/score)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)

**Connectivity Watcher** is a robust Flutter package designed to monitor internet connectivity and network availability status in real-time. This ensures that your app can effectively manage and respond to changes in connectivity, providing a seamless user experience.

## Getting started

First, add `connectivity_watcher` as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  connectivity_watcher: ^[version]
```

## Import the package

```dart
import 'package:connectivity_watcher/connectivity_watcher.dart';
```

## 🚀 What's New

### 1. Renamed Classes

- `ConnectivityWatcherWrapper` is now `ZoConnectivityWrapper`.
- `ConnectivityWatcher` is now `ZoConnectivityWatcher`.

### 2. New NoConnectivity Styles

- **`CUSTOMALERT`**: Add your custom alert dialogs, and the package handles showing and hiding them.
- **`NONE`**: Manage widgets based on internet connectivity at the widget level instead of globally.

### 3. Curl Interceptor for Dio

Log API requests as curl commands in the console:

```dart
Dio dio = Dio();
dio.interceptors.add(CurlInterceptor());
```

### 4. `ZoNetworkAware` Widget

Handle network-aware functionality in your app. Example:

```dart
ZoNetworkAware(
  builder: (context, status) {
    if (status == ConnectivityWatcherStatus.connected) {
      return Container(
        height: 50,
        width: 250,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: MaterialButton(
          onPressed: () async {},
          child: Text(
            'Login',
            style: TextStyle(color: Colors.black, fontSize: 25),
          ),
        ),
      );
    } else {
      return Container(
        height: 50,
        width: 250,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: MaterialButton(
          onPressed: () async {},
          child: Text(
            'Disconnected',
            style: TextStyle(color: Colors.black, fontSize: 25),
          ),
        ),
      );
    }
  },
);
```

### 5. API Call with Internet Status

Execute API tasks seamlessly by verifying internet connectivity beforehand:

```dart
ZoConnectivityWatcher().makeApiCall(
  apiCall: (internetStatus) async {
    if (internetStatus) {
      Dio dio = Dio();
      Response data = await dio.post(
        "https://jsonplaceholder.typicode.com/posts",
        data: {
          "title": 'foo',
          "body": 'bar',
          "userId": 1,
        },
      );
    }
  },
);
```

## Usage 🚀

### Custom No Internet Screen

Wrap your `MaterialApp` with `ConnectivityWatcherWrapper`, set `connectivityStyle` to `CUSTOM`, and provide a custom widget:

```dart
Widget build(BuildContext context) {
  return ConnectivityWatcherWrapper(
    navigationKey: navigatorKey,
    connectivityStyle: NoConnectivityStyle.CUSTOM,
    noInternetText: Text(
      "Testing message",
      style: TextStyle(color: Colors.red),
    ),
    offlineWidget: CustomNoInternetWrapper(
      builder: (context) {
        return CustomNoInternet();
      },
    ),
    builder: (context, connectionKey) {
      return MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Connectivity_Watcher',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginDemo(),
      );
    },
  );
}
```

**Note:** The package will automatically remove the custom widget when the internet is back. If not, use the following method:

```dart
bool hasRemoved = await ZoConnectivityWatcher().hideNoInternet();
if (hasRemoved) {
  // Your code after internet is back
} else {
  print("No Internet");
}
```

### Built-in Styles

#### SnackBar Style

```dart
Widget build(BuildContext context) {
  return ConnectivityWatcherWrapper(
    connectivityStyle: NoConnectivityStyle.SNACKBAR,
    builder: (context, connectionKey) {
      return MaterialApp(
        navigatorKey: connectionKey,
        debugShowCheckedModeBanner: false,
        title: 'Connectivity_Watcher',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginDemo(),
      );
    },
  );
}
```

#### Alert Style

```dart
Widget build(BuildContext context) {
  return ConnectivityWatcherWrapper(
    connectivityStyle: NoConnectivityStyle.ALERT,
    builder: (context, connectionKey) {
      return MaterialApp(
        navigatorKey: connectionKey,
        debugShowCheckedModeBanner: false,
        title: 'Connectivity_Watcher',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginDemo(),
      );
    },
  );
}
```

## Preview

### Custom

![custom](https://github.com/Oauth-Celestial/Connectivity_Watcher/assets/119127289/b72c6bcc-d782-4bbf-93fe-a7b63f8ea818)

### SnackBar

![snackbar](https://github.com/Oauth-Celestial/Connectivity_Watcher/assets/119127289/af375c80-1942-4410-b7ff-cf167c131f7f)

### Alert

![alert](https://github.com/Oauth-Celestial/Connectivity_Watcher/assets/119127289/7b50b018-d863-44e9-afb3-d627cdafd9a2)

## Check Internet Status

```dart
bool hasInternet = await ZoConnectivityWatcher().isInternetAvailable;
```

## Features and Bugs

Feel free to post feature requests or report bugs [here](https://github.com/Oauth-Celestial/Connectivity_Watcher/issues).
