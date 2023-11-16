

## connectivity_watcher 

## Description

Effortlessly adapt to changing network conditions with a single wrapper that seamlessly detects online/offline status. 🌐📲

## Getting started
First, add connectivity_watcher as a dependency in your pubspec.yaml file

```dart
connectivity_watcher: 1.0.1
```

## Usage

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


https://github.com/Oauth-Celestial/Connectivity_Watcher/assets/119127289/0d6fccce-d4d7-442c-907b-4798d482db5d



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
https://github.com/Oauth-Celestial/Connectivity_Watcher/assets/119127289/156684ef-14c8-45f0-9deb-a0e658184bab


What if i have to use a custom screen which my designer provided for no internet 😅!

### The Custom method 😎✌️ :

Wrap Your MaterialApp With ConnectionAwareApp and pass the connection style as custom and then pass your custom widget to offline widget as show thats it.

```dart
Widget build(BuildContext context) {
    return ConnectionAwareApp(
      connectivityStyle: NoConnectivityStyle.SNACKBAR,
      // connectivityStyle: NoConnectivityStyle.CUSTOM,
      offlineWidget: CustomNoInternetWrapper(
        builder: (context) {
          return CustomNoInternet();
        },
      ),
      // Place your custom no internet Widget
      builder: (context, connectionKey) {
        return MaterialApp(
            navigatorKey: connectionKey,
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

https://github.com/Oauth-Celestial/Connectivity_Watcher/assets/119127289/d784b345-f46b-4751-8779-f6f152637987











Feel free to post a feature requests or report a bug [here](https://github.com/Oauth-Celestial/Connectivity_Watcher/issues).
