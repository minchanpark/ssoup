import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' as kakao;
import 'package:ssoup/home.dart';

Future<void> addUserToFirestore(
    firebase_auth.User user, String email, String name,
    {String? statusMessage}) async {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('user');
  final DocumentSnapshot snapshot = await users.doc(user.uid).get();

  if (snapshot.exists) {
    final updatedUserData = {
      'email': email,
      'name': name,
    };
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
    };
    await users.doc(user.uid).set(newUserData);
    print('New user data added to Firestore: $newUserData');
  }
}

Future<firebase_auth.UserCredential> signInWithKakao() async {
  try {
    kakao.OAuthToken? token;
    try {
      // Attempt login with Kakao account
      token = await kakao.UserApi.instance.loginWithKakaoAccount();
      print('Kakao login successful: ${token.accessToken}');
    } catch (error) {
      print('Kakao login failed: $error');
      throw firebase_auth.FirebaseAuthException(
        code: 'ERROR_KAKAO_LOGIN_FAILED',
        message: 'Failed to login with Kakao: $error',
      );
    }

    // Fetch Kakao user information
    kakao.User kakaoUser = await kakao.UserApi.instance.me();
    String email = kakaoUser.kakaoAccount?.email ?? '';
    String name = kakaoUser.kakaoAccount?.profile?.nickname ?? '';

    // Authenticate with Firebase using Kakao access token
    var credential =
        firebase_auth.OAuthProvider("oidc.oidc.kakao.com").credential(
      accessToken: token!.accessToken,
      idToken: token.idToken,
    );

    // Sign in with Firebase
    final firebase_auth.UserCredential userCredential = await firebase_auth
        .FirebaseAuth.instance
        .signInWithCredential(credential);
    final firebase_auth.User user = userCredential.user!;

    print('Firebase user authenticated: ${user.uid}');

    // Store user information in Firestore
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
  late firebase_auth.User? currentUser =
      firebase_auth.FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    await firebase_auth.FirebaseAuth.instance.signOut();
  }

  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  if (googleUser == null) {
    throw firebase_auth.FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
  }

  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final credential = firebase_auth.GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  final userCredential = await firebase_auth.FirebaseAuth.instance
      .signInWithCredential(credential);
  final firebase_auth.User user = userCredential.user!;
  await addUserToFirestore(user, user.email!, user.displayName!);
  return userCredential;
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      print('Kakao login error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kakao login failed: $e')),
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
