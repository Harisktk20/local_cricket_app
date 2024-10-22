// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'firebase_options.dart';
import 'screen/splash_screen/splash_screen.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //8585215c-b630-4d8b-b6e6-8b1669afd7a4 app id one signal
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize('8585215c-b630-4d8b-b6e6-8b1669afd7a4');
  OneSignal.Notifications.addClickListener((OSNotificationClickEvent event) {
    if (event.notification.additionalData!["custom_data"]["NOTIFICATION_TYPE"] == "MESSAGE_NOTIFICATION") {
    } else {}
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cric Trax',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}
