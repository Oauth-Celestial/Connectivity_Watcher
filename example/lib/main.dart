import 'package:example/NoInternet.dart';
import 'package:flutter/material.dart';
import 'package:network_check/NetworkService/NetworkCheck.dart';
import 'package:network_check/NetworkService/NoInternet.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: NetworkCheck.contextKey,
        title: 'Flutter Demo',
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
    NetworkCheck.shared.setup(widgetForNoInternet: CustomNoInternet());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
    );
  }
}
