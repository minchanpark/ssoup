import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ssoup/home.dart';

Future<void> addUserToFirestore(User user, {String? statusMessage}) async {
  final CollectionReference users = FirebaseFirestore.instance.collection('user');
  final DocumentSnapshot snapshot = await users.doc(user.uid).get();

  if (snapshot.exists) {
    final updatedUserData = {
      'email': user.email,
      'name': user.displayName,
      'status_message': statusMessage ?? 'I promise to take the test honestly before GOD.',
    };
    await users.doc(user.uid).update(updatedUserData);
  } else {
    final newUserData = {
      'uid': user.uid,
      'email': user.email,
      'name': user.displayName,
      'status_message': statusMessage ?? 'I promise to take the test honestly before GOD.',
    };
    await users.doc(user.uid).set(newUserData);
  }
}

Future<UserCredential> signInWithGoogle() async {
  late User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    await FirebaseAuth.instance.signOut();
  }

  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  if (googleUser == null) {
    throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
  }

  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
  final User user = userCredential.user!;
  await addUserToFirestore(user);
  return userCredential;
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
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
                  foregroundColor: Colors.white, backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Sign in with Google',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () async {
                  try {
                    final userCredential = await signInWithGoogle();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  } catch (e) {
                    print('Google 로그인 오류: $e');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
