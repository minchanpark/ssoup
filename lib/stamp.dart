import 'package:flutter/material.dart';

void main() {
  runApp(StampPage());
}

class StampPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: StampCollectionScreen(),
      ),
    );
  }
}

class StampCollectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 30),
          Container(
            width: 596,
            height: 446,
            decoration: BoxDecoration(
                color: const Color(0xFFE6F0FF),
                borderRadius: BorderRadius.circular(596)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.arrow_back_ios)),
                    Image.asset(
                      'assets/6/ssoup.png',
                      width: 77,
                      height: 77,
                    ),
                    SizedBox(width: 24), // Placeholder for alignment
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '김한동님의 스탬프 모아보기',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Text(
                  '2024.06.27',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Image.asset('assets/images/example.png', height: 80),
                const SizedBox(height: 8),
                const Text(
                  '플로깅 인증하고 스탬프를 모아\n제 친구들을 구해주세유!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
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
