// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:appwrite/models.dart';

class Goal {
  final String id;
  final String title;
  final String type;
  final String description;  
  Goal({
    required this.id,
    required this.title,
    required this.type,
    required this.description,
  });


  Goal copyWith({
    String? id,
    String? title,
    String? type,
    String? description,
  }) {
    return Goal(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '\$id': id, 
      'title': title,
      'type': type,
      'description': description,
    };
  }

  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      id: map['\$id'] as String,
      title: map['title'] as String,
      type: map['type'] as String,
      description: map['description'] as String,
    );
  }
  
  factory Goal.fromAppwriteDoc(Document doc) {
    final data = doc.data;
    return Goal(
      id: doc.$id,
      title: data['title'] as String,
      type: data['type'] as String,
      description: data['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Goal.fromJson(String source) => Goal.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return title;
  }

  @override
  bool operator ==(covariant Goal other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.title == title &&
      other.type == type &&
      other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      type.hashCode ^
      description.hashCode;
  }
}
