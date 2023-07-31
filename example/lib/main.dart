import 'package:connectivity_watcher/network_check.dart';
import 'package:example/no_internet.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 
  @override
  Widget build(BuildContext context) {
    return ConnectivityWatcherAppWrapper(
      noInternetWidget: CustomNoInternet(), // Place your custom no internet Widget
      app: MaterialApp(
          navigatorKey: ConnectivityWatcher.contextKey,
          debugShowCheckedModeBanner: false,
          title: 'Connectivity_Watcher',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: TestScreen()),
    );
  }
}

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: SafeArea(
        child: Container(
            alignment: Alignment.center,
            ),
      ),
    );
  }
}
