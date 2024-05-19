[![pub package](https://img.shields.io/pub/v/connectivity_watcher.svg)](https://pub.dev/packages/connectivity_watcher)
[![pub points](https://img.shields.io/pub/points/connectivity_watcher?color=2E8B57&label=pub%20points)](https://pub.dev/packages/connectivity_watcher/score)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)


# connectivity_watcher 


### Table of contents

- [🌐📲 Connectivity Watcher](#connectivity_watcher)
  - [Description](#description)
  - [Getting started](#getting-started)
  - [Usage 🚀](#usage-🚀)
    - [The Custom method 😎✌️](#the-custom-method-😎✌️)
    - [The lazy method: 😴💤](the-lazy-method:😴💤)
  - [Features and bugs](#features-and-bugs)


# Description
Connectivity Watcher is a robust Flutter package designed to monitor internet connectivity and network availability status in real-time. This plugin ensures that your app can effectively manage and respond to changes in connectivity, providing a seamless user experience.


## Getting started
First, add connectivity_watcher as a dependency in your pubspec.yaml file

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

## Usage 🚀

What if i have to use a custom screen which my designer provided for no internet 😅!

### The Custom method 😎✌️ :

Wrap Your MaterialApp With ConnectionAwareApp and pass the connection style as custom and then pass your custom widget to offline widget as show thats it.

```dart
Widget build(BuildContext context) {
    return ConnectivityWatcherWrapper(
      navigationKey: navigatorKey,
      connectivityStyle: NoConnectivityStyle.CUSTOM,
      noInternetText: Text(
        "Testing message", // Any Message 
        style: TextStyle(color: Colors.red),
      ),

      offlineWidget: CustomNoInternetWrapper(
        builder: (context) {
          return CustomNoInternet();
        },
      ),
      // Place your custom no internet Widget
      builder: (context, connectionKey) {
        return MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Connectivity_Watcher',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: LoginDemo());
      },
    );
  }
```

**Note:** The package will automatically remove the custom widget if internet is back but in case its not removed you can use the follwing method to remove it 
```
bool hasRemoved = await   ConnectivityWatcher.().hideNoInternet();
if(hasRemoved){
 // your code after internet is back
    }
    else{
       print("No Internet");
    }
```

# Preview

![custom](https://github.com/Oauth-Celestial/Connectivity_Watcher/assets/119127289/b72c6bcc-d782-4bbf-93fe-a7b63f8ea818)


### The lazy method: 😴💤

Wrap Your MaterialApp With ConnectionAwareApp and pass the connection style

1. SnackBar Style

``` dart
  Widget build(BuildContext context) {
    return ConnectionAwareApp(
      connectivityStyle: NoConnectivityStyle.SNACKBAR,
      builder: (context, connectionKey) {
        return MaterialApp(
            navigatorKey: connectionKey, // add this key to material app 
            debugShowCheckedModeBanner: false,
            title: 'Connectivity_Watcher',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: LoginDemo());
      },
    );
  }
```

# Preview

![snackbar](https://github.com/Oauth-Celestial/Connectivity_Watcher/assets/119127289/af375c80-1942-4410-b7ff-cf167c131f7f)

2. Alert 

``` dart
  Widget build(BuildContext context) {
    return ConnectionAwareApp(
     connectivityStyle: NoConnectivityStyle.ALERT,
      builder: (context, connectionKey) {
        return MaterialApp(
            navigatorKey: connectionKey, // add this key to material app 
            debugShowCheckedModeBanner: false,
            title: 'Connectivity_Watcher',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: LoginDemo());
      },
    );
  }
```
# Preview

![alert](https://github.com/Oauth-Celestial/Connectivity_Watcher/assets/119127289/7b50b018-d863-44e9-afb3-d627cdafd9a2)


## Check Internet Status

```
bool hasInternet = await ConnectivityWatcher.instance.getConnectivityStatus(currentContext: context);
```

## Contribution 🤝

Feel free to contribute and open pull requests. 🙌


## Features and bugs

Feel free to post a feature requests or report a bug [here](https://github.com/Oauth-Celestial/Connectivity_Watcher/issues).
