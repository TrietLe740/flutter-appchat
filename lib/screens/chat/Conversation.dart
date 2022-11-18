import 'dart:async';
import 'dart:math';

import 'package:appchat/stores/AuthStore.dart';
import 'package:appchat/stores/ChatStore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:appchat/widgets/ChatBubble.dart';
import 'package:appchat/utils/data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class Conversation extends StatefulWidget {
  final String chatItemId;
  final String avatar;
  final String name;
  final bool isOnline;
  const Conversation({
    required this.chatItemId,
    required this.avatar,
    required this.name,
    required this.isOnline,
    super.key,
  });

  @override
  State<Conversation> createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  static Random random = Random();
  final uid = AuthStore.user!.uid;
  final sentMessageController = TextEditingController();

  String name = names[random.nextInt(10)];
  List MessageList = [];
  late StreamSubscription<DatabaseEvent> ref;

  @override
  void initState() {
    try {
      ref = FirebaseDatabase.instance
          .ref("chatMessages/${widget.chatItemId}")
          .onValue
          .listen((DatabaseEvent event) async {
        final data = event.snapshot.value as dynamic;
        List fectList = [];
        data.keys.forEach((key) => {
              fectList.add({
                'messageKey': key,
                'time': data[key]['time'],
                'message': data[key]['message'],
                'sentBy': data[key]['sentBy'],
              })
            });

        fectList.sort((a, b) => (b['time'].compareTo(a['time'])));
        setState(() {
          MessageList = fectList;
        });
        print('fetch Conversation: ${widget.chatItemId}');
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
    sentMessageController.dispose();
    ref.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        leading: IconButton(
          icon: const Icon(
            Icons.keyboard_backspace,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: buildAppBarTitle(),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.more_horiz,
            ),
            onPressed: () {
              print('Conver options');
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: MessageList.length,
              reverse: true,
              itemBuilder: (BuildContext context, int index) {
                Map msg = MessageList[index];
                return ChatBubble(
                  message: msg['message'],
                  chatItemId: widget.chatItemId,
                  messageId: msg['messageKey'],
                  time: msg["time"],
                  type: 'text',
                  isMe: msg['sentBy'] == 'user-$uid',
                  isReply: msg['sentBy'] != 'user-$uid',
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomAppBar(
              elevation: 10,
              color: Theme.of(context).primaryColor,
              child: Container(
                constraints: const BoxConstraints(
                  maxHeight: 100,
                ),
                child: buildSendInput(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAppBarTitle() {
    return InkWell(
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 0.0, right: 10.0),
            child: CircleAvatar(
              backgroundImage: widget.avatar.startsWith('assets')
                  ? AssetImage(widget.avatar) as ImageProvider
                  : NetworkImage(widget.avatar),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.isOnline ? 'Online' : 'Offline',
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      onTap: () {
        // MessageService.sendMessage(message: 'tstset', senderId: 'dsdfsdf');
      },
    );
  }

  Widget buildSendInput() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {
            // AuthStore.signIn(email: 'vinh466@gmail.com', password: '123456');
          },
        ),
        Flexible(
          child: TextField(
            controller: sentMessageController,
            style: TextStyle(
              fontSize: 15.0,
              color: Theme.of(context).textTheme.headline6?.color,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10.0),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              hintText: "Write your message...",
              hintStyle: TextStyle(
                fontSize: 15.0,
                color: Theme.of(context).textTheme.headline6?.color,
              ),
            ),
            maxLines: null,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.send,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {
            final uid = AuthStore.user!.uid;
            // messages[random.nextInt(10)]
            print('Add message');
            ChatManager.addChatMessages(
                sentMessageController.text, 'user-$uid', widget.chatItemId);
            sentMessageController.clear();
          },
        )
      ],
    );
  }
}
