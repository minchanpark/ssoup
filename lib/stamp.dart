import 'package:flutter/material.dart';

class StampPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffA3C2FF),
        title: Image.asset('assets/6/ssoup.png', width: 77, height: 77),
      ),
      body: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.elliptical(200, 70),
              bottomRight: Radius.elliptical(200, 70),
            ),
            child: Container(
              color: Color(0xffA3C2FF),
              height: 200,
              child: Row(
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
                StampItem(name: '무꼬기', image: 'assets/images/example.png'),
                StampItem(name: '꽃부기', image: 'assets/images/example.png'),
                StampItem(name: '베비샤크', image: 'assets/images/example.png'),
                StampItem(name: '타꼬', image: 'assets/images/example.png'),
                StampItem(name: '꾸래미', image: 'assets/images/example.png'),
                StampItem(name: '젤리꼬기', image: 'assets/images/example.png'),
                StampItem(name: '', image: 'assets/images/example.png'),
                StampItem(name: '', image: 'assets/images/example.png'),
                StampItem(name: '완주!', image: 'assets/images/example.png'),
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

  StampItem({required this.name, required this.image});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage(image),
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
