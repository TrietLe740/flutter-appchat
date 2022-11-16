import 'package:flutter/foundation.dart';

class UserChat {
  final String? conversationId;

  UserChat({
    this.conversationId,
  });

  UserChat copyWith({
    String? conversationId,
  }) {
    return UserChat(
      conversationId: conversationId ?? this.conversationId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conversationId': conversationId,
    };
  }

  static UserChat fromJson(Map<String, dynamic> json) {
    return UserChat(
      conversationId: json['conversationId'],
    );
  }
}
