import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:muslim/app/app.dart';
import 'package:muslim/app/init_services.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final connectivityResult = await Connectivity().checkConnectivity();

  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    try {
      Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      final fcmToken = FirebaseMessaging.instance.getToken();
      await FirebaseMessaging.instance.setAutoInitEnabled(true);
      await FirebaseMessaging.instance.subscribeToTopic("news");
      log("FCMToken $fcmToken");
    } catch (e) {
      log(e.toString());
    }
  } else {
    log("internet available");
  }

  runApp(const MyApp());
}
