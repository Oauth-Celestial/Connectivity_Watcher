## Release

## 3.0.1

### ⚠️ BREAKING CHANGE

This is a major release which contains breaking API changes.

 1. `ConnectivityWatcherWrapper` is now `ZoConnectivityWrapper`

 2. `ConnectivityWatcher` is now `ZoConnectivityWatcher`

Added new styles for noconnectivity and updated code for latest flutter

### 🐛 Bug Fixes

* Resolved black screen issue with alert style

* Minor bug fixes and improvements

## 2.0.1

### 🚀 What's New

1. **Curl Inteceptor for dio**

    Now you can get curl for your api request inside your console with dio

2. **Api call with internet status**

### 🐛 Bug Fixes

* Resolved overlay removal when network status changes

## 2.0.0

### ⚠️ BREAKING CHANGE

This is a major release which contains breaking API changes.

#### ⚠️ ConnectionAwareApp is now ConnectivityWatcherWrapper

* `navigatorKey` optional parameter added for navigatorkey which allow you to add your own navigation key.

* `subscribeToConnectivityChange` exposed a connectivity listener to listen for connectivity changes anywhere in the app and peform user operation with callback special thanks to @avnp16 for the request.

### 🐛 Bug Fixes

* Resolved context null issue on internet change status in custom style

* Minor bug fixes and improvements

# 1.0.3  

* Updated dependency and enhancement

# 1.0.2  

* Fixed Overlay issue for custom style.

# 1.0.1  

* Improved functionality and Refactored Code with addition features

# 1.0.0  

* Added ConnetivityAppWrapper and improved functionality

# 0.0.2  

* Added Default No Internet widget and minor fixes

# 0.0.1  

* initial release.
