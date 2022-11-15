import 'package:appchat/screens/Auth.screen.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthStore {
  static final _auth = FirebaseAuth.instance;

  static Future<User?> signIn(
      {required String email, required String password}) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (error) {
      print(error.code);
      rethrow;
    }
  }

  // static

  static Future<User?> currentUser() async {
    return _auth.currentUser;
  }

  static User? get user {
    User? user = _auth.currentUser;
    if (user != null) {
      return user;
    }
    return null;
  }

  static String? get photoUrl {
    User? user = _auth.currentUser;
    if (user != null) {
      final photo = user.photoURL;
      return photo;
    }
    return '';
  }

  static String? get displayName {
    User? user = _auth.currentUser;
    if (user != null) {
      final displayName = user.displayName;
      return displayName ?? (user.email ?? 'Display Name');
    }
    return 'Display Name';
  }

  static Future<void> signOut(context) async {
    await _auth.signOut();
    Navigator.of(context).pushReplacementNamed(AuthScreen.id);
  }

  static Future signUp({
    required String email,
    String displayName = '',
    String photoURL =
        'https://firebasestorage.googleapis.com/v0/b/flutter-myshop-65ece.appspot.com/o/icon-user-default.png?alt=media&token=b8d473a9-9d76-40b3-96be-ab52e0acf1e5',
    required String password,
  }) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;
      await user?.updateDisplayName(displayName);
      await user?.updatePhotoURL(photoURL);
      return user;
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
      rethrow;
    }
  }
}
