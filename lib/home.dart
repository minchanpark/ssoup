import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'bigmap.dart';
import 'course.dart';
import 'map.dart';
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

  static const LinearGradient homeMix = LinearGradient(
    colors: [
      Color.fromRGBO(138, 206, 255, 1),
      Color.fromRGBO(163, 194, 255, 1),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

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
                scrollDirection: Axis.vertical,
                child: Center(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                        child: Container(
                          decoration: BoxDecoration(gradient: homeMix),
                          height: 278,
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * (20.0 / 393),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${snapshot.data!["nick_name"]}님의 플로깅 현황',
                                        style: extrabold24.copyWith(
                                            color: const Color(0xff1E528E)),
                                      ),
                                      SizedBox(
                                        height: screenHeight * (10 / 852),
                                      ),
                                      Text(
                                        '방문한 관광지 $totalSpot곳',
                                        style: medium15.copyWith(
                                            color: Colors.white),
                                      ),
                                      Text(
                                        '획득한 스탬프 $totalStamp개',
                                        style: medium15.copyWith(
                                            color: Colors.white),
                                      ),
                                      Text(
                                        '움직인 거리 ${totalKm.toStringAsFixed(1)}km',
                                        style: medium15.copyWith(
                                            color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: screenHeight * (10 / 852),
                                      ),
                                      Text(
                                        '${snapshot.data!["nick_name"]}님은 총 $totalStamp번의 플로깅을 인증했어요!',
                                        style: medium15.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.person,
                                    size: 40,
                                    color: Colors.grey,
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
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenHeight * (20.0 / 852),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const BigMapPage(),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      color: const Color(0xffD5E3FF),
                                      child: Image.asset('assets/map.png',
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                                SizedBox(width: screenWidth * (10 / 393)),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const CoursePage(),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      color: const Color(0xffD5E3FF),
                                      child: Image.asset('assets/course.png',
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * (30 / 852)),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const StampPage(),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      color: const Color(0xffD5E3FF),
                                      child: Image.asset(
                                        'assets/stamp.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: screenWidth * (10 / 393)),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const GoogleMapPage(),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      color: const Color(0xffD5E3FF),
                                      clipBehavior: Clip.hardEdge,
                                      child: Image.asset(
                                        'assets/stalk.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
                                right: screenHeight * (14 / 393),
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
                      )
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
