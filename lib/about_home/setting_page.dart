import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ssoup/theme/text.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String nickName = '';
  Future<void> fetchNickName() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('user').doc(uid).get();

      nickName = userDoc['nickName'];
      setState(() {});
    } catch (e) {
      print('Error fetching nickName data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNickName();
  }

  @override
  Widget build(BuildContext context) {
    double appWidth = MediaQuery.of(context).size.width;
    double appHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          '설정',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 프로필 섹션
            Padding(
              padding: EdgeInsets.only(
                left: (25 / 393) * appWidth,
                top: (14 / 852) * appHeight,
                bottom: (34 / 852) * appHeight,
              ),
              child: Row(
                children: [
                  Container(
                    width: 65,
                    height: 65,
                    decoration: const ShapeDecoration(
                      color: Color(0xFFD9D9D9),
                      shape: OvalBorder(),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$nickName 님',
                    style: medium15.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 0.14,
                      letterSpacing: -0.32,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(thickness: 1, height: 2, color: Color(0xffB1B1B1)),

            // 메뉴 항목 리스트
            Column(
              children: [
                _buildMenuItem('서비스 이용약관', 0),
                const Divider(
                    thickness: 1, height: 2, color: Color(0xffB1B1B1)),
                _buildMenuItem('개인정보 처리방침', 1),
                const Divider(
                    thickness: 1, height: 2, color: Color(0xffB1B1B1)),
                _buildMenuItem('푸쉬 알림 설정', 2),
                const Divider(
                    thickness: 1, height: 2, color: Color(0xffB1B1B1)),
                _buildMenuItem('로그아웃', 3),
                const Divider(
                    thickness: 1, height: 2, color: Color(0xffB1B1B1)),
                _buildMenuItem('회원탈퇴', 4),
                const Divider(
                    thickness: 1, height: 2, color: Color(0xffB1B1B1)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 메뉴 항목을 쉽게 만들기 위한 헬퍼 함수
  Widget _buildMenuItem(String title, int index) {
    return ListTile(
      title: Text(
        title,
        style: medium16.copyWith(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          height: 0.11,
          letterSpacing: -0.32,
        ),
      ),
      onTap: () {
        // 메뉴 항목을 눌렀을 때의 동작을 여기에 추가하세요.
      },
    );
  }
}
