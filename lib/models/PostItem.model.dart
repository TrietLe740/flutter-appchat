import 'package:flutter/foundation.dart';

class Post {
  final String? id;
  final String title;
  final String description;
  final String imageUrl;

  Post({
    this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    isFavorite = false,
  });

  Post copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    double? price,
    bool? isFavorite,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  static Post fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }
}
