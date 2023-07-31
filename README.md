

## Connectivity_Watcher 📡

In Modern apps we come across situation where we are given a nointernet screen which will be visible when ever user losses the connectivity. As maintaining internet state throught the app is not an easy task we have to write lot of boiler plate to achieve this kind of functionality. But no more 


Introducing Connectivity_Watcher 

The Simple Package can help you achieve all of this with single wrapper widget Just Follow the steps 


## Getting started
First, add connectivity_watcher as a dependency in your pubspec.yaml file
```dart
connectivity_watcher: 1.0.0
```

## Steps



Wrap Your Material App with ConnectivityWatcherAppWrapper 

Note: Provide navigatorKey as ConnectivityWatcher.contextKey in material app to make it work as the key is required by ConnectivityWatcherAppWrapper.

```dart
ConnectivityWatcherAppWrapper(
       noInternetWidget: CustomNoInternet() // Place your custom no internet Widget
      app: MaterialApp(
          navigatorKey: ConnectivityWatcher.contextKey,
          debugShowCheckedModeBanner: false,
          title: 'Connectivity_Watcher',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: TestScreen()),
    );
```
Whats the CustomNoInternet ?

This is the widget that you want to show when user losses the internet connection.


For more reference please follow the example folder in the repo


## Features In Queue

* ShimmerOrWidget Based on connectivity or request state

* RequestRetry Interceptors

## Feature requests and Bug reports

Feel free to post a feature requests or report a bug [here](https://github.com/Oauth-Celestial/Connectivity_Watcher/issues).
