import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:ssoup/constants.dart';
import 'package:ssoup/login.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Location().requestPermission();

  KakaoSdk.init(
    nativeAppKey: kakaoNativeAppKey,
    javaScriptAppKey: kakaoJavaScriptAppKey,
  );
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
