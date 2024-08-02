import 'package:flutter/material.dart';

import 'theme/color.dart';
import 'theme/text.dart';

class StampPage extends StatelessWidget {
  const StampPage({super.key});

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
                      '2024.07.05',
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
              children: [
                StampItem(
                  name: '무꼬기',
                  image: 'assets/stamp_fish1.png',
                  width: screenWidth * (179 / 393),
                  height: screenHeight * (179 / 852),
                ),
                StampItem(
                  name: '꽃부기',
                  image: 'assets/stamp_fish2.png',
                  width: screenWidth * (144 / 393),
                  height: screenHeight * (144 / 852),
                ),
                StampItem(
                  name: '베비샤크',
                  image: 'assets/stamp_fish3.png',
                  width: screenWidth * (165 / 393),
                  height: screenHeight * (165 / 852),
                ),
                StampItem(
                  name: '타꼬',
                  image: 'assets/stamp_fish4.png',
                  width: screenWidth * (119 / 393),
                  height: screenHeight * (119 / 852),
                ),
                StampItem(
                  name: '꾸래미',
                  image: 'assets/stamp_fish5.png',
                  width: screenWidth * (164 / 393),
                  height: screenHeight * (164 / 852),
                ),
                StampItem(
                  name: '젤리꼬기',
                  image: 'assets/stamp_fish6.png',
                  width: screenWidth * (126 / 393),
                  height: screenHeight * (126 / 852),
                ),
                StampItem(
                  name: '',
                  image: 'assets/stamp_fish6.png',
                  width: screenWidth * (144 / 393),
                  height: screenHeight * (144 / 852),
                ),
                StampItem(
                  name: '',
                  image: 'assets/stamp_fish6.png',
                  width: screenWidth * (144 / 393),
                  height: screenHeight * (144 / 852),
                ),
                StampItem(
                  name: '',
                  image: 'assets/stamp_fish6.png',
                  width: screenWidth * (144 / 393),
                  height: screenHeight * (144 / 852),
                ),
                StampItem(
                  name: '',
                  image: 'assets/stamp_fish6.png',
                  width: screenWidth * (144 / 393),
                  height: screenHeight * (144 / 852),
                ),
                StampItem(
                  name: '',
                  image: 'assets/stamp_fish6.png',
                  width: screenWidth * (144 / 393),
                  height: screenHeight * (144 / 852),
                ),
                StampItem(
                  name: '',
                  image: 'assets/complete.png',
                  width: screenWidth * (58 / 393),
                  height: screenHeight * (21 / 852),
                ),
              ],
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
  final double width;
  final double height;

  const StampItem({
    super.key,
    required this.name,
    required this.image,
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
                    child: Image.asset(
                      image,
                      width: width,
                      height: height,
                    ),
                  ),
                  SizedBox(
                    height: mediaWidth * (30 / 852),
                  ),
                  Text(
                    '봉래폭포 플로깅 완료',
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
            child: Image.asset(
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
