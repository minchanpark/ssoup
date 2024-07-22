import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:ssoup/constants.dart';
import 'package:ssoup/home.dart';
import 'package:ssoup/login.dart';
import 'package:ssoup/nick_name.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
    return MaterialApp(
      routes: {
        "/nick_name_page": (BuildContext context) => const NickNamePage(),
        "/home_page": (BuildContext context) => const HomePage(),
      },
      home: LoginPage(),
    );
  }
}
