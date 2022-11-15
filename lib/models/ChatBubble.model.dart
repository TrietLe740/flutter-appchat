import 'package:flutter/foundation.dart';

class ChatBubble {
  final String? conversationId;
  final String avatar;
  final String message;
  final String username;
  final String time;
  final String lastMsg;
  final bool isOnline;

  ChatBubble({
    this.conversationId,
    required this.avatar,
    required this.message,
    required this.username,
    required this.time,
    required this.lastMsg,
    required this.isOnline,
  });

  ChatBubble copyWith({
    String? conversationId,
    String? avatar,
    String? name,
    String? time,
    String? lastMsg,
    bool? isOnline,
    int? counter,
  }) {
    return ChatBubble(
      conversationId: conversationId ?? this.conversationId,
      avatar: avatar ?? this.avatar,
      message: message,
      username: username,
      time: time ?? this.time,
      lastMsg: lastMsg ?? this.lastMsg,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conversationId': conversationId,
      'avatar': avatar,
      'message': message,
      'username': username,
      'time': time,
      'lastMsg': lastMsg,
      'isOnline': isOnline,
    };
  }

  static ChatBubble fromJson(Map<String, dynamic> json) {
    return ChatBubble(
      conversationId: json['conversationId'],
      avatar: json['avatar'],
      message: json['message'],
      username: json['username'],
      time: json['time'],
      lastMsg: json['lastMsg'],
      isOnline: json['isOnline'],
    );
  }
}
