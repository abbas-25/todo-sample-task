// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:todo_sample/src/config/database_constants.dart';
import 'package:todo_sample/src/models/goal.dart';
import 'package:todo_sample/src/models/task.dart';

class GoalDetailsProvider with ChangeNotifier {
  final Databases db;
  GoalDetailsProvider({
    required this.db,
  });

  List<Task> tasksByGoals = [];
  ValueNotifier<bool> loadingTasks = ValueNotifier(false);
  ValueNotifier<bool> processing = ValueNotifier(false);
  ValueNotifier<bool> isCompleted = ValueNotifier(false);
  ValueNotifier<bool> loadingGoal = ValueNotifier(false);
  Goal? goal;

  init(Goal g) async {
    fetchGoal(g.id);
    // isCompleted.value = g.isCompleted;
    processing.value = false;
    loadingTasks.value = false;
    loadingGoal.value = false;
  }

  Future<void> markGoalAsComplete({required Goal goal}) async {
    try {
      processing.value = true;

      await db.updateDocument(
        databaseId: primaryDatabaseId,
        collectionId: goalsCollectionId,
        documentId: goal.id,
        data: goal
            .copyWith(
              isCompleted: true,
            )
            .toMap(),
      );

      await fetchGoal(goal.id);

      isCompleted.value = true;
    } catch (exception) {
      // todo show toast
      // rethrow;
      // do nothing
    } finally {
      processing.value = false;
    }
  }

  Future<Goal> fetchGoal(String goalId) async {
    try {
      loadingGoal.value = true;
      final resp = await db.getDocument(
        databaseId: primaryDatabaseId,
        collectionId: goalsCollectionId,
        documentId: goalId,
      );

      goal = Goal.fromAppwriteDoc(resp);
      isCompleted.value = goal!.isCompleted;
      return goal!;
    } catch (exception) {
      // todo show toast
      rethrow;
    } finally {
      loadingGoal.value = false;
    }
  }

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