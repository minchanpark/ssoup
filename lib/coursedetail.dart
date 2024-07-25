import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'theme/text.dart';

class CourseDetailPage extends StatefulWidget {
  final String courseId;
  final String courseImage;
  final String courseTitle;
  final String courseLocation;
  final String courseDuration;
  final String courseLocationName;

  const CourseDetailPage({
    required this.courseId,
    required this.courseImage,
    required this.courseTitle,
    required this.courseLocation,
    required this.courseDuration,
    required this.courseLocationName,
    super.key,
  });

  @override
  _CourseDetailPageState createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  File? _image;
  String? _review;
  double _score = 5.0;
  String nickname = "";

  @override
  void initState() {
    super.initState();
    _fetchNickname();
  }

  Future<void> _fetchNickname() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot documentSnapshot =
            await _firestore.collection('user').doc(user.uid).get();

        setState(() {
          nickname = documentSnapshot['nick_name'];
        });
      } catch (e) {
        print("Error fetching nickname: $e");
      }
    } else {
      print("User not logged in");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    Future<void> pickImage() async {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        }
      });
    }

    Future<void> submitReview() async {
      if (_review == null || _review!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please provide review text'),
        ));
        return;
      }

      final user = _auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('User not logged in'),
        ));
        return;
      }

      String? reviewImageUrl;
      if (_image != null) {
        final imagePath = 'visitor/${DateTime.now()}.png';
        final ref = FirebaseStorage.instance.ref().child(imagePath);
        await ref.putFile(_image!);
        reviewImageUrl = await ref.getDownloadURL();
      }

      await _firestore
          .collection('course')
          .doc(widget.courseId)
          .collection('visitor')
          .doc(user.uid)
          .set({
        'uid': user.uid,
        'username': nickname,
        'reviewImageUrl': reviewImageUrl,
        'review': _review,
        'score': _score,
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        _image = null;
        _review = null;
        _score = 5.0;
      });

      Navigator.of(context).pop();
    }

    double averageScore(List<DocumentSnapshot> visitor) {
      if (visitor.isEmpty) return 0.0;
      double total = 0.0;
      for (var review in visitor) {
        total += review['score'];
      }
      return total / visitor.length;
    }

    void showReviewDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('리뷰 작성하기'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      hintText: '리뷰를 작성하세요',
                    ),
                    maxLines: 3,
                    onChanged: (value) {
                      setState(() {
                        _review = value;
                      });
                    },
                  ),
                  SizedBox(height: screenHeight * (10 / 852)),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: pickImage,
                        child: const Text('이미지 업로드'),
                      ),
                      SizedBox(width: screenWidth * (10 / 393)),
                      _image == null
                          ? const Text(' ')
                          : Image.file(
                              _image!,
                              width: 50,
                              height: 50,
                            ),
                    ],
                  ),
                  SizedBox(height: screenHeight * (10 / 852)),
                  Row(
                    children: [
                      const Text('점수'),
                      SizedBox(width: screenWidth * (10 / 393)),
                      DropdownButton<double>(
                        value: _score,
                        onChanged: (double? newValue) {
                          setState(() {
                            _score = newValue!;
                          });
                        },
                        items: [1, 2, 3, 4, 5]
                            .map<DropdownMenuItem<double>>((int value) {
                          return DropdownMenuItem<double>(
                            value: value.toDouble(),
                            child: Text(value.toString()),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: submitReview,
                child: const Text('등록'),
              ),
            ],
          );
        },
      );
    }

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
                                onPressed: () {},
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
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: screenHeight * (30 / 852)),
                          StreamBuilder<QuerySnapshot>(
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
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * (20 / 393),
                                    ),
                                    child: Row(
                                      children: [
                                        Row(
                                          children: List.generate(
                                            5,
                                            (index) => Icon(
                                              Icons.star,
                                              color: index <
                                                      averageScore(visitor)
                                                          .round()
                                                  ? Colors.yellow
                                                  : Colors.grey,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            width: screenWidth * (4 / 393)),
                                        Text(
                                          averageScore(visitor)
                                              .toStringAsFixed(1),
                                          style: regular15,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * (30 / 852),
                                  ),
                                  Divider(
                                    height: screenHeight * (10 / 852),
                                    color: const Color(0xffF3F3F3),
                                  ),
                                  const Text(
                                    "리뷰",
                                    style: medium20,
                                  ),
                                  Divider(
                                    height: screenHeight * (10 / 852),
                                    color: const Color(0xffF3F3F3),
                                  ),
                                  Divider(
                                    height: screenHeight * (10 / 852),
                                    color: const Color(0xffF3F3F3),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: visitor.length,
                                    itemBuilder: (context, index) {
                                      var review = visitor[index];
                                      return ListTile(
                                        leading:
                                            review['reviewImageUrl'] != null
                                                ? Image.network(
                                                    review['reviewImageUrl'])
                                                : null,
                                        title: Text(
                                          review['review'],
                                          style: regular15,
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: List.generate(
                                                5,
                                                (starIndex) => Icon(
                                                  Icons.star,
                                                  color: starIndex <
                                                          review['score']
                                                              .toInt()
                                                      ? Colors.yellow
                                                      : Colors.grey,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '${review['username']}',
                                              style: regular13,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                          SizedBox(
                            height: screenHeight * (10 / 852),
                          ),
                          Center(
                            child: ElevatedButton(
                              onPressed: showReviewDialog,
                              child: const Text('리뷰 작성'),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * (70 / 852),
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
