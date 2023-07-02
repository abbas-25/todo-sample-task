// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:appwrite/models.dart';

class Task {
  final String id;
  final String title;
  final String type;
  final String priority;
  final String timeframe;
  final String description;  
  Task({
    required this.id,
    required this.title,
    required this.type,
    required this.priority,
    required this.timeframe,
    required this.description,
  });

  String get getTaskPriorityString => priority.replaceAll("_", " ");
  String get getTaskTypeString => type.replaceAll("_", " ");

  Task copyWith({
    String? id,
    String? title,
    String? type,
    String? priority,
    String? timeframe,
    String? description,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      timeframe: timeframe ?? this.timeframe,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'type': type,
      'priority': priority,
      'timeframe': timeframe,
      'description': description,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String,
      title: map['title'] as String,
      type: map['type'] as String,
      priority: map['priority'] as String,
      timeframe: map['timeframe'] as String,
      description: map['description'] as String,
    );
  }
  
  factory Task.fromAppwriteDoc(Document doc) {
    final data = doc.data;
    return Task(
      id: doc.$id,
      title: data['title'] as String,
      type: data['type'] as String,
      priority: data['priority'] as String,
      timeframe: data['timeframe'] as String,
      description: data['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) => Task.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Task(id: $id, title: $title, type: $type, priority: $priority, timeframe: $timeframe, description: $description)';
  }

  @override
  bool operator ==(covariant Task other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.title == title &&
      other.type == type &&
      other.priority == priority &&
      other.timeframe == timeframe &&
      other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      type.hashCode ^
      priority.hashCode ^
      timeframe.hashCode ^
      description.hashCode;
  }
}
