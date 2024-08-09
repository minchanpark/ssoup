import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'theme/color.dart';
import 'theme/text.dart';

class StampPage extends StatefulWidget {
  const StampPage({super.key});

  @override
  _StampPageState createState() => _StampPageState();
}

class _StampPageState extends State<StampPage> {
  final now = DateTime.now();
  String formattedDate = DateFormat('yyyy.MM.dd').format(DateTime.now());

  List<Map<String, dynamic>> stamps = [];

  @override
  void initState() {
    super.initState();
    fetchStampData();
  }

  Future<void> fetchStampData() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('user').doc(uid).get();
      List<dynamic> stampIds = userDoc['stampId'];

      for (String stampId in stampIds) {
        DocumentSnapshot stampDoc = await FirebaseFirestore.instance
            .collection('stamp')
            .doc(stampId)
            .get();
        if (stampDoc.exists) {
          Map<String, dynamic> stampData =
              stampDoc.data() as Map<String, dynamic>;
          stamps.add({
            'name': stampData['stampName'],
            'image': stampData['stampImageUrl'],
            'location': stampData['location'],
          });
        }
      }

      setState(() {});
    } catch (e) {
      print('Error fetching stamp data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.elliptical(200, 80),
              bottomRight: Radius.elliptical(200, 80),
            ),
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColor.homeMix,
              ),
              width: double.infinity,
              height: screenHeight * (320 / 852),
              child: Stack(
                children: [
                  Positioned(
                    top: screenHeight * (62 / 852),
                    child: SizedBox(
                      width: 73,
                      height: 68,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Color(0xffffffff),
                          )),
                    ),
                  ),
                  Positioned(
                    top: screenHeight * (54 / 852),
                    left: screenWidth * (159 / 393),
                    child: Image.asset(
                      'assets/6/ssoup.png',
                      width: 77,
                      height: 77,
                    ),
                  ),
                  Positioned(
                    top: screenHeight * (129 / 852),
                    left: screenWidth * (60 / 393),
                    child: Text(
                      '김한동님의 스탬프 모아보기',
                      style: bold23.copyWith(
                        color: Colors.white,
                        fontSize: screenWidth * (23 / 393),
                      ),
                    ),
                  ),
                  Positioned(
                    top: screenHeight * (167 / 852),
                    left: screenWidth * (157 / 393),
                    child: Text(
                      '$formattedDate',
                      style: regular15.copyWith(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Positioned(
                    top: screenHeight * (201 / 852),
                    left: screenWidth * (60 / 393),
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/aaa.png',
                          width: 193,
                        ),
                        Positioned(
                            top: screenHeight * (14 / 852),
                            left: screenWidth * (13 / 393),
                            child: Text(
                              '플로깅 인증하고 스탬프를 모아\n제 친구들을 구해주세요!',
                              textAlign: TextAlign.center,
                              style: regular13.copyWith(
                                height: 1.38,
                                letterSpacing: -0.32,
                              ),
                            )),
                      ],
                    ),
                  ),
                  Positioned(
                    top: screenHeight * (97 / 852),
                    left: screenWidth * (134 / 393),
                    child: Image.asset(
                      'assets/mugogi.png',
                      width: screenWidth * (308 / 393),
                      height: screenHeight * (271 / 852),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              padding: const EdgeInsets.all(16),
              children: stamps.map((stamp) {
                return StampItem(
                  name: stamp['name'],
                  image: stamp['image'],
                  location: stamp['location'],
                  width: screenWidth * (144 / 393),
                  height: screenHeight * (144 / 852),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class StampItem extends StatelessWidget {
  final String name;
  final String image;
  final String location;
  final double width;
  final double height;

  const StampItem({
    super.key,
    required this.name,
    required this.image,
    required this.location,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.sizeOf(context).width;
    double mediaHeight = MediaQuery.sizeOf(context).height;
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Center(
                  child: Text(
                '$name 스탬프',
                style: extrabold24.copyWith(
                  color: const Color(0xff1E528E),
                  fontSize: mediaWidth * (24 / 393),
                ),
              )),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: mediaWidth * (280 / 393),
                    height: mediaHeight * (200 / 852),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: const Color(0xffEEF4FF),
                    ),
                    child: Image.network(
                      image,
                      width: width,
                      height: height,
                    ),
                  ),
                  SizedBox(
                    height: mediaWidth * (30 / 852),
                  ),
                  Text(
                    '$location 플로깅 완료',
                    style: medium16.copyWith(fontSize: mediaWidth * (16 / 393)),
                  ),
                  SizedBox(
                    height: mediaWidth * (30 / 852),
                  ),
                  Text(
                    '일시: 2024.06.27 / 14:27 \n거리: 1.5km',
                    style: medium15.copyWith(fontSize: mediaWidth * (15 / 393)),
                  ),
                  SizedBox(
                    height: mediaWidth * (30 / 852),
                  ),
                  Container(
                    width: mediaWidth * (280 / 393),
                    height: mediaHeight * (40 / 852),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xffA3C2FF)),
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: Center(
                        child: Text(
                      '10마리의 해양생물이 고마워하고 있어요!',
                      style:
                          medium13.copyWith(fontSize: mediaWidth * (13 / 393)),
                    )),
                  )
                ],
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff50A2FF)),
                  child: Text(
                    "닫기",
                    style: bold15.copyWith(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: const Color(0xffEEF4FF),
            child: Image.network(
              image,
              width: (width / 393) * mediaWidth,
              height: (height / 852) * mediaHeight,
            ),
          ),
          const SizedBox(height: 8),
          Text(name, style: regular15),
        ],
      ),
    );
  }
}
