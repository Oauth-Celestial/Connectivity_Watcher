

## connectivity_watcher 

## Description

Effortlessly adapt to changing network conditions with a single wrapper that seamlessly detects online/offline status. 🌐📲

## Getting started
First, add connectivity_watcher as a dependency in your pubspec.yaml file

```dart
connectivity_watcher: 1.0.1
```

## Usage 🚀

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

![custom](https://github.com/Oauth-Celestial/Connectivity_Watcher/assets/119127289/b72c6bcc-d782-4bbf-93fe-a7b63f8ea818)



## Check Internet Status

```
 context.read<ConnectivityController>().isInternetBack(internetStatus: (status){
// Your Code 
 });
```




## Contribution 🤝

Feel free to contribute and open pull requests. 🙌


## Issues and Feedback 🐛

Feel free to post a feature requests or report a bug [here](https://github.com/Oauth-Celestial/Connectivity_Watcher/issues).
