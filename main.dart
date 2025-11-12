import 'package:blooddonation/login.dart';
import 'package:blooddonation/theme.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  await FCM().initNotification();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PulseCare',
      themeMode: themeProvider.currentTheme,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.red,
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class FCM {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<String?> initNotification() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('✅ User granted notification permission');

      // Get FCM Token
      String? token = await _firebaseMessaging.getToken();
      debugPrint("📱 FCM Token: $token");

      // Save token locally
      final prefs = await SharedPreferences.getInstance();
      if (token != null && token.isNotEmpty) {
        await prefs.setString('fcm_token', token);
      }

      // Listen for token refresh
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
        debugPrint("🔄 FCM Token refreshed: $newToken");
        await prefs.setString('fcm_token', newToken);
      });

      return token;
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      debugPrint('🚫 User denied permission');
    } else {
      debugPrint('⚠️ Permission not granted or restricted');
    }

    return null;
  }

  Future<String?> getSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('fcm_token');
  }
}
