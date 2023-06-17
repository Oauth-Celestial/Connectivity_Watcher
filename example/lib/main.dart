import 'package:connectivity_watcher/NetworkService/ConnectivityWidget/connectivity_watcher_app.dart';
import 'package:connectivity_watcher/NetworkService/ConnectivityWidget/connectivity_widget.dart';
import 'package:connectivity_watcher/NetworkService/Connectivity_Watcher.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_watcher/NetworkService/connectivity_enum.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ConnectivityWatcherAppWrapper(
      app: MaterialApp(
          navigatorKey: ConnectivityWatcher.contextKey,
          debugShowCheckedModeBanner: false,
          title: 'Connectivity_Watcher',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: RedScreen()),
    );
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
    // ConnectivityWatcher.shared.setup(
    //     widgetForNoInternet: NoInternetWidget(widget: CustomNoInternet()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: ConnectivityWidget(builder: (context, status) {
        print(status);
        if (status == ConnectivityWatcherStatus.connected) {
          return InkWell(
            onTap: () async {
              bool status =
                  await ConnectivityWatcher.shared.getConnectivityStatus();
              print(status);
            },
            child: Container(
              alignment: Alignment.center,
              child: Text("You are Connected"),
            ),
          );
        } else {
          return InkWell(
            onTap: () async {
              bool status =
                  await ConnectivityWatcher.shared.getConnectivityStatus();
              print(status);
            },
            child: Container(
              alignment: Alignment.center,
              child: Text("DisConnected"),
            ),
          );
        }
      }),
    );
  }
}
