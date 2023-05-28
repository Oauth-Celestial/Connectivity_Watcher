
## Example

```dart
import 'package:connectivity_watcher/NetworkService/Connectivity_Watcher.dart';
import 'package:connectivity_watcher/NetworkService/Model/ConnectivityWidgetModel.dart';
import 'package:example/NoInternet.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: ConnectivityWatcher.contextKey,
        debugShowCheckedModeBanner: false,
        title: 'Connectivity_Watcher',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: RedScreen());
  }
}

class RedScreen extends StatefulWidget {
  const RedScreen({super.key});

  @override
  State<RedScreen> createState() => _RedScreenState();
}

class _RedScreenState extends State<RedScreen> {
  @override
  void initState() {
    // TODO: implement initState
    ConnectivityWatcher.shared.setup(
        widgetForNoInternet: NoInternetWidget(widget: CustomNoInternet()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
    );
  }
}
```