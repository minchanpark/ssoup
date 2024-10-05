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
  final String formattedDate = DateFormat('yyyy.MM.dd').format(DateTime.now());
  List<Map<String, dynamic>> stamps = [];
  String nickName = "";

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

      nickName = userDoc['nickName'];
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

      while (stamps.length < 6) {
        stamps.add({'name': '', 'image': '', 'location': ''});
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
          Stack(
            children: [
              Image.asset("assets/ul.png"),
              Center(
                  child: Padding(
                padding: EdgeInsets.only(top: 68.0),
                child: Text(
                  "스탬프",
                  style: medium20,
                ),
              )),
              Center(
                  child: Padding(
                padding: EdgeInsets.only(top: 227),
                child: Text(
                  "울릉도 곳곳에 숨어있는\n동물 친구들을 찾아주세요!",
                  style: medium20,
                ),
              ))
            ],
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              padding: const EdgeInsets.all(16),
              children: stamps.map((stamp) {
                if (stamp['name'] == '') {
                  return EmptyStampItem(
                    width: screenWidth * (144 / 393),
                    height: screenHeight * (144 / 852),
                  );
                } else {
                  return StampItem(
                    name: stamp['name'],
                    image: stamp['image'],
                    location: stamp['location'],
                    width: screenWidth * (144 / 393),
                    height: screenHeight * (144 / 852),
                  );
                }
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyStampItem extends StatelessWidget {
  final double width;
  final double height;

  const EmptyStampItem({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: const Color(0xffEEF4FF),
        ),
        const SizedBox(height: 8),
        Text(" "),
      ],
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
                ),
              ),
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
                  SizedBox(height: mediaWidth * (30 / 852)),
                  Text(
                    '$location 플로깅 완료',
                    style: medium16.copyWith(fontSize: mediaWidth * (16 / 393)),
                  ),
                  SizedBox(height: mediaWidth * (30 / 852)),
                  Text(
                    '일시: 2024.06.27 / 14:27 \n거리: 1.5km',
                    style: medium15.copyWith(fontSize: mediaWidth * (15 / 393)),
                  ),
                  SizedBox(height: mediaWidth * (30 / 852)),
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
                        style: medium13.copyWith(
                            fontSize: mediaWidth * (13 / 393)),
                      ),
                    ),
                  ),
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
              width: width,
              height: height,
            ),
          ),
          const SizedBox(height: 8),
          Text(name, style: regular15),
        ],
      ),
    );
  }
}
