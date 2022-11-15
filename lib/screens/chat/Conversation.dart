import 'dart:math';

import 'package:appchat/stores/AuthStore.dart';
import 'package:appchat/services/ChatService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:appchat/widgets/ChatBubble.dart';
import 'package:appchat/utils/data.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Conversation extends StatefulWidget {
  const Conversation({super.key});

  @override
  State<Conversation> createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  static Random random = Random();
  String name = names[random.nextInt(10)];

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
              itemCount: conversation.length,
              reverse: true,
              itemBuilder: (BuildContext context, int index) {
                Map msg = conversation[index];
                return ChatBubble(
                  message: msg['type'] == "text"
                      ? messages[random.nextInt(10)]
                      : "assets/images/cm${random.nextInt(2) + 1}.jpg",
                  username: msg["username"],
                  time: msg["time"],
                  type: msg['type'],
                  replyText: msg["replyText"],
                  isMe: msg['isMe'],
                  isGroup: msg['isGroup'],
                  isReply: msg['isReply'],
                  replyName: name,
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
              backgroundImage: AssetImage(
                "assets/images/cm${random.nextInt(2) + 1}.jpg",
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Online",
                  style: TextStyle(
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
        print('Go to User');
        MessageService.test();
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
            print('Sign In');

            // AuthStore.signIn(email: 'vinh466@gmail.com', password: '123456');
          },
        ),
        Flexible(
          child: TextField(
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
            Icons.mic,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {
            print('Sign Out');
            // AuthStore.signOut();
          },
        )
      ],
    );
  }
}
