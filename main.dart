import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RKLiveApp());
}

class RKLiveApp extends StatelessWidget {
  const RKLiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RK Live',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
