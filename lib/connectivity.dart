import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cybersquare/core/constants/user_details.dart';
import 'package:flutter/material.dart';

class ConnectivityManager {
  final VoidCallback onConnected;
  final VoidCallback onDisconnected;
  List<ConnectivityResult>? _previousResult;

  ConnectivityManager({
    required this.onDisconnected,
    required this.onConnected,
  }) {
    checkConnectivity();
  }

  Future<void> checkConnectivity() async {
    var connectivityStream = Connectivity().onConnectivityChanged;
    connectivityStream.listen((result) async {
      log(result.toString());

      // Only trigger the callback if there's a change in connection state
      if (_previousResult != result) {
        if (result.contains(ConnectivityResult.none)) {
          constIsConnectedToInternet = false;
          onDisconnected();
        } else {
          constIsConnectedToInternet = true;
          onConnected();
        }
      }

      // Update the previous result
      _previousResult = result;
    });
  }
}
