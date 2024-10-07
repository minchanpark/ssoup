import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ssoup/plogging/plogging_review_page.dart';
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
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    widget.courseImage,
                    width: double.infinity,
                    height: (341 / 852) * screenHeight,
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
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
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
                  SizedBox(height: screenHeight * 0.012),
                  SizedBox(
                    height: (340 / 852) * screenHeight,
                    child: TabBarView(
                      children: [
                        _buildCourseInfo(screenWidth, screenHeight),
                        CourseReviewPage(
                          courseId: widget.courseId,
                          courseImage: widget.courseImage,
                          courseLocationName: widget.courseLocationName,
                          courseTitle: widget.courseTitle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: screenHeight * 0.063,
                left: screenWidth * 0.013,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          child: Center(
            child: SizedBox(
              width: 350,
              height: 65,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GoogleMapPage(
                        startLocation: widget.courseStartLocation,
                        endLocation: widget.courseEndLocation,
                        courseId: widget.courseId,
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
                  '장소 안내받기',
                  style: extrabold20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 코스 정보 섹션 빌드
  Widget _buildCourseInfo(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: (20 / 393) * screenWidth,
            top: (32 / 852) * screenHeight,
            bottom: (14 / 852) * screenHeight,
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/system-uicons_location.svg',
                width: 23,
                height: 23,
                color: const Color(0xff000000),
              ),
              Text(
                '주소: ',
                style: medium15.copyWith(
                  fontWeight: FontWeight.w500,
                  height: 0.09,
                  letterSpacing: -0.32,
                ),
              ),
              Expanded(
                child: Text(
                  widget.courseLocationName,
                  style: regular15.copyWith(
                    fontSize: (15 / 393) * screenWidth,
                    fontWeight: FontWeight.w300,
                    letterSpacing: -0.32,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: (20 / 393) * screenWidth,
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/time.svg',
                width: 23,
                height: 23,
                color: const Color(0xff000000),
              ),
              Text(
                "관광시간: ",
                style: medium15.copyWith(
                  fontWeight: FontWeight.w500,
                  height: 0.09,
                  letterSpacing: -0.32,
                ),
              ),
              Text(
                widget.courseDuration,
                style: regular15.copyWith(
                  fontWeight: FontWeight.w300,
                  height: 0.09,
                  letterSpacing: -0.32,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}