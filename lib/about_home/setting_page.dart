import 'package:flutter/material.dart';
import 'package:ssoup/theme/text.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    double appWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          '설정',
          style: medium20.copyWith(
            fontSize: (20 / 393) * appWidth,
            height: 0.05,
            letterSpacing: -0.32,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // 계정 섹션
          buildSectionHeader('계정'),
          buildSettingsItem('프로필 수정'),
          const Divider(height: 3),
          buildSettingsItem('비밀번호 변경'),
          const Divider(height: 3),
          buildSettingsItem('푸쉬 알림 설정'),
          const Divider(height: 3),
          buildSettingsItem('개인 정보 처리 방침'),

          // 고객 지원 섹션
          buildSectionHeader('고객 지원'),
          buildSettingsItem('공지사항'),
          const Divider(height: 3),
          buildSettingsItem('자주 듣는 질문'),
          const Divider(height: 3),
          buildSettingsItem('문의하기'),

          // 기타 섹션
          buildSectionHeader('기타'),
          buildSettingsItem('로그아웃'),
          const Divider(height: 3),
        ],
      ),
    );
  }

  // 섹션 헤더 빌드 함수
  Widget buildSectionHeader(String title) {
    return Container(
      height: 54,
      color: const Color(0xFFB0DBFD),
      width: double.infinity,
      child: Row(
        children: [
          const SizedBox(width: 25),
          Text(
            title,
            style: bold15.copyWith(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              height: 0.09,
              letterSpacing: -0.32,
            ),
          ),
        ],
      ),
    );
  }

  // 설정 아이템 빌드 함수
  Widget buildSettingsItem(String title) {
    return ListTile(
      title: Row(
        children: [
          SizedBox(width: 10),
          Text(
            title,
            style: medium16.copyWith(
              fontSize: 17,
              height: 0.11,
              letterSpacing: -0.32,
            ),
          ),
        ],
      ),
      onTap: () {
        // 각 아이템 클릭 시 행동 정의
      },
    );
  }
}
