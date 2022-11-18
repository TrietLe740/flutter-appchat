// ignore_for_file: avoid_print

import 'dart:async';
import 'package:appchat/stores/AuthStore.dart';
import 'package:appchat/utils/data.dart';
import 'package:appchat/widgets/ChatItem.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class ChatManager with ChangeNotifier {
  static final FirebaseDatabase database = FirebaseDatabase.instance;
  String change = 'adasd';
  List<ChatItem> chatItems = [];
  late StreamSubscription<DatabaseEvent> ref;
  Future<void> test() async {}

  Future<void> fetchChatItemsDetail(data) async {
    // final List<ChatItem> chatItems = [];
    var chatItem;
    var fetchUser, fetchChatItem;
    var user;
    try {
      final uid = AuthStore.user!.uid;
      if (data != null) {
        final ref = FirebaseDatabase.instance.ref();
        print(data);
        chatItems = [];
        data.keys.forEach((sendToId) async {
          if (sendToId != 'lastActive') {
            var chatItemId = data[sendToId]['chatItemId'];
            ref
                .child('chatItems/$chatItemId')
                .get()
                .then((fetchChatItem) async {
              ref.child('users/$sendToId').get().then((fetchUser) {
                if (fetchUser.exists && fetchChatItem.exists) {
                  user = fetchUser.value!;
                  chatItem = fetchChatItem.value!;
                  // print(sendToId);
                  // print(user);
                  chatItemId = data[sendToId]['chatItemId'];
                  // print(chatItemId);
                  // DateTime tempDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS")
                  //     .parse(chatItem['time']);
                  chatItems.add(ChatItem(
                    chatItemId: chatItemId,
                    avatar: user['photoUrl'],
                    name: user['displayName'],
                    time: chatItem['time'],
                    lastMsg: chatItem['lastMsg'],
                    lastSentUser: chatItem['lastSentUser'],
                    isOnline: user['isOnline'] == true,
                    counter: random.nextInt(20),
                  ));
                } else {
                  print('No data available.');
                }
                print('??????????');
                notifyListeners();
              });
            });
          } else {
            print("!data.containsKey('lastActive");
          }
        });
      }

      // print(data);
    } catch (error) {
      print(error);
    }
  }

  Future<void> fetchChatItems([bool filterByUser = false]) async {
    chatItems = [];

    try {
      final uid = AuthStore.user!.uid;
      ref = FirebaseDatabase.instance
          .ref("userChats/user-$uid")
          .onValue
          .listen((DatabaseEvent event) async {
        final data = event.snapshot.value;
        print('-----fetchChatItems');
        // print(data);
        await fetchChatItemsDetail(data);
        // print(chatItems);
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> disposeFetchChatItems() async {
    print('------------------disposeFetchChatItems');
    ref.cancel();
  }

  Future<String> addChatItems({
    sendTo,
  }) async {
    try {
      final uid = AuthStore.user!.uid;
      final data = await FirebaseDatabase.instance
          .ref('/userChats/user-$uid/$sendTo')
          .get();
      var userChat;
      if (data.exists) {
        userChat = data.value!;
        print('sendTo exist');
        return userChat['chatItemId'];
      } else {
        final timeNow = DateTime.now().toIso8601String() as dynamic;
        final newChatKey =
            FirebaseDatabase.instance.ref().child('chatItems').push().key;
        final newMsgKey = FirebaseDatabase.instance
            .ref()
            .child('chatMeassages/chat$newChatKey')
            .push()
            .key;
        const message = 'Hi!';
        final chatItemsData = {
          'time': timeNow,
          'lastMsg': message,
          'lastSentUser': 'user-$uid'
        };
        final chatItemsUserData = {
          'chatItemId': 'chat$newChatKey',
          'unRead': random.nextInt(10)
        };

        final newMessage = {
          'message': message,
          'time': DateTime.now().toIso8601String(),
          'sentBy': 'user-$uid'
        };

        // Write the new post's data simultaneously in the posts list and the
        // user's post list.
        final Map<String, Map> updates = {};
        updates['/chatItems/chat$newChatKey'] = chatItemsData;
        updates['/userChats/user-$uid/$sendTo'] = chatItemsUserData;
        updates['/userChats/$sendTo/user-$uid'] = chatItemsUserData;
        updates['/chatMessages/chat$newChatKey/msg$newMsgKey'] = newMessage;

        FirebaseDatabase.instance.ref().update(updates);
        FirebaseDatabase.instance
            .ref('/userChats/$sendTo/lastActive')
            .set(timeNow);
        FirebaseDatabase.instance
            .ref('/userChats/user-$uid/lastActive')
            .set(timeNow);
        return 'chat$newChatKey';
      }
    } catch (error) {
      print('fetch chatItems');
      print(error);
    }
    return '';
  }

  int get count {
    return chatItems.length;
  }

  List<ChatItem> get items {
    return [...chatItems];
  }

  static void addChatMessages(
      String? message, String sentBy, String chatItemsKey) async {
    final uid = AuthStore.user!.uid;
    final timeNow = DateTime.now().toIso8601String() as dynamic;
    // message ??= messages[random.nextInt(10)];
    if (message == '') return;

    final newMessage = {
      'message': message,
      'time': timeNow,
      'sentBy': 'user-$uid',
      'type': 'text'
    };
    final newMsgKey = FirebaseDatabase.instance
        .ref()
        .child('chatMeassages/chat$chatItemsKey')
        .push()
        .key;
    final Map<String, Map> updates = {};
    updates['/chatMessages/$chatItemsKey/$newMsgKey'] = newMessage;
    FirebaseDatabase.instance
        .ref('/chatItems/$chatItemsKey/lastMsg')
        .set(message);
    FirebaseDatabase.instance.ref('/chatItems/$chatItemsKey/time').set(timeNow);
    FirebaseDatabase.instance
        .ref('/userChats/user-$uid/lastActive')
        .set(timeNow);
    FirebaseDatabase.instance
        .ref('/chatItems/$chatItemsKey/lastSentUser')
        .set('user-$uid');

    return FirebaseDatabase.instance.ref().update(updates);
    // notifyListeners();
  }

  List<ChatItem> filterByName(String filterString) {
    List<ChatItem> filter = [];
    filter.addAll(chatItems);
    filter.retainWhere((chatItem) {
      return chatItem.name.toLowerCase().contains(filterString.toLowerCase());
    });
    return filter;
  }
}
