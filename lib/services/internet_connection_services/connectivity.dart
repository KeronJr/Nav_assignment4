// import 'dart:async';
// import 'dart:io';

// import 'package:connectivity_plus/connectivity_plus.dart';

// class NetworkConnectivity {
//   NetworkConnectivity._();
//   static final _instance = NetworkConnectivity._();
//   static NetworkConnectivity get instance => _instance;
//   final _networkConnectivity = Connectivity();
//   late StreamSubscription<ConnectivityResult> _connectivitySubscription;
//   final _controller =
//       StreamController<Map<ConnectivityResult, bool>>.broadcast();
//   Stream<Map<ConnectivityResult, bool>> get myStream => _controller.stream;
//   // 1.
//   void initialise() async {
//     ConnectivityResult result = await _networkConnectivity.checkConnectivity();
//     _checkStatus(result);
//     _connectivitySubscription =
//         _networkConnectivity.onConnectivityChanged.listen((result) {
//       print(result);
//       _checkStatus(result);
//     });
//   }

//   // 2.
//   void _checkStatus(ConnectivityResult result) async {
//     bool isOnline = false;
//     try {
//       final result = await InternetAddress.lookup('google.com');
//       isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
//     } on SocketException catch (_) {
//       isOnline = false;
//     }
//     if (!_controller.isClosed) {
//       _controller.sink.add({result: isOnline});
//     }
//   }

//   void disposeStream() {
//     _connectivitySubscription.cancel();
//     _controller.close();
//   }
// }

// connectivity_service.dart

import 'dart:async';
// import 'package:connectivity/connectivity.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  late StreamSubscription<ConnectivityResult> _subscription;

  ConnectivityService() {
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      // Broadcast the connectivity result to subscribers
      _controller.add(result);
    });
  }

  StreamController<ConnectivityResult> _controller =
      StreamController<ConnectivityResult>.broadcast();

  Stream<ConnectivityResult> get onConnectivityChanged => _controller.stream;

  void dispose() {
    _subscription.cancel();
    _controller.close();
  }
}
