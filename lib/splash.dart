import 'package:flutter/material.dart';

import 'theme/text.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  static const LinearGradient homeMix = LinearGradient(
    colors: [
      Color.fromRGBO(138, 206, 255, 1),
      Color.fromRGBO(163, 194, 255, 1),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: homeMix,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 234,
                child: Image.asset('assets/logo.png'),
              ),
              Text('울릉도의 다양한 관광코스와 플로깅까지 즐길 수 있는',
                  style: regular13.copyWith(color: Colors.white)),
              Text('울릉도 관광객만을 위한 서비스',
                  style: regular13.copyWith(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
