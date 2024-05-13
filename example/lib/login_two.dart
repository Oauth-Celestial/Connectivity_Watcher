import 'dart:async';

import 'package:connectivity_watcher/controller/connectivity_controller.dart';
import 'package:connectivity_watcher/utils/enums/enum_connection.dart';
import 'package:flutter/material.dart';

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
    subscription = ConnectivityWatcher()
        .subscribeToConnectivityChange(
      currentContext: context,
    )
        .listen((event) {
      print("Conncetivity status in second screen ${event}");
    });
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
                bool internetStatus = await ConnectivityWatcher()
                    .getConnectivityStatus(currentContext: context);
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
                  bool hasInternet = await ConnectivityWatcher()
                      .getConnectivityStatus(currentContext: context);
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
