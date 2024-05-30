// import 'package:dio/dio.dart';
// import 'package:vital/models/data/dio_client.dart';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:logger/web.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vital/firebase_options.dart';
import 'package:vital/models/vital/vital_preferences.dart';
import 'package:vital/screens/add_vital_screen.dart';
import 'package:vital/screens/home_screen.dart';
import 'package:vital/screens/medicine_screen.dart';
import 'package:vital/screens/setting_screen.dart';
import 'package:vital/screens/vital_chart_screen.dart';
import 'package:vital/screens/vital_list_screen.dart';
import 'package:vital/screens/vital_update_screen.dart';
import 'package:vital/viewcontrollers/fcm_controller.dart';

// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   // await Firebase.initializeApp();
//   logger.t('** background message  ${DateTime.now()}');
//   var androidSetting = const AndroidInitializationSettings("@mipmap/launcher_icon");
//   logger.t(androidSetting);
//   var initSettings = InitializationSettings(android: androidSetting);
//   // FlutterLocalNotificationsPlugin.initialize(initSettings);
//   // FlutterLocalNotificationsPlugin().show(
//   //   // message.notification.hashCode,
//   //   0,
//   //   message.notification!.title,
//   //   message.notification!.body,
//   //   const NotificationDetails(
//   //     android: AndroidNotificationDetails(
//   //       'high_importance_channel',
//   //       'high_importance_notification',
//   //       importance: Importance.max,
//   //     ),
//   //   ),
//   // );

//   print("Handling a background message: ${message.messageId}");
// }

var logger = Logger();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: 'local.env');
    await VitalPreferences.init();
    await checkAndSetInitialValues();

    final FcmController fcmController = Get.put(FcmController());
    await fcmController.initialize();
    
  } catch (err) {
    const AlertDialog(
      title: Text('Serious Warning'),
      content: Text(
          'Cannot initialize default settings. \nClose the app and restart. \nIf this happens repeatedly contact to service center for this app.'),
    );
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return;
  }

  runApp(const MyApp());
}


Future<void> checkAndSetInitialValues() async {
  final prefs = await SharedPreferences.getInstance();
  final isInitialRun = prefs.getBool('isInitialRun');

  if (isInitialRun == null) {
    await VitalPreferences.setDefaultVitalValues();
    await prefs.setBool('isInitialRun', true);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Mom's Vital",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const HomeScreen(),
        '/graph': (context) => const VitalLineChartScreen(),
        '/list': (context) => const VitalListScreen(),
        // '/detail' :(context) => VitalDetailScreen(id: id),
        '/add': (context) => const AddVitalScreen(),
        // '/update': (context) => const UpdateVitalScreen(),
        '/medicine': (context) => const MedicineScreen(),
        '/setting': (context) => const SettingScreen(),
      },
    );
  }
}


