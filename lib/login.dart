import 'dart:convert';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' as kakao;
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:ssoup/home.dart';

import 'nick_name.dart';

/// Firestore에 사용자 정보를 추가하거나 업데이트하는 함수
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
      'nick_name': '',
    };
    await users.doc(user.uid).set(newUserData);
    print('New user data added to Firestore: $newUserData');
  }
}

/// 카카오 로그인을 처리하는 함수
Future<firebase_auth.UserCredential> signInWithKakao() async {
  try {
    final kakao.OAuthToken? token =
        await kakao.UserApi.instance.loginWithKakaoAccount();
    print('Kakao login successful: ${token?.accessToken}');

    final kakao.User kakaoUser = await kakao.UserApi.instance.me();
    final String email = kakaoUser.kakaoAccount?.email ?? '';
    final String name = kakaoUser.kakaoAccount?.profile?.nickname ?? '';

    final credential =
        firebase_auth.OAuthProvider("oidc.oidc.kakao.com").credential(
      accessToken: token?.accessToken,
      idToken: token?.idToken,
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

/// 구글 로그인을 처리하는 함수
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

/// Firestore에서 닉네임을 확인하는 함수
Future<bool> checkNickname(firebase_auth.User user) async {
  final DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection('user').doc(user.uid).get();

  if (snapshot.exists && snapshot.data() != null) {
    return snapshot['nick_name'] != '';
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
  String? accesToken;
  String? tokenType;

  void _showLoading(bool show) {
    setState(() {
      _isLoading = show;
    });
  }

  /// 네이버 로그인을 처리하는 함수
  Future<firebase_auth.UserCredential> signInWithNaver() async {
    try {
      final NaverLoginResult result = await FlutterNaverLogin.logIn();
      NaverAccessToken res = await FlutterNaverLogin.currentAccessToken;
      setState(() {
        accesToken = res.accessToken;
        tokenType = res.tokenType;
      });

      if (result.status == NaverLoginStatus.loggedIn) {
        final String accessToken = res.accessToken;
        final String email = result.account.email;
        final String name = result.account.name;

        final credential =
            firebase_auth.OAuthProvider("oidc.naver.com").credential(
          accessToken: accessToken,
        );

        final userCredential = await firebase_auth.FirebaseAuth.instance
            .signInWithCredential(credential);
        final firebase_auth.User user = userCredential.user!;

        print('Firebase user authenticated: ${user.uid}');
        await addUserToFirestore(user, email, name);

        return userCredential;
      } else {
        throw firebase_auth.FirebaseAuthException(
          code: 'ERROR_NAVER_LOGIN_FAILED',
          message: 'Failed to login with Naver',
        );
      }
    } catch (error) {
      print("Naver login failed: $error");
      throw firebase_auth.FirebaseAuthException(
        code: 'ERROR_NAVER_LOGIN_FAILED',
        message: 'Failed to login with Naver: $error',
      );
    }
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
          MaterialPageRoute(builder: (context) => const HomePage()),
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
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NickNamePage()),
        );
      }
    } catch (e) {
      print('Kakao login error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kakao login failed: $e')),
      );
    } finally {
      _showLoading(false);
    }
  }

  Future<void> _signInWithNaver() async {
    _showLoading(true);
    try {
      final userCredential = await signInWithNaver();
      final user = userCredential.user!;
      final hasNickname = await checkNickname(user);

      if (hasNickname) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NickNamePage()),
        );
      }
    } catch (e) {
      print('Naver login error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Naver login failed: $e')),
      );
    } finally {
      _showLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Welcome to Our App',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Please sign in to continue',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: _isLoading ? null : _signInWithGoogle,
                    child: const Text(
                      'Sign in with Google',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: _isLoading ? null : _signInWithKakao,
                    child: const Text(
                      'Sign in with Kakao',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: _isLoading ? null : _signInWithNaver,
                    child: const Text(
                      'Sign in with Naver',
                      style: TextStyle(fontSize: 18),
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
