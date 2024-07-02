import 'package:flutter/material.dart';

import 'course.dart';
import 'stamp.dart';
import 'theme/text.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
                child: Container(
                  color: const Color(0xffA3C2FF),
                  height: 278,
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '김한동님의 플로깅 현황',
                                style: extrabold24.copyWith(color: Color(0xff1E528E)),
                              ),
                              SizedBox(height: 10),
                              Text(
                                '방문한 관광지 0곳',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '획득한 스탬프 1개',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '움직인 거리 0.5km',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                '김한동님은 총 1번의 플로깅을 인증했어요!',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 200,
                            child: Card(
                              color: Color(0xffD5E3FF),
                              child: Image.asset('assets/map.png',
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CoursePage()));
                            },
                            child: SizedBox(
                              height: 200,
                              child: Card(
                                color: Color(0xffD5E3FF),
                                child: Image.asset('assets/course.png',
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => StampPage()));
                            },
                            child: SizedBox(
                              height: 200,
                              child: Card(
                                color: Color(0xffD5E3FF),
                                child: Image.asset('assets/stamp.png', fit: BoxFit.cover,),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height: 200,
                            child: Card(
                                color: Color(0xffD5E3FF),
                                child: Image.asset(
                                  'assets/stalk.png',
                                  fit: BoxFit.cover,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                  height: 64,
                  child: ListView(scrollDirection: Axis.horizontal, children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 28, right: 14),
                      child: Container(
                        width: 343,
                        height: 64,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        child: const Text('울릉도 눈축제'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 14),
                      child: Container(
                        width: 343,
                        height: 64,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        child: const Text('다른 축제'),
                      ),
                    )
                  ]))
            ],
          ),
        ),
      ),
    );
  }
}
