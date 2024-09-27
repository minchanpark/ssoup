import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:ssoup/constants.dart';
import 'package:ssoup/home.dart';
import 'package:ssoup/home_navigationbar.dart';
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

  runApp(
      const MaterialApp(debugShowCheckedModeBanner: false, home: SplashPage()));

  await Future.delayed(const Duration(seconds: 3));

  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
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
        "/home_page_navigationBar": (BuildContext context) =>
            const HomePageNavigationBar(),
      },
      home: const LoginPage(),
    );
  }
}
