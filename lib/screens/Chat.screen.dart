import 'package:appchat/widgets/ChatItem.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
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
          body: ListView(
            children: <Widget>[
              ChatItem(
                dp: 'dp',
                name: 'name',
                isOnline: true,
                counter: 12,
                msg: 'msg',
                time: 'time',
              ),
              messCard(),
              messCard(),
            ],
          ),
        ));
  }

  Widget messCard() {
    return const Card(
      margin: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 4,
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: FittedBox(
                child: Text('Avatar'),
              ),
            ),
          ),
          title: Text('friend or group ...'),
          subtitle: Text('last message ....'),
          trailing: Text(' x'),
        ),
      ),
    );
  }
}
