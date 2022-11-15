import 'package:appchat/widgets/ChatBubble.dart';
// import 'package:flutter/foundation.dart';

class ChatItem {
  final String? conversationId;
  final String avatar;
  final String name;
  final String time;
  final String lastMsg;
  final bool isOnline;
  int counter;

  ChatItem({
    this.conversationId,
    required this.avatar,
    required this.name,
    required this.time,
    required this.lastMsg,
    required this.isOnline,
    required this.counter,
  });

  set isFavorite(int newValue) {
    counter = newValue;
  }

  ChatItem copyWith({
    String? conversationId,
    String? avatar,
    String? name,
    String? time,
    String? lastMsg,
    bool? isOnline,
    int? counter,
  }) {
    return ChatItem(
      conversationId: conversationId ?? this.conversationId,
      avatar: avatar ?? this.avatar,
      name: name ?? this.name,
      time: time ?? this.time,
      lastMsg: lastMsg ?? this.lastMsg,
      isOnline: isOnline ?? this.isOnline,
      counter: counter ?? this.counter,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conversationId': conversationId,
      'avatar': avatar,
      'name': name,
      'time': time,
      'lastMsg': lastMsg,
      'isOnline': isOnline,
      'counter': counter,
    };
  }

  static ChatItem fromJson(Map<String, dynamic> json) {
    return ChatItem(
      conversationId: json['conversationId'],
      avatar: json['avatar'],
      name: json['name'],
      time: json['time'],
      lastMsg: json['lastMsg'],
      isOnline: json['isOnline'],
      counter: json['counter'],
    );
  }
}
