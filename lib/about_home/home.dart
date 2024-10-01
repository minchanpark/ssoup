import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:ssoup/about_home/setting_page.dart';
import 'package:ssoup/theme/text.dart';
import 'custom_progress_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double appWidth = MediaQuery.of(context).size.width;
    double appHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Row(
          children: [
            const SizedBox(width: 10),
            Text(
              '내가 그린 울릉(로고)',
              style: medium20.copyWith(
                fontSize: 20,
                height: 0.21,
                letterSpacing: -0.32,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsPage()));
            },
            icon: SvgPicture.asset(
              'assets/setting_line_light.svg',
              width: 33,
              height: 33,
            ),
          ),
          SizedBox(width: (10 / 393) * appWidth),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: (22 / 934) * appHeight),
            const CustomProgressBar(),
            Image.asset('assets/ul.png'),
            // 버튼 섹션
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: (16.0 / 393) * appWidth),
              child: Column(
                children: [
                  // 울릉도 관광명소 버튼
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      overlayColor: Colors.white,
                      backgroundColor: const Color(0xff8ECCFC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {},
                    child: SizedBox(
                      width: 342,
                      height: 84,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/map_svg.svg',
                                width: 29.08,
                                height: 34.58,
                              ),
                              const SizedBox(width: 17),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '울릉도 관광명소',
                                    style: medium15.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/arrow.png',
                                        width: 14,
                                        height: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '관광지 100곳',
                                        style: regular10.copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w200,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            width: 76,
                            height: 26,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '관광하기',
                                style: medium13.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  height: 0.21,
                                  letterSpacing: -0.32,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: (19 / 934) * appHeight),
                  // 울릉도 플로깅 버튼
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      overlayColor: Colors.blue,
                      side: const BorderSide(color: Color(0xff79BFF4)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {},
                    child: SizedBox(
                      width: 342,
                      height: 84,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Iconify(Ph.person_simple_walk_light, size: 34),
                              const SizedBox(width: 17),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '울릉도 플로깅',
                                    style: medium15.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/happy.png',
                                        width: 14,
                                        height: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '플로깅 인증하고 선물받기',
                                        style: regular10.copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w200,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            width: 76,
                            height: 26,
                            decoration: ShapeDecoration(
                              color: const Color(0xff8ECCFC),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '플로깅하기',
                                style: medium13.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  height: 0.21,
                                  letterSpacing: -0.32,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: (42 / 934) * appHeight),
          ],
        ),
      ),
    );
  }
}
