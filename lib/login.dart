import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' as kakao;
import 'package:ssoup/home_navigationbar.dart';
import 'home.dart';
import 'nick_name.dart';
import 'theme/text.dart';

Future<void> addUserToFirestore(
    firebase_auth.User user, String email, String name) async {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('user');
  final DocumentSnapshot snapshot = await users.doc(user.uid).get();

  if (snapshot.exists) {
    final updatedUserData = {'email': email, 'name': name};
    await users.doc(user.uid).update(updatedUserData);
    print('User data updated in Firestore: $updatedUserData');
  } else {
    final newUserData = {
      'uid': user.uid,
      'email': email,
      'name': name,
      'totalSpot': 0,
      'totalStamp': 0,
      'totalKm': 0.0,
      'nickName': '',
      'stampId': '',
    };
    await users.doc(user.uid).set(newUserData);
    print('New user data added to Firestore: $newUserData');
  }
}

Future<firebase_auth.UserCredential> signInWithKakao() async {
  try {
    final kakao.OAuthToken token =
        await kakao.UserApi.instance.loginWithKakaoAccount();
    print('Kakao login successful: ${token.accessToken}');

    final kakao.User kakaoUser = await kakao.UserApi.instance.me();
    final String email = kakaoUser.kakaoAccount?.email ?? '';
    final String name = kakaoUser.kakaoAccount?.profile?.nickname ?? '';

    final credential =
        firebase_auth.OAuthProvider("oidc.oidc.kakao.com").credential(
      accessToken: token.accessToken,
      idToken: token.idToken,
    );

    final userCredential = await firebase_auth.FirebaseAuth.instance
        .signInWithCredential(credential);
    final firebase_auth.User user = userCredential.user!;

    print('Firebase user authenticated: ${user.uid}');
    await addUserToFirestore(user, email, name);

    return userCredential;
  } catch (error) {
    print("Kakao login failed: $error");
    throw firebase_auth.FirebaseAuthException(
      code: 'ERROR_KAKAO_LOGIN_FAILED',
      message: 'Failed to login with Kakao: $error',
    );
  }
}

Future<firebase_auth.UserCredential> signInWithGoogle() async {
  try {
    await firebase_auth.FirebaseAuth.instance.signOut();
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      throw firebase_auth.FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final credential = firebase_auth.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await firebase_auth.FirebaseAuth.instance
        .signInWithCredential(credential);
    final firebase_auth.User user = userCredential.user!;
    await addUserToFirestore(user, user.email!, user.displayName!);

    return userCredential;
  } catch (error) {
    print("Google login failed: $error");
    throw firebase_auth.FirebaseAuthException(
      code: 'ERROR_GOOGLE_LOGIN_FAILED',
      message: 'Failed to login with Google: $error',
    );
  }
}

Future<bool> checkNickname(firebase_auth.User user) async {
  final DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection('user').doc(user.uid).get();

  if (snapshot.exists && snapshot.data() != null) {
    return snapshot['nickName'] != '';
  }
  return false;
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  void _showLoading(bool show) {
    setState(() {
      _isLoading = show;
    });
  }

  Future<void> _signInWithGoogle() async {
    _showLoading(true);
    try {
      final userCredential = await signInWithGoogle();
      final user = userCredential.user!;
      final hasNickname = await checkNickname(user);

      if (hasNickname) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const HomePageNavigationBar()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NickNamePage()),
        );
      }
    } catch (e) {
      print('Google login error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google login failed: $e')),
      );
    } finally {
      _showLoading(false);
    }
  }

  Future<void> _signInWithKakao() async {
    _showLoading(true);
    try {
      final userCredential = await signInWithKakao();
      final user = userCredential.user!;
      final hasNickname = await checkNickname(user);

      if (hasNickname) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const HomePageNavigationBar()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NickNamePage()),
        );
      }
    } catch (e) {
      print('Kakao login error: $e');
    } finally {
      _showLoading(false);
    }
  }

  static const LinearGradient homeMix = LinearGradient(
    colors: [
      Color.fromRGBO(138, 206, 255, 1),
      Color.fromRGBO(163, 194, 255, 1),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: homeMix,
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 234,
                    child: Image.asset('assets/logo.png'),
                  ),
                  const SizedBox(height: 40.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    onPressed: _isLoading ? null : _signInWithGoogle,
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 7,
                        ),
                        Image.asset(
                          'assets/google.png',
                          width: 25,
                        ),
                        const SizedBox(
                          width: 60,
                        ),
                        Text('구글 계정으로 시작하기',
                            style: regular15.copyWith(
                                color: const Color(0xff635546))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffFAE200),
                      elevation: 0,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    onPressed: _isLoading ? null : _signInWithKakao,
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/kakao.png',
                          height: 23,
                        ),
                        const SizedBox(
                          width: 53,
                        ),
                        Text('카카오 계정으로 시작하기',
                            style: regular15.copyWith(
                                color: const Color(0xff635546))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
