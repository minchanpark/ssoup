import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/zondicons.dart';
import 'coursedetail.dart';
import 'theme/text.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('course').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var courses = snapshot.data!.docs.map((doc) {
            return Course(
              id: doc.id,
              image: doc['courseImageUrl'],
              title: doc['courseName'],
              location: doc['startLocation'],
              duration: '소요시간: ${doc['spendTime']}',
              peopleCount: '누적 참여자 수: ${doc['totalVisitor']}명',
            );
          }).toList();

          return ListView.builder(
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
                            courseId: course.id, // courseId 전달
                            courseImage: course.image,
                            courseTitle: course.title,
                            courseLocation: course.location,
                            courseDuration: course.duration,
                          ),
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
                            Image.network(
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
          );
        },
      ),
    );
  }
}

class Course {
  final String id; // 코스 ID 추가
  final String image;
  final String title;
  final String location;
  final String duration;
  final String peopleCount;

  Course({
    required this.id, // 코스 ID 추가
    required this.image,
    required this.title,
    required this.location,
    required this.duration,
    required this.peopleCount,
  });
}
