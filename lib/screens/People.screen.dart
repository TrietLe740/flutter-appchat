import 'dart:async';

import 'package:appchat/screens/chat/Conversation.dart';
import 'package:appchat/stores/AuthManager.dart';
import 'package:appchat/stores/ChatManager.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../utils/data.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({Key? key}) : super(key: key);

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  List PeopleList = [];
  late StreamSubscription<DatabaseEvent> ref;

  @override
  void initState() {
    try {
      ref = FirebaseDatabase.instance
          .ref("users")
          .onValue
          .listen((DatabaseEvent event) async {
        final data = event.snapshot.value as dynamic;
        final uid = AuthManager.user!.uid;
        print(data);
        List fectList = [];
        data.keys.forEach((key) {
          print(data[key]['isOnline']);
          if (key != 'user-$uid') {
            fectList.add({
              'userId': key,
              'photoUrl': data[key]['photoUrl'],
              'displayName': data[key]['displayName'],
              'email': data[key]['email'],
              'isAccept': true,
              'isOnline': data[key]['isOnline'],
              'status': data[key]['status'],
            });
          }
        });

        setState(() {
          PeopleList = fectList;
          print(PeopleList);
        });
        print('----------fetch People');
        print(data);
        // print(chatItems);
      });
    } catch (error) {
      print(error);
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    print('-------------------People dispose');
    ref.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragDown: (details) =>
          {FocusScope.of(context).requestFocus(FocusNode())},
      child: Scaffold(
        appBar: AppBar(
          title: const TextField(
            decoration: InputDecoration.collapsed(
              hintText: 'Search',
            ),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.filter_list,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: ListView.separated(
          padding: const EdgeInsets.all(10),
          separatorBuilder: (BuildContext context, int index) {
            return Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 0.5,
                width: MediaQuery.of(context).size.width / 1.3,
                child: const Divider(),
              ),
            );
          },
          itemCount: PeopleList.length,
          itemBuilder: (BuildContext context, int index) {
            Map people = PeopleList[index];
            return Padding(
              padding: const EdgeInsets.only(left: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: people['photoUrl'] != null
                      ? NetworkImage(people['photoUrl'] as String)
                      : const AssetImage('assets/images/noImageAvailable.png')
                          as ImageProvider,
                  radius: 25,
                ),
                contentPadding: const EdgeInsets.all(0),
                title: Text(people['displayName']),
                subtitle:
                    people['status'] != null ? Text(people['status']) : null,
                trailing: TextButton(
                  style: const ButtonStyle(
                      // backgroundColor: MaterialStateProperty.all(Colors.blue)
                      ),
                  child: const Icon(
                    Icons.chat_bubble,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    print('Add chat');
                    ChatManager()
                        .addChatItems(
                          sendTo: '${people['userId']}',
                        )
                        .then((chatItemId) => {
                              Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return Conversation(
                                      chatItemId: chatItemId,
                                      avatar: '${people['photoUrl']}',
                                      name: '${people['displayName']}',
                                      isOnline: people['isOnline'] == true,
                                    );
                                  },
                                ),
                              )
                            });
                    //
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
