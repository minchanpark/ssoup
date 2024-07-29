import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:ssoup/constants.dart';
import 'package:ssoup/home.dart';
import 'package:ssoup/login.dart';
import 'package:ssoup/nick_name.dart';

import 'splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  KakaoSdk.init(
    nativeAppKey: kakaoNativeAppKey,
    javaScriptAppKey: kakaoJavaScriptAppKey,
  );

  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: splashPage()));

  await Future.delayed(Duration(seconds: 3));

  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/nick_name_page": (BuildContext context) => const NickNamePage(),
        "/home_page": (BuildContext context) => const HomePage(),
      },
      home: LoginPage(),
    );
  }
}
