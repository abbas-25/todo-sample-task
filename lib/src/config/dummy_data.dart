import 'package:todo_sample/src/models/task.dart';

class DummyData {
  static List<Task> getTasks() {
    return [
      Task(
          title: "Quis sunt consequat exercitation culpa",
          type: "work",
          priority: "needs_done",
          timeframe: "today",
          description: "Velit ea voluptate reprehenderit proident deserunt."),
      Task(
          title: "Start working out",
          type: "personal_project",
          priority: "nice_to_have",
          timeframe: "week",
          description: "Velit ea voluptate reprehenderit proident deserunt."),
      Task(
          title: "Officia aliquip anim",
          type: "self",
          priority: "needs_done",
          timeframe: "3 days",
          description: "Velit ea voluptate reprehenderit proident deserunt."),
      Task(
          title: "Excepteur veniam labore",
          type: "self",
          priority: "nice_idea",
          timeframe: "fortnight",
          description: "Velit ea voluptate reprehenderit proident deserunt."),
      Task(
          title: "Culpa reprehenderit nisi ea",
          type: "work",
          priority: "nice_idea",
          timeframe: "month",
          description: "Velit ea voluptate reprehenderit proident deserunt."),
    ];
  }
}
