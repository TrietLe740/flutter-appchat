import 'package:appchat/screens/chat/Conversation.dart';
import 'package:flutter/material.dart';
// import 'package:social_app_ui/views/screens/chat/conversation.dart';

class ChatItem extends StatefulWidget {
  final String chatItemId;
  final String avatar;
  final String name;
  final String time;
  final String lastMsg;
  final String lastSentUser;
  final bool isOnline;
  final int counter;

  const ChatItem({
    required this.chatItemId,
    required this.avatar,
    required this.name,
    required this.time,
    required this.lastMsg,
    required this.lastSentUser,
    required this.isOnline,
    required this.counter,
    super.key,
  });

  @override
  State<ChatItem> createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      leading: Stack(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: widget.avatar.startsWith('assets')
                ? AssetImage(widget.avatar) as ImageProvider
                : NetworkImage(widget.avatar),
            radius: 25,
          ),
          Positioned(
            bottom: 0.0,
            right: 6.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              height: 11,
              width: 11,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.isOnline ? Colors.greenAccent : Colors.grey,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  height: 7,
                  width: 7,
                ),
              ),
            ),
          ),
        ],
      ),
      title: Text(
        "${widget.name}.",
        maxLines: 1,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        "${widget.lastMsg}.",
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          const SizedBox(height: 10),
          Text(
            "${widget.time}.",
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 5),
          widget.counter > -1
              ? const SizedBox()
              : Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 11,
                    minHeight: 11,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 1, left: 5, right: 5),
                    child: Text(
                      "${widget.counter}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
        ],
      ),
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return Conversation(
                chatItemId: widget.chatItemId,
                avatar: widget.avatar,
                name: widget.name,
                isOnline: widget.isOnline,
              );
            },
          ),
        );
      },
    );
  }
}
