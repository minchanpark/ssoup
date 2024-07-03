import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/zondicons.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Course> courses = [
    Course(
      title: '인생샷을 건져보자 코스',
      location: '올림픽 공원',
      duration: '소요시간: 1시간',
      peopleCount: '누적 참여자 수: 553명',
    ),
    Course(
      title: '자연과 하나되는 코스',
      location: '청계천',
      duration: '소요시간: 1시간',
      peopleCount: '누적 참여자 수: 433명',
    ),
    Course(
      title: '독도 바라보기 코스',
      location: '용산구 선정릉',
      duration: '소요시간: 40분',
      peopleCount: '누적 참여자 수: 255명',
    ),
    Course(
      title: '홀로도 한강에 보고 싶다면 코스',
      location: '서울숲',
      duration: '소요시간: 50분',
      peopleCount: '누적 참여자 수: 808명',
    ),
    Course(
      title: '홀로도 한강에 하면서 졸깅?',
      location: '행복해지기',
      duration: '소요시간: 1시간',
      peopleCount: '누적 참여자 수: 593명',
    ),
    Course(
      title: '가족과 함께 즐기는 코스',
      location: '나의 사랑해요',
      duration: '소요시간: 1시간 30분',
      peopleCount: '누적 참여자 수: 310명',
    ),
    Course(
      title: '홀로도 함께하는 졸토트 필수 코스',
      location: '서울마리나',
      duration: '소요시간: 1시간 30분',
      peopleCount: '누적 참여자 수: 705명',
    ),
    Course(
      title: '노을이 질 때 가장 아름다운 ...',
      location: '서울행복',
      duration: '소요시간: 1시간',
      peopleCount: '누적 참여자 수: 309명',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '플로깅 코스',
          style: TextStyle(color: Color(0xff1E528E)),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xff1E528E),
          labelColor: const Color(0xff1E528E),
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(
              child: Text(
                '뚜벅이',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Tab(
              child: Text(
                '자전거',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xff1E528E)),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  leading: Container(
                    color: Colors.blue,
                    width: 40,
                    height: 40,
                  ),
                  title: Text(
                    course.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Iconify(Zondicons.location,
                              color: Colors.black),
                          const SizedBox(width: 4),
                          const Text("출발 위치 :"),
                          const SizedBox(width: 4),
                          Text(
                            course.location,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Iconify(Zondicons.time, color: Colors.black),
                          const SizedBox(width: 4),
                          Text(course.duration),
                        ],
                      ),
                      Text(course.peopleCount),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            },
          ),
          const Center(
            child: Text(
              '코스 업데이트 준비중',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

class Course {
  final String title;
  final String location;
  final String duration;
  final String peopleCount;

  Course({
    required this.title,
    required this.location,
    required this.duration,
    required this.peopleCount,
  });
}
