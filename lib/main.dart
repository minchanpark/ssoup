import 'package:firebase_core/firebase_core.dart'; // Firebase 초기화를 위해 추가
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:ssoup/home.dart';
import 'package:ssoup/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 엔진이 초기화될 때까지 기다림
  await Firebase.initializeApp();
  await Location().requestPermission();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(),
    );
  }
}
