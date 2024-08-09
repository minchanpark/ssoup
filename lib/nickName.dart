import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'theme/color.dart';

class NickNamePage extends StatefulWidget {
  const NickNamePage({super.key});

  @override
  State<NickNamePage> createState() => _NickNamePageState();
}

class _NickNamePageState extends State<NickNamePage> {
  TextEditingController nickNameController = TextEditingController();
  bool nickName = false;

  @override
  void initState() {
    super.initState();
    nickNameController.addListener(_checkNickNameInput);
  }

  void _checkNickNameInput() {
    setState(() {
      nickName = nickNameController.text.isNotEmpty;
    });
  }

  Future<void> addNickNameToFirestore(String nickName) async {
    final firebase_auth.User? user =
        firebase_auth.FirebaseAuth.instance.currentUser;

    if (user != null) {
      final CollectionReference users =
          FirebaseFirestore.instance.collection('user');
      final DocumentSnapshot snapshot = await users.doc(user.uid).get();

      if (snapshot.exists) {
        final updatedUserData = {'nickName': nickName};
        await users.doc(user.uid).update(updatedUserData);
        print('Nickname updated in Firestore: $updatedUserData');
      } else {
        final newUserData = {
          'uid': user.uid,
          'nickName': nickName,
        };
        await users.doc(user.uid).set(newUserData);
        print('New user data with nickname added to Firestore: $newUserData');
      }
    } else {
      print('No user is currently signed in.');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: screenWidth * (25 / 393),
                top: screenHeight * (110 / 852),
                bottom: screenHeight * (26 / 852),
                right: screenWidth * (43.6 / 393),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "닉네임 설정",
                    style: TextStyle(
                      fontFamily: 'SCDream5',
                      fontSize: 18,
                      color: AppColor.mainText,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "한번 설정한 닉네임은 수정할 수 없으니 신중하게 설정하세요!",
                    style: TextStyle(
                      fontFamily: 'SCDream3',
                      fontSize: 12,
                      color: Color(0xFF000000),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: SizedBox(
                width: 250,
                height: 38,
                child: TextFormField(
                  controller: nickNameController,
                  cursorColor: Colors.blue,
                  textAlign: TextAlign.start,
                  cursorHeight: 15,
                  style: const TextStyle(
                    fontSize: 15.0,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    hintText: "사용할 닉네임을 입력하세요",
                    hintStyle: const TextStyle(
                      fontSize: 11,
                      fontFamily: 'SCDream3',
                      color: AppColor.mainText,
                      fontWeight: FontWeight.w300,
                      letterSpacing: -0.32,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * (191.78 / 852),
            ),
            Image.asset(
              "assets/nickname_fish.png",
              width: screenWidth * (127.225 / 393),
              height: screenHeight * (167.221 / 852),
            ),
            SizedBox(
              height: screenHeight * (73 / 852),
            ),
            Opacity(
              opacity: nickName ? 1.0 : 0.6,
              child: ElevatedButton(
                onPressed: nickName
                    ? () {
                        addNickNameToFirestore(nickNameController.text);
                        Navigator.pushNamed(context, '/home_page');
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: AppColor.button,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  fixedSize: Size(
                    screenWidth * (277 / 393),
                    screenHeight * (57 / 852),
                  ),
                ),
                child: const Center(
                  child: Text(
                    "시작하기",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColor.white,
                      fontSize: 16,
                      fontFamily: 'SCDream5',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * (65 / 852),
            ),
            const Text(
              "버전 0.1",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w300,
                letterSpacing: -0.32,
                fontFamily: 'SCDream3',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
