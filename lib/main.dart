  import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/modules/Alarm/controllers/alarm_controller.dart';
import 'app/modules/Tracker/controllers/tracker_controller.dart';
import 'app/routes/app_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'firebase_options.dart';


void main() async {
  Get.put(AlarmController());         // nếu dùng báo thức
  Get.put(TrackerController());
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://rgujpucimxzffdcorehi.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJndWpwdWNpbXh6ZmZkY29yZWhpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg1Mjk3MTMsImV4cCI6MjA2NDEwNTcxM30.z3y1TqNtYLu9u-bR5wwqF9K6iUKMCNRowWTEhYOcKrQ',
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Sleep Tracker App',
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
    );
  }
}
