

## Connectivity_Watcher 📡

The Connectivity_Watcher package for Flutter enables your app to detect and respond to network connectivity changes seamlessly. It empowers you to create a custom "no internet" widget, allowing for a personalized user experience when the device is offline. 🌐📡✨


## Features

1. With the Connectivity_Watcher plugin, you can effortlessly obtain reactive network state throughout your app. Stay updated on network changes and adapt your app's behavior accordingly, ensuring a smooth user experience even when connectivity fluctuates. 🌐📲💡

2. No internet connection? No problem! The Connectivity_Watcher plugin allows you to seamlessly incorporate your own custom widget to handle the "no internet" scenario. Design a unique and attention-grabbing widget that keeps your users engaged and informed, even when they're offline. ✨🚫🌐

3. Auto-Removal of Widget: Once the network connection is detected, automatically .


## Getting started
First, add connectivity_watcher as a dependency in your pubspec.yaml file
```dart
connectivity_watcher: 0.0.2
```

## Usage

Step 1

Add ConnectivityWatcher.contextKey as navigatorKey in your material app
```dart
MaterialApp(
        navigatorKey: ConnectivityWatcher.contextKey,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: RedScreen());
```

Step 2 

Add ConnectivityWatcher.shared.setup in init state of the widget 

Note :
Add setup code in the widget after the material app initialization as the key is not available at same level 

# For Default Widget
```
  void initState() {
    // TODO: implement initState
    ConnectivityWatcher.shared.setup();
    super.initState();
  }
```


# For Custom No Internet  Widget
```
  void initState() {
    // TODO: implement initState
    ConnectivityWatcher.shared.setup(
        widgetForNoInternet: NoInternetWidget(widget: CustomNoInternet()));
    super.initState();
  }
```





# Things to Add in Your Custom Widget 

In your custom widget, you can enhance its functionality by adding the following:

1. Check Network Connectivity: Implement the `isConnectedToNetwork()` function and bind it to a button click. This function will verify if the client's network connection is restored.



By incorporating these features, your custom widget will allow users to check for network connectivity and automatically disappear when the network connection is restored.


For more reference please follow the example folder in the repo


## Feature requests and Bug reports

Feel free to post a feature requests or report a bug [here](https://github.com/Oauth-Celestial/Connectivity_Watcher/issues).
