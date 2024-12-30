import 'package:connectivity_watcher/connectivity_watcher.dart';

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
    return ZoConnectivityWrapper(
      /// connectivityStyle: NoConnectivityStyle.CUSTOM,
      navigationKey: navigatorKey,
      connectivityStyle: NoConnectivityStyle.ALERT,
      customAlert: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: Row(
          children: [
            Icon(
              Icons.wifi_off,
              color: Colors.redAccent,
            ),
            SizedBox(width: 8.0),
            Text(
              'No Internet Connection',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          'It looks like you are not connected to the internet. Please check your connection and try again.',
          style: TextStyle(fontSize: 16.0),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('CANCEL', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text('RETRY'),
          ),
        ],
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
              onPressed: () async {},
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
                  // ZoConnectivityWatcher().makeApiCall(apiCall: (status) async {
                  //   if (status) {
                  //     Dio dio = Dio();

                  //     dio.interceptors.add(CurlInterceptor());

                  //     Response data = await dio.post(
                  //         "https://jsonplaceholder.typicode.com/posts",
                  //         data: {
                  //           "title": 'foo',
                  //           "body": 'bar',
                  //           "userId": 1,
                  //         });
                  //   }
                  // });
                  print(ZoConnectivityWatcher().isInternetAvailable);
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
            Text('New User? Create Account'),
            ZoNetworkAware(
              builder: (context, status) {
                if (status == ConnectivityWatcherStatus.connected) {
                  return Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                    child: MaterialButton(
                      onPressed: () async {},
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.black, fontSize: 25),
                      ),
                    ),
                  );
                } else {
                  return Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                    child: MaterialButton(
                      onPressed: () async {},
                      child: Text(
                        'Disconnected',
                        style: TextStyle(color: Colors.black, fontSize: 25),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }
}
