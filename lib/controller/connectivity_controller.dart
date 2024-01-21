import 'dart:io';
import 'package:connectivity_watcher/utils/enums/enum_connection.dart';
import 'package:connectivity_watcher/widgets/custom_no_internet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';


class ConnectivityWatcher{

ConnectivityWatcher._();

static ConnectivityWatcher get instance => ConnectivityWatcher._();

Future<bool> hideNoInternet({ required BuildContext currentContext} ) async{
 return await currentContext.read<ConnectivityController>().hideNoInternetScreen();
}

Future<bool> getConnectivityStatus({  required  BuildContext currentContext}){
return currentContext.read<ConnectivityController>().getConnectivityStatus();
}
}



class ConnectivityController with ChangeNotifier {
  ConnectivityWatcherStatus? internetStatus;
  final GlobalKey<NavigatorState> contextKey = GlobalKey<NavigatorState>();




  OverlayEntry? _entry;

  /// list of overlay entries to all the reference of overlays drawn
  List<OverlayEntry> _entries = [];
  List<BuildContext> _overlayContext = [];

  /// Overlay state
  OverlayState? _overlayState;

  /// Custom No Internet widget provided by the user
  CustomNoInternetWrapper? _userWidget;
  NoConnectivityStyle? _connectivityStyle;

  

  Widget? customNoInternetText;
  bool isAlertActive = false;
  BuildContext? currentContext;
  InternetConnectionChecker checker = InternetConnectionChecker.createInstance(
      checkInterval: Duration(seconds: 2), checkTimeout: Duration(seconds: 2));
  setupConnectivityListner(
      {CustomNoInternetWrapper? offlineWidget,
      NoConnectivityStyle? connectivityStyle =
          NoConnectivityStyle.SNACKBAR, Widget? noInternetText }) async {
    _userWidget = offlineWidget;
    _connectivityStyle = connectivityStyle;
customNoInternetText = noInternetText;
    if (_connectivityStyle == NoConnectivityStyle.CUSTOM &&
        _userWidget == null) {
      throw ("widgetForNoInternet is missing");
    }

    checker.onStatusChange.listen((status) {
      _overlayState = (contextKey.currentState!.overlay);
      switch (status) {
        /// ConnectedState
        case InternetConnectionStatus.connected:
          try {
            _removeNoInternet();
          } catch (e) {}
          print('You are Connected to the internet.');
          break;

        /// DisconnectedState
        case InternetConnectionStatus.disconnected:
          showNoInternet();
          print('You are disconnected from the internet.');
          break;
      }
    });
  }


Future<bool> hideNoInternetScreen() async{
return await  _removeNoInternet();
  }

  isInternetBack({required Function(bool) internetStatus}) async {
    bool isConnected = await InternetConnectionChecker().hasConnection;

    if (isConnected) {
      _removeNoInternet();
      internetStatus(true);
    } else {
      return internetStatus(false);
    }
  }

  void showSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            Icons.wifi_off_sharp,
            color: Colors.white,
          ),
          SizedBox(
            width: 20,
          ),
          if(customNoInternetText == null)...[
               Text('No Internet'),
          ]
          else...[
            customNoInternetText ??  Text('No Internet'),
          ]
        ],
      ),
      backgroundColor: Colors.black,
      behavior: SnackBarBehavior.fixed,
      dismissDirection: DismissDirection.none,
      duration: Duration(days: 1),
      action: SnackBarAction(
        label: 'Try Again',
        disabledTextColor: Colors.white,
        textColor: Colors.white,
        onPressed: () {
          isInternetBack(internetStatus: (value) {
            if (value) {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
            } else {
              showSnackBar(context);
            }
          });
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showNoInternetBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off_rounded),
              Text(
                "Whoops",
                style: TextStyle(color: Colors.black),
              ),
              Text("Seems Like you have Lost your Connection",
                  style: TextStyle(color: Colors.grey))
            ],
          ),
        );
      },
    );
  }

  /// Removes the No internet widget from the tree and clears overlay entry
 Future<bool> _removeNoInternet() async {

    bool isNetworkBack = await getConnectivityStatus();

    if(!isNetworkBack){
      return false ;
    }
    currentContext = contextKey.currentContext;
    if(_connectivityStyle == NoConnectivityStyle.CUSTOM && _overlayContext.isNotEmpty){
     
 currentContext = _overlayContext.last;
      
     
    }
    if(currentContext != null){
    if (_connectivityStyle == NoConnectivityStyle.SNACKBAR) {
      try {
        ScaffoldMessenger.of(currentContext!).removeCurrentSnackBar();
        return true;
      } catch (e) {
        print("error");
        return false;
        
      }
    } else if (_connectivityStyle == NoConnectivityStyle.ALERT &&
        isAlertActive) {
      Navigator.pop(currentContext!);
        return true;
    } else {
      _entries.forEach((entry) => entry.remove());
      _entries.clear();
      _overlayContext.clear();
        return true;
    }
    }
    else{
      return false;
    }
  }

  /// Responsible for getting the current context from the tree and draw the  custom widget
  showNoInternet() {

    currentContext = contextKey.currentContext;
    if(currentContext != null){
    if (_connectivityStyle == NoConnectivityStyle.SNACKBAR) {
      showSnackBar(currentContext!);
    } else if (_connectivityStyle == NoConnectivityStyle.ALERT) {
      showPlatformAlert();
    } else {
      _entry = OverlayEntry(builder: (context) {
        _overlayContext.add(context);
        return _userWidget ??
            Container(
              color: Colors.amber,
              child: Text("No Internet"),
            );
      });
      _entries.add(_entry!);
      _overlayState?.insert(_entry!);
    }
    }
  }

  /// Get status of conncetion
  Future<bool> getConnectivityStatus() async {
    bool isconnected = await InternetConnectionChecker().hasConnection;
    return isconnected;
  }

  showPlatformAlert() {
  currentContext = contextKey.currentContext;
    if(currentContext != null){

    if (Platform.isIOS) {
      showCupertinoDialog(currentContext!);
    } else if (Platform.isAndroid) {
      showMaterialDialog(currentContext!);
    }
    }
  }

  void showCupertinoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        isAlertActive = true;
        return CupertinoAlertDialog(
          title: Text('No Internet Connection'),
          content: customNoInternetText ?? Text('Please check your internet connection and try again.'),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                isInternetBack(internetStatus: (status) {
                  if (status) {
                    isAlertActive = false;
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);

                    Future.delayed(Duration(seconds: 1), () {
                      showPlatformAlert();
                    });
                  }
                });
              },
              child: Text('Try Again'),
            ),
          ],
        );
      },
    );
  }

  void showMaterialDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        isAlertActive = true;
        return AlertDialog(
          title: Text('No Internet Connection'),
          content: customNoInternetText ?? Text('Please check your internet connection and try again.'),
          actions: [
            TextButton(
              onPressed: () {
                isInternetBack(internetStatus: (status) {
                  if (status) {
                    isAlertActive = false;
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);

                    Future.delayed(Duration(seconds: 1), () {
                      showPlatformAlert();
                    });
                  }
                });
              },
              child: Text('Try Again'),
            ),
          ],
        );
      },
    );
  }
}


// To Do 

// Image.asset("packages/connectivity_watcher/assets/a.jpg"),