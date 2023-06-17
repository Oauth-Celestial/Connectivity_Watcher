import 'package:connectivity_watcher/NetworkService/Connectivity_Watcher.dart';
import 'package:connectivity_watcher/NetworkService/Model/ConnectivityWidgetModel.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DefaultNoInternetWidget extends StatelessWidget {
  NoInternetWidget? userWidget;

  DefaultNoInternetWidget({this.userWidget});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: userWidget?.backgroundColor ?? Colors.white,
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Container(
              height: MediaQuery.of(context).size.height * 0.4,
              alignment: Alignment.center,
              child: Container(
                child: userWidget?.displayImage ??
                    Icon(
                      Icons.wifi_off_sharp,
                      size: 60,
                    ),
              )),
          Text(
            "No Internet connection.",
            style: userWidget?.titleStyle ??
                TextStyle(
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.center,
              child: Text(
                "Please check your internet connection and try again.",
                textAlign: TextAlign.center,
                style: userWidget?.descriptionStyle ??
                    TextStyle(
                      color: Colors.black.withOpacity(0.6),
                      fontSize: 18,
                    ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Expanded(
            child: Container(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: InkWell(
                  onTap: () {
                    ConnectivityWatcher.shared.shouldRemoveNoInternet();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 180,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(30)),
                    height: 50,
                    child: Text(
                      "Try Again",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
