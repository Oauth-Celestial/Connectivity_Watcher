[![pub package](https://img.shields.io/pub/v/connectivity_watcher.svg)](https://pub.dev/packages/connectivity_watcher)
[![pub points](https://img.shields.io/pub/points/connectivity_watcher?color=2E8B57&label=pub%20points)](https://pub.dev/packages/connectivity_watcher/score)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)


# connectivity_watcher 


### Table of contents

- [🌐📲 Connectivity Watcher](#connectivity_watcher)
  - [Description](#description)
  - [Getting started](#getting-started)
  - [Usage 🚀](#usage-🚀)
    - [Run Apis on internet status changes](#run-apis-on-internet-status-changes )
    - [The Custom method](#the-custom-method)
    - [The Inbuild Styles ](#the-inbuild-styles )
  - [Honoring Recent Contributors](#honoring-recent-contributors)
  - [Features and bugs](#features-and-bugs)

Honoring Recent Contributors
# Description
Connectivity Watcher is a robust Flutter package designed to monitor internet connectivity and network availability status in real-time. This ensures that your app can effectively manage and respond to changes in connectivity, providing a seamless user experience.


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

## Run Apis on internet status changes 

If your are in situation where you have to perform certain operation based on the internet status changes you can use **ConnectivityWatcher().subscribeToConnectivityChange()**

```dart
// create a variable to store steam subscription
late StreamSubscription<ConnectivityWatcherStatus> subscription;

// Just like any other stream you can use the listen method and initialize stream in init state 
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    ConnectivityWatcher().subscribeToConnectivityChange(
        subscriptionCallback: ((stream) {
      subscription = stream.listen((event) {
        if (event == ConnectivityWatcherStatus.connected) {
          // Internet is Connected
        } else {
          // Internet is disconnected
        }
      });
    }));
  }
```

### The Custom method

Wrap Your MaterialApp With ConnectivityWatcherWrapper and pass the connection style as custom and then pass your custom widget to offline widget as show thats it.

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


### The Inbuild Styles 

Wrap Your MaterialApp With ConnectivityWatcherWrapper and pass the connection style

1. SnackBar Style

``` dart
  Widget build(BuildContext context) {
    return ConnectivityWatcherWrapper(
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
    return ConnectivityWatcherWrapper(
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
bool hasInternet = await ConnectivityWatcher().getConnectivityStatus();
```

## Contribution 🤝

Feel free to contribute and open pull requests. 🙌


## Honoring Recent Contributors

[<img src="https://github.com/avnp16.png" width="60px;"/><br /></a></sub>](https://github.com/avnp16)

The section honors the people who has either contributed to the repo or have opened a  feature or bug request 

## Features and bugs

Feel free to post a feature requests or report a bug [here](https://github.com/Oauth-Celestial/Connectivity_Watcher/issues).
