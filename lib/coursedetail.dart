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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
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
                padding: const EdgeInsets.all(20),
                child: Text(
                  courseTitle,
                  style: extrabold25,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: Colors.black,
                  labelStyle: medium15,
                  tabs: [
                    Tab(text: '코스정보'),
                    Tab(text: '리뷰'),
                  ],
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Container(
                height: MediaQuery.of(context).size.height - 200,
                child: TabBarView(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              '출발위치: ' + courseLocation,
                              style: regular15,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(courseDuration, style: regular15),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 16, right: 16),
                            child: Text(
                                '코스 경로: 울릉도 선착장 → 봉래폭포→ 내수일출전망대 → 석포일출일몰전망대',
                                style: regular15),
                          ),
                          SizedBox(
                            height: 30,
                          ),
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
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    side: BorderSide(color: Color(0xff4468AD))),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 70,
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 100),
                            child: Row(
                              children: [
                                Icon(Icons.star),
                                Icon(Icons.star),
                                Icon(Icons.star),
                                Icon(Icons.star),
                                Icon(Icons.star)
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Divider(
                            thickness: 10,
                            color: Color(0xffF3F3F3),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 10, bottom: 10),
                            child: Text(
                              "리뷰",
                              style: medium20,
                            ),
                          ),
                          Divider(
                            color: Color(0xffB2B2B2),
                          ),
                          Divider(
                            color: Color(0xffB2B2B2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
