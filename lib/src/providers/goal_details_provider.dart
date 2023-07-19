// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:todo_sample/src/config/database_constants.dart';
import 'package:todo_sample/src/models/task.dart';

class GoalDetailsProvider with ChangeNotifier {
  final Databases db;
  GoalDetailsProvider({
    required this.db,
  });

  List<Task> tasksByGoals = [];
  ValueNotifier<bool> loadingTasks = ValueNotifier(false);

  Future<List<Task>> getTasksFromDb(String goalId) async {
    try {
      loadingTasks.value = true;
      final response = await db.listDocuments(
          databaseId: primaryDatabaseId,
          collectionId: tasksCollectionId,
          queries: [Query.equal("goalId", goalId)]);

      List<Task> models = [];

      for (var t in response.documents) {
        models.add(Task.fromAppwriteDoc(t));
      }

      tasksByGoals = models;
      return tasksByGoals;
    } catch (exception) {
      log("Error in getTasksFromDb based on goalId", error: exception);
      return [];
    } finally {
      loadingTasks.value = false;
    }
  }
}
