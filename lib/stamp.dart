import 'package:flutter/material.dart';

import 'theme/text.dart';

class StampPage extends StatelessWidget {
  const StampPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xffA3C2FF),
        title: Image.asset('assets/6/ssoup.png', width: 77, height: 77),
      ),
      body: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.elliptical(200, 70),
              bottomRight: Radius.elliptical(200, 70),
            ),
            child: Container(
              color: const Color(0xffA3C2FF),
              height: 200,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                '김한동님의 스탬프 모아보기',
                                style: bold23.copyWith(color: Colors.white),
                              ),
                            ),
                            Center(
                              child: Text(
                                '2024.07.05',
                                style: regular15.copyWith(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/aaa.png',
                        width: 150,
                      ),
                      Image.asset(
                        'assets/mugogi.png',
                        width: 100,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              padding: const EdgeInsets.all(16),
              children: const [
                StampItem(
                  name: '무꼬기',
                  image: 'assets/stamp_fish1.png',
                  width: 179,
                  height: 179,
                ),
                StampItem(
                  name: '꽃부기',
                  image: 'assets/stamp_fish2.png',
                  width: 144,
                  height: 144,
                ),
                StampItem(
                  name: '베비샤크',
                  image: 'assets/stamp_fish3.png',
                  width: 165,
                  height: 165,
                ),
                StampItem(
                  name: '타꼬',
                  image: 'assets/stamp_fish4.png',
                  width: 119,
                  height: 119,
                ),
                StampItem(
                  name: '꾸래미',
                  image: 'assets/stamp_fish5.png',
                  width: 164,
                  height: 164,
                ),
                StampItem(
                  name: '젤리꼬기',
                  image: 'assets/stamp_fish6.png',
                  width: 126,
                  height: 126,
                ),
                StampItem(
                  name: '',
                  image: 'assets/stamp_fish6.png',
                  width: 144,
                  height: 144,
                ),
                StampItem(
                  name: '',
                  image: 'assets/stamp_fish6.png',
                  width: 144,
                  height: 144,
                ),
                StampItem(
                  name: '',
                  image: 'assets/stamp_fish6.png',
                  width: 144,
                  height: 144,
                ),
                StampItem(
                  name: '',
                  image: 'assets/stamp_fish6.png',
                  width: 144,
                  height: 144,
                ),
                StampItem(
                  name: '',
                  image: 'assets/stamp_fish6.png',
                  width: 144,
                  height: 144,
                ),
                StampItem(
                  name: '',
                  image: 'assets/complete.png',
                  width: 58,
                  height: 21,
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
                name + ' 스탬프',
                style: extrabold24.copyWith(color: const Color(0xff1E528E)),
              )),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 280,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: const Color(0xffEEF4FF),
                    ),
                    child: Image.asset(
                      image,
                      width: (width / 393) * mediaWidth,
                      height: (height / 852) * mediaHeight,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    '봉래폭포 플로깅 완료',
                    style: medium16,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    '일시: 2024.06.27 / 14:27 \n거리: 1.5km',
                    style: medium15,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: 280,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xffA3C2FF)),
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: const Center(
                        child: Text(
                      '10마리의 해양생물이 고마워하고 있어요!',
                      style: medium13,
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
