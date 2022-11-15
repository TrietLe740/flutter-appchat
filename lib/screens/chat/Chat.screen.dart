import 'package:appchat/stores/ChatStore.dart';
import 'package:appchat/widgets/ChatItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onVerticalDragDown: (details) =>
            FocusScope.of(context).requestFocus(new FocusNode()),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            shadowColor: Colors.white,
            title: const TextField(
              decoration: InputDecoration.collapsed(
                hintText: 'Search',
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.filter_list,
                ),
                onPressed: () {},
              ),
            ],
          ),
          body: Consumer<ChatManager>(builder: (ctx, chatItemsManager, child) {
            return ListView(
              children: chatItemsManager.items
                  .map((chatItem) => ChatItem(
                        conversationId: 'asdasd',
                        avatar: chatItem.avatar,
                        name: chatItem.name,
                        isOnline: chatItem.isOnline,
                        counter: chatItem.counter,
                        lastMsg: chatItem.lastMsg,
                        time: chatItem.time,
                      ))
                  .toList(),
            );
          }),
          floatingActionButton: FloatingActionButton(
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              print('add btn');
            },
          ),
        ));
  }
}
