import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ssoup/theme/text.dart';

import '../theme/color.dart';

class PhotoReviewPage extends StatefulWidget {
  final String courseId;

  const PhotoReviewPage({super.key, required this.courseId});

  @override
  State<PhotoReviewPage> createState() => _PhotoReviewPageState();
}

class _PhotoReviewPageState extends State<PhotoReviewPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xFFFFFFFF),
        title: Text(
          '포토 리뷰 모아보기',
          style: regular15.copyWith(
            fontSize: 18,
            height: 1.16,
            letterSpacing: -0.32,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('course')
              .doc(widget.courseId)
              .collection('visitor')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            var visitor = snapshot.data!.docs;
            return Padding(
              padding: EdgeInsets.only(
                  left: screenWidth * (26 / 393),
                  right: screenWidth * (27 / 393),
                  top: screenHeight * (37 / 852)),
              child: GridView.builder(
                shrinkWrap: false,
                itemCount: visitor.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, //1 개의 행에 보여줄 item 개수
                  mainAxisSpacing: 12, //수평 Padding
                  crossAxisSpacing: 15, //수직 Padding
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColor.button),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        visitor[index]['reviewImageUrl'],
                        width: 105,
                        height: 102,
                        fit: BoxFit.fill,
                      ),
                    ),
                  );
                },
              ),
            );
          }),
    );
  }
}
