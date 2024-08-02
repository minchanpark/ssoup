import 'package:flutter/material.dart';
import 'package:ssoup/course/course_review_page.dart';
import 'package:ssoup/about_map/map.dart';
import '../theme/text.dart';

class CourseDetailPage extends StatefulWidget {
  final String courseId;
  final String courseImage;
  final String courseTitle;
  final List courseStartLocation;
  final List courseEndLocation;
  final String courseDuration;
  final String courseLocationName;

  const CourseDetailPage({
    required this.courseId,
    required this.courseImage,
    required this.courseTitle,
    required this.courseStartLocation,
    required this.courseEndLocation,
    required this.courseDuration,
    required this.courseLocationName,
    super.key,
  });

  @override
  _CourseDetailPageState createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                widget.courseImage,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  widget.courseTitle,
                  style: extrabold25,
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: screenWidth * (8.0 / 393)),
                child: const TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: Colors.black,
                  labelStyle: medium15,
                  tabs: [
                    Tab(text: '코스정보'),
                    Tab(text: '리뷰'),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * (10 / 852)),
              SizedBox(
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
                              '출발위치: ${widget.courseLocationName}',
                              style: regular15,
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: screenWidth * (20 / 393)),
                            child:
                                Text(widget.courseDuration, style: regular15),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: screenWidth * (20 / 393),
                              top: screenHeight * (16 / 852),
                              right: screenWidth * (16 / 393),
                            ),
                            child: const Text(
                              '코스 경로: 울릉도 선착장 → 봉래폭포→ 내수일출전망대 → 석포일출일몰전망대',
                              style: regular15,
                            ),
                          ),
                          SizedBox(height: screenHeight * (30 / 852)),
                          SizedBox(height: screenHeight * (30 / 852)),
                          Image.asset('assets/imsi.png'),
                          SizedBox(height: screenHeight * (30 / 852)),
                          Center(
                            child: SizedBox(
                              width: 350,
                              height: 65,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GoogleMapPage(
                                        startLocation:
                                            widget.courseStartLocation,
                                        endLocation: widget.courseEndLocation,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  side: const BorderSide(
                                    color: Color(0xff4468AD),
                                  ),
                                ),
                                child: const Text(
                                  '코스 안내받기',
                                  style: extrabold20,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * (70 / 852)),
                        ],
                      ),
                    ),
                    CourseReviewPage(
                      courseId: widget.courseId,
                      courseDuration: widget.courseDuration,
                      courseEndLocation: widget.courseEndLocation,
                      courseImage: widget.courseImage,
                      courseLocationName: widget.courseLocationName,
                      courseTitle: widget.courseTitle,
                      courseStartLocation: widget.courseStartLocation,
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
