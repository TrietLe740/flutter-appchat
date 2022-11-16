import 'package:appchat/screens/Auth.screen.dart';
import 'package:appchat/utils/data.dart';
import 'package:firebase_database/firebase_database.dart';
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
      final uid = result.user?.uid;
      await FirebaseDatabase.instance
          .ref('/users/user-$uid/photoUrl')
          .set(user?.photoURL);
      await FirebaseDatabase.instance
          .ref('/users/user-$uid/displayName')
          .set(user?.displayName);
      await FirebaseDatabase.instance
          .ref('/users/user-$uid/isOnline')
          .set(true);
      await FirebaseDatabase.instance
          .ref('/users/user-$uid/email')
          .set(user?.displayName);
      await FirebaseDatabase.instance
          .ref('/users/user-$uid/displayName')
          .set(user?.displayName);
      return result.user;
    } on FirebaseAuthException catch (error) {
      print(error.code);
      rethrow;
    }
  }

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
    final uid = _auth.currentUser?.uid;
    print(uid);
    await _auth.signOut();
    await FirebaseDatabase.instance.ref('/users/user-$uid/isOnline').set(false);
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
      final Map<String, Map> updates = {};
      final newUser = {
        'email': user?.email,
        'displayName': displayName,
        'status': '',
        'isOnline': true,
        'photoUrl': photoURL,
      };
      print(newUser);
      updates['/users/user-${user?.uid}'] = newUser;

      await FirebaseDatabase.instance.ref().update(updates);
      return user;
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
      rethrow;
    }
  }
}
