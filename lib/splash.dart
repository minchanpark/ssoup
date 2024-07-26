import 'package:flutter/material.dart';

import 'theme/text.dart';

class splashPage extends StatelessWidget {
  const splashPage({Key? key}) : super(key: key);

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
          decoration: BoxDecoration(
            gradient: homeMix,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
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
