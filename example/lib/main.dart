import 'package:connectivity_watcher/controller/connectivity_controller.dart';
import 'package:connectivity_watcher/network_check.dart';
import 'package:connectivity_watcher/widgets/custom_no_internet.dart';
import 'package:example/no_internet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ConnectionAwareApp(
      connectivityStyle: NoConnectivityStyle.CUSTOM,
      noInternetWidget: CustomNoInternetWrapper(
        builder: (context) {
          return Container(
            color: Colors.green,
            alignment: Alignment.center,
            child: InkWell(
                onTap: () {
                  context.read<ConnectivityController>().isInternetBack(
                      internetStatus: (status) {
                    print(status);
                  });
                },
                child: Text("No Internert")),
          );
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
            home: TestScreen());
      },
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
          child: InkWell(
            onTap: () {
              context.read<ConnectivityController>().isInternetBack(
                  internetStatus: (status) {
                print(status);
              });
            },
            child: Container(
                width: 200, height: 140, child: Text("Test Functiion")),
          ),
        ),
      ),
    );
  }
}
