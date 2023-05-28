

## Connectivity_Watcher

This plugin allows Flutter apps to discover network connectivity changes throught the app with your own custom no internet widget.


## Features

1. Get Reactive Network state throught the app

2. Want to add your own custom widget for no internet no issue now.



## Getting started
First, add connectivity_watcher as a dependency in your pubspec.yaml file
```dart
connectivity_watcher: 0.0.1
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

```
  void initState() {
    // TODO: implement initState
    ConnectivityWatcher.shared.setup(widgetForNoInternet: #your custom no internet widget);
    super.initState();
  }
```

# Things to Add in Your Custom Widget 

In Your custom widget you can add isConnectedtoNetwork() to the button click to check if your client network is back and it will remove the widget if network is back



For more reference please follow the example folder in the repo


## Feature requests and Bug reports

Feel free to post a feature requests or report a bug [here](https://github.com/Oauth-Celestial/Connectivity_Watcher/issues).
