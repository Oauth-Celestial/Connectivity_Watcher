# connectivity_watcher

[![pub package](https://img.shields.io/pub/v/connectivity_watcher.svg)](https://pub.dev/packages/connectivity_watcher)
[![pub points](https://img.shields.io/pub/points/connectivity_watcher?color=2E8B57&label=pub%20points)](https://pub.dev/packages/connectivity_watcher/score)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)

A Flutter package for lightning-fast internet connectivity checks—with subsecond response times, even on mobile networks! Includes support for custom UI, so you can seamlessly show connection status your way.

Ask ChatGPT

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

### 3. API Call with Internet Status

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

### 4. API Call with Retry Mechanism

Execute API tasks with a retry mechanism that checks internet connectivity and calls the API again if the internet is available:

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

    // You can use the response if needed
    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');
  },
);

```

### 5. Curl Interceptor for Dio

Log API requests as curl commands in the console:

```dart
Dio dio = Dio();
dio.interceptors.add(CurlInterceptor());
```

### 6. `ZoNetworkAwareWidget`

Handle network-aware functionality in your app. Example:

```dart
ZoNetworkAwareWidget(
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
            'Connected',
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

## Check Internet Status

```dart
bool hasInternet = await ZoConnectivityWatcher().isInternetAvailable;
```

## Usage 🚀

### Custom No Internet Screen

Wrap your `MaterialApp` with `ConnectivityWatcherWrapper`, set `connectivityStyle` to `CUSTOM`, and provide a custom widget:

```dart
Widget build(BuildContext context) {
  return ZoConnectivityWrapper(
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
  return ZoConnectivityWrapper(
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
  return ZoConnectivityWrapper(
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

## Features and Bugs

Feel free to post feature requests or report bugs [here](https://github.com/Oauth-Celestial/Connectivity_Watcher/issues).

# My Other packages

- [zo_animated_border](https://pub.dev/packages/zo_animated_border): A package that provides a modern way to create gradient borders with animation in Flutter

- [zo_screenshot](https://pub.dev/packages/zo_screenshot): The zo_screenshot plugin helps restrict screenshots and screen recording in Flutter apps, enhancing security and privacy by preventing unauthorized screen captures.

- [theme_manager_plus](https://pub.dev/packages/theme_manager_plus): Allows customization of your app's theme with your own theme class, eliminating the need for traditional

- [ultimate_extension](https://pub.dev/packages/ultimate_extension): Enhances Dart collections and objects with utilities for advanced data manipulation and simpler coding.

- [date_util_plus](https://pub.dev/packages/date_util_plus): A powerful Dart API designed to augment and simplify date and time handling in your Dart projects.
- [pick_color](https://pub.dev/packages/pick_color): A Flutter package that allows you to extract colors and hex codes from images with a simple touch.
