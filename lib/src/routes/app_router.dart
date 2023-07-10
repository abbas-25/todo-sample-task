import 'package:flutter/material.dart';
import 'package:todo_sample/src/models/goal.dart';
import 'package:todo_sample/src/routes/routes.dart';
import 'package:todo_sample/src/views/goals_list/goals_list_page.dart';
import 'package:todo_sample/src/views/home/home_page.dart';
import 'package:todo_sample/src/views/new_goal/new_goal_page.dart';
import 'package:todo_sample/src/views/new_task/new_task_page.dart';
import 'package:todo_sample/src/views/goal_details/goal_details_page.dart';
import 'package:todo_sample/src/views/task_details/task_details_page.dart';
import 'package:todo_sample/src/views/tasks_list/tasks_list_page.dart';

import '../models/task.dart';

class AppRouter {
  static generateRoute() {
    return (RouteSettings settings) {
      Widget route = _getRouteWidget(settings);

      return MaterialPageRoute(
        builder: (context) => route,
        settings: settings,
      );
    };
  }

  static _getRouteWidget(RouteSettings settings) {
    switch (settings.name) {
      case Routes.home:
        return const HomePage();
      case Routes.newTask:
        return const NewTaskPage();
      case Routes.newGoal:
        return const NewGoalPage();
      case Routes.taskDetails:
        return TaskDetailsPage(task: settings.arguments as Task);
      case Routes.goalsList:
        return const GoalsListPage();
      case Routes.goalDetails:
        return GoalDetailPage(goal: settings.arguments as Goal);
      case Routes.tasksList:
        return const TasksListPage();

      default:
        return const HomePage();
    }
  }
}
