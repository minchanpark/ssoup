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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          '플로깅 코스',
          style: medium20.copyWith(
              color: const Color(0xff1E528E),
              fontSize: screenWidth * (20 / 393)),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('course').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var courses = snapshot.data!.docs.map((doc) {
            return Course(
              id: doc.id,
              image: doc['courseImageUrl'],
              title: doc['courseName'],
              location: doc['startLocation'].toString(),
              locationName: doc['startLocationName'],
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
                  SizedBox(height: screenHeight * (10 / 852)),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseDetailPage(
                            courseId: course.id, // courseId 전달
                            courseImage: course.image,
                            courseTitle: course.title,
                            courseLocationName: course.locationName,
                            courseLocation: course.location,
                            courseDuration: course.duration,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        vertical: screenHeight * (8.0 / 852),
                        horizontal: screenWidth * (16.0 / 393),
                      ),
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
                              width: screenWidth * (100 / 393),
                              height: screenHeight * (100 / 852),
                              fit: BoxFit.cover,
                            ),
                            SizedBox(
                              width: screenWidth * (16.0 / 393),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(course.title, style: medium15),
                                  SizedBox(height: screenHeight * (8.0 / 852)),
                                  Row(
                                    children: [
                                      const Iconify(Zondicons.location,
                                          color: Colors.black),
                                      SizedBox(
                                        width: screenWidth * (4 / 393),
                                      ),
                                      const Text("출발 위치:"),
                                      SizedBox(
                                        width: screenWidth * (4 / 393),
                                      ),
                                      Text(course.locationName, style: light11),
                                    ],
                                  ),
                                  SizedBox(
                                    height: screenHeight * (4 / 852),
                                  ),
                                  Row(
                                    children: [
                                      const Iconify(Zondicons.time,
                                          color: Colors.black),
                                      SizedBox(
                                        width: screenWidth * (4 / 393),
                                      ),
                                      Text(course.duration, style: light11),
                                    ],
                                  ),
                                  SizedBox(
                                    width: screenWidth * (4 / 393),
                                  ),
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
  final String locationName;
  final String duration;
  final String peopleCount;

  Course({
    required this.id, // 코스 ID 추가
    required this.image,
    required this.title,
    required this.location,
    required this.duration,
    required this.peopleCount,
    required this.locationName,
  });
}
