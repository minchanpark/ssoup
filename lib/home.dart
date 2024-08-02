import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ssoup/theme/color.dart';
import 'about_map/bigmap.dart';
import 'course/course.dart';
import 'stamp.dart';
import 'theme/text.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<Map<String, dynamic>> _getUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) throw FirebaseAuthException(code: 'NO_USER');

    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('user').doc(user.uid).get();
    if (!userDoc.exists) throw FirebaseAuthException(code: 'NO_USER_DOC');

    return userDoc.data() as Map<String, dynamic>;
  }

  Future<String> fetchNickname() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(user!.uid)
          .get();

      return documentSnapshot['nick_name'];
    } catch (e) {
      print("Error fetching nickname: $e");
      return "Error";
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return FutureBuilder<String>(
      future: fetchNickname(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: FutureBuilder<Map<String, dynamic>>(
            future: _getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final userData = snapshot.data!;
              final int totalSpot = userData['totalSpot'] ?? 0;
              final int totalStamp = userData['totalStamp'] ?? 0;
              final double totalKm = userData['totalKm'] ?? 0.0;

              return SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                        child: Container(
                          decoration:
                              const BoxDecoration(gradient: AppColor.homeMix),
                          height: screenHeight * (278 / 852),
                          width: screenWidth,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * (20 / 393),
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: screenHeight * (63 / 852),
                                    ),
                                    Text(
                                      '${snapshot.data!["nick_name"]}님의 플로깅 현황',
                                      style: extrabold24.copyWith(
                                        color: const Color(0xff1E528E),
                                        fontSize: screenWidth *
                                            (24 / 393), // 화면 너비를 기준으로 폰트 사이즈 조정
                                      ),
                                    ),
                                    SizedBox(
                                      height: screenHeight * (10 / 852),
                                    ),
                                    Text(
                                      '방문한 관광지 $totalSpot곳',
                                      style: medium15.copyWith(
                                        color: Colors.white,
                                        fontSize: screenWidth *
                                            (15 / 393), // 화면 너비를 기준으로 폰트 사이즈 조정
                                      ),
                                    ),
                                    Text(
                                      '획득한 스탬프 $totalStamp개',
                                      style: medium15.copyWith(
                                        color: Colors.white,
                                        fontSize: screenWidth *
                                            (15 / 393), // 화면 너비를 기준으로 폰트 사이즈 조정
                                      ),
                                    ),
                                    Text(
                                      '움직인 거리 ${totalKm.toStringAsFixed(1)}km',
                                      style: medium15.copyWith(
                                        color: Colors.white,
                                        fontSize: screenWidth *
                                            (15 / 393), // 화면 너비를 기준으로 폰트 사이즈 조정
                                      ),
                                    ),
                                    SizedBox(
                                      height: screenHeight * (10 / 852),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  left: screenWidth * (200 / 393),
                                  top: screenHeight * (123 / 852),
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: screenHeight * (40 / 852),
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.person,
                                          size: screenHeight * (40 / 852),
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        '${snapshot.data!["nick_name"]}님은 총 $totalStamp번의\n 플로깅을 인증했어요!',
                                        style: medium15.copyWith(
                                          color: Colors.white,
                                          fontSize: screenWidth *
                                              (15 /
                                                  393), // 화면 너비를 기준으로 폰트 사이즈 조정
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * (50 / 852),
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const BigMapPage(),
                                    ),
                                  );
                                },
                                child: Image.asset(
                                  'assets/map.png',
                                  width: 161,
                                  height: 198,
                                ),
                              ),
                              SizedBox(width: screenWidth * (21 / 393)),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const CoursePage(),
                                    ),
                                  );
                                },
                                child: Image.asset(
                                  'assets/course.png',
                                  width: 161,
                                  height: 198,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * (25 / 852)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const StampPage(),
                                    ),
                                  );
                                },
                                child: Image.asset(
                                  'assets/stamp.png',
                                  width: 161,
                                  height: 198,
                                ),
                              ),
                              SizedBox(width: screenWidth * (21 / 393)),
                              GestureDetector(
                                onTap: () {},
                                child: Image.asset(
                                  'assets/stalk.png',
                                  width: 161,
                                  height: 198,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * (50 / 852),
                      ),
                      SizedBox(
                        height: screenHeight * (64 / 852),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: screenWidth * (28 / 393),
                                right: screenWidth * (14 / 393),
                              ),
                              child: Container(
                                width: screenWidth * (370 / 393),
                                height: screenHeight * (64 / 852),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                ),
                                child: Image.asset('assets/ssss.png'),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: screenWidth * (14 / 393)),
                              child: Container(
                                width: screenWidth * (343 / 393),
                                height: screenHeight * (64 / 852),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                ),
                                child: Image.asset('assets/ssss.png'),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * (30 / 852),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
