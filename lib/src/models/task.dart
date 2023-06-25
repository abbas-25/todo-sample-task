// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Task {
  final String title;
  final String type;
  final String priority;
  final String timeframe;
  final String description;  
  Task({
    required this.title,
    required this.type,
    required this.priority,
    required this.timeframe,
    required this.description,
  });

  String get getTaskPriorityString => priority.replaceAll("_", " ");
  String get getTaskTypeString => type.replaceAll("_", " ");

  Task copyWith({
    String? title,
    String? type,
    String? priority,
    String? timeframe,
    String? description,
  }) {
    return Task(
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
      title: map['title'] as String,
      type: map['type'] as String,
      priority: map['priority'] as String,
      timeframe: map['timeframe'] as String,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) => Task.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Task(title: $title, type: $type, priority: $priority, timeframe: $timeframe, description: $description)';
  }

  @override
  bool operator ==(covariant Task other) {
    if (identical(this, other)) return true;
  
    return 
      other.title == title &&
      other.type == type &&
      other.priority == priority &&
      other.timeframe == timeframe &&
      other.description == description;
  }

  @override
  int get hashCode {
    return title.hashCode ^
      type.hashCode ^
      priority.hashCode ^
      timeframe.hashCode ^
      description.hashCode;
  }
}
