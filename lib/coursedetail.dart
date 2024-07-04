import 'package:flutter/material.dart';

import 'theme/text.dart';

class CourseDetailPage extends StatelessWidget {
  final String courseImage;
  final String courseTitle;
  final String courseLocation;
  final String courseDuration;

  const CourseDetailPage(
      {required this.courseImage,
      required this.courseTitle,
      required this.courseLocation,
      required this.courseDuration,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                courseImage,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  courseTitle,
                  style: extrabold25,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  '출발위치: ' + courseLocation,
                  style: regular15,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(courseDuration, style: regular15),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 16, right: 16),
                child: Text('코스 경로: 울릉도 선착장 → 봉래폭포→ 내수일출전망대 → 석포일출일몰전망대',
                    style: regular15),
              ),
              SizedBox(
                height: 30,
              ),
              Divider(),
              SizedBox(
                height: 30,
              ),
              Image.asset('assets/imsi.png'),
              SizedBox(
                height: 30,
              ),
              Center(
                  child: Container(
                      width: 350,
                      height: 65,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          '코스 안내받기',
                          style: extrabold20,
                        ),
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            side: BorderSide(color: Color(0xff4468AD))),
                      ))),
              SizedBox(
                height: 70,
              ),
            ],
          ),
        ));
  }
}
