import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/zondicons.dart';

import 'coursedetail.dart';
import 'theme/text.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage>
    with SingleTickerProviderStateMixin {
  final List<Course> courses = [
    Course(
      image: 'assets/course1.png',
      title: '인생샷을 건져보자 코스',
      location: '울릉도 선착장',
      duration: '소요시간: 1시간',
      peopleCount: '누적 참여자 수: 553명',
    ),
    Course(
      image: 'assets/course2.png',
      title: '자연과 하나되는 코스',
      location: '봉래폭포',
      duration: '소요시간: 1시간',
      peopleCount: '누적 참여자 수: 433명',
    ),
    Course(
      image: 'assets/course3.png',
      title: '독도 바라보기 코스',
      location: '울릉도 선착장',
      duration: '소요시간: 40분',
      peopleCount: '누적 참여자 수: 255명',
    ),
    Course(
      image: 'assets/course4.png',
      title: '울릉도를 한눈에 보고 싶다면 코스',
      location: '울릉도 선착장',
      duration: '소요시간: 50분',
      peopleCount: '누적 참여자 수: 808명',
    ),
    Course(
      image: 'assets/course5.png',
      title: '울릉도 한바퀴하면서 플로깅?',
      location: '울릉도 선착장',
      duration: '소요시간: 1시간',
      peopleCount: '누적 참여자 수: 593명',
    ),
    Course(
      image: 'assets/course6.png',
      title: '가족과 함께 즐기는 코스',
      location: '내수일출 전망대',
      duration: '소요시간: 2시간',
      peopleCount: '누적 참여자 수: 553명',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          '플로깅 코스',
          style: medium20.copyWith(
            color: Color(0xff1E528E),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return Column(
            children: [
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CourseDetailPage(
                          courseImage: course.image,
                          courseTitle: course.title,
                          courseLocation: course.location,
                          courseDuration: course.duration),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xff1E528E)),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Image.asset(
                          course.image,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(course.title, style: medium15),
                              const SizedBox(height: 8.0),
                              Row(
                                children: [
                                  const Iconify(Zondicons.location,
                                      color: Colors.black),
                                  const SizedBox(width: 4),
                                  const Text("출발 위치:"),
                                  const SizedBox(width: 4),
                                  Text(course.location, style: light11),
                                ],
                              ),
                              const SizedBox(height: 4.0),
                              Row(
                                children: [
                                  const Iconify(Zondicons.time,
                                      color: Colors.black),
                                  const SizedBox(width: 4),
                                  Text(course.duration, style: light11),
                                ],
                              ),
                              const SizedBox(height: 4.0),
                              Text(course.peopleCount, style: regular10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Course {
  final String image;
  final String title;
  final String location;
  final String duration;
  final String peopleCount;

  Course({
    required this.image,
    required this.title,
    required this.location,
    required this.duration,
    required this.peopleCount,
  });
}
