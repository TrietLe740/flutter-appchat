import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class MessageService {
  static const String _collection = 'test';
  // static final  _firestore = FirebaseDatabase.instance;
  static final FirebaseDatabase database = FirebaseDatabase.instance;
  static final DatabaseReference ref2 =
      FirebaseDatabase.instance.ref('ChatMessages');
  static final DatabaseReference ref = FirebaseDatabase.instance.ref("test");

  static Future sendMessage({
    required String message,
    required String senderId,
  }) async {
    try {
      await ref.set({
        'senderId': senderId,
        'message': message,
        'time': 'hjkhjkhk',
      });
    } catch (error) {
      print('loi neeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
      print(error);
      rethrow;
    }
  }

  static Future test() async {
    try {
      ref2.onValue.listen((DatabaseEvent event) {
        final data = event.snapshot.value;
        print(data);
      });
    } catch (error) {
      print('loi neeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
      print(error);
      rethrow;
    }
  }
  // static Stream<QuerySnapshot> messageStream() {

  //   // return _firestore
  //   //     .collection(_collection)
  //   //     .orderBy('time', descending: true)
  //   //     .snapshots();
  // }
}
