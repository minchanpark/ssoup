import 'package:flutter/material.dart';

class StampPage extends StatelessWidget {
  const StampPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: const Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            '김한동님의 스탬프 모아보기',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            '2024.06.27',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
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
                  image: 'assets/images/example.png',
                  width: 144,
                  height: 144,
                ),
                StampItem(
                  name: '',
                  image: 'assets/images/example.png',
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

  StampItem({
    super.key,
    required this.name,
    required this.image,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          child: Image.asset(
            image,
            width: width,
            height: height,
          ),
          //backgroundImage: AssetImage(image),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
