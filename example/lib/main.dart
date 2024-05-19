import 'dart:async';
import 'package:connectivity_watcher/connectivity_watcher.dart';
import 'package:connectivity_watcher/screens/custom_no_internet.dart';
import 'package:example/no_internet.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ConnectivityWatcherWrapper(
      /// connectivityStyle: NoConnectivityStyle.CUSTOM,
      navigationKey: navigatorKey,
      connectivityStyle: NoConnectivityStyle.CUSTOM,
      noInternetText: Text(
        "Testing message",
        style: TextStyle(color: Colors.red),
      ),

      offlineWidget: CustomNoInternetWrapper(
        builder: (context) {
          return CustomNoInternet();
        },
      ),
      // Place your custom no internet Widget
      builder: (context, connectionKey) {
        return MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Connectivity_Watcher',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: LoginDemo());
      },
    );
  }
}

class LoginDemo extends StatefulWidget {
  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {
  late StreamSubscription<ConnectivityWatcherStatus> subscription;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ConnectivityWatcher().subscribeToConnectivityChange(
        subscriptionCallback: ((stream) {
      subscription = stream.listen((event) {
        print(
            "Internet Status on screen one  ${event == ConnectivityWatcherStatus.connected}");
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 200,
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email id as abc@gmail.com'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            MaterialButton(
              onPressed: () async {
                bool internetStatus =
                    await ConnectivityWatcher().getConnectivityStatus();
                print(internetStatus);
              },
              child: Text(
                'Forgot Password',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: MaterialButton(
                onPressed: () async {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => LoginDemoTwo()));
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
            Text('New User? Create Account')
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    subscription.cancel();
    super.dispose();
  }
}

class LoginDemoTwo extends StatefulWidget {
  @override
  _LoginDemoTwoState createState() => _LoginDemoTwoState();
}

class _LoginDemoTwoState extends State<LoginDemoTwo> {
  late StreamSubscription<ConnectivityWatcherStatus> subscription;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ConnectivityWatcher().subscribeToConnectivityChange(
        subscriptionCallback: ((stream) {
      subscription = stream.listen((event) {
        print(
            "Internet Status on screen two  ${event == ConnectivityWatcherStatus.connected}");
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 200,
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email id as abc@gmail.com'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            MaterialButton(
              onPressed: () async {
                bool internetStatus =
                    await ConnectivityWatcher().getConnectivityStatus();
                print(internetStatus);
              },
              child: Text(
                'Forgot Password',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: MaterialButton(
                onPressed: () async {
                  bool hasInternet =
                      await ConnectivityWatcher().getConnectivityStatus();
                  print(hasInternet);
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
            Text('New User? Create Account')
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    subscription.cancel();
    super.dispose();
  }
}
