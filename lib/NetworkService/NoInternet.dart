import 'package:connectivity_watcher/NetworkService/Connectivity_Watcher.dart';
import 'package:flutter/material.dart';

class NoInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Container(
            width: 250,
            height: 180,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Icon(
                  Icons.signal_wifi_bad_rounded,
                  size: 40,
                  color: Colors.amber,
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      "No Internet",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    ConnectivityWatcher.shared.isConnectedtoNetwork();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      "Try Again",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
