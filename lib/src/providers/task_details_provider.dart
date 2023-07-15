// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:todo_sample/src/config/database_constants.dart';

import 'package:todo_sample/src/models/goal.dart';
import 'package:todo_sample/src/models/task.dart';

class TaskDetailsProvider with ChangeNotifier {
  final Databases db;
  TaskDetailsProvider({
    required this.db,
  });

  ValueNotifier<Goal?> goal = ValueNotifier(null);
  ValueNotifier<bool> isLoadingGoal = ValueNotifier(true);
  ValueNotifier<bool> isMarkingTaskForToday = ValueNotifier(false);

  Future<bool> markTaskForToday(Task task) async {
    try {
      isMarkingTaskForToday.value = true;

      await db.updateDocument(
        databaseId: primaryDatabaseId,
        collectionId: tasksCollectionId,
        documentId: task.id,
        data: task
            .copyWith(
              isMarkedForToday: true,
            )
            .toMap(),
      );
      return true;
    } catch (exception) {
      return false;
    } finally {
      isMarkingTaskForToday.value = false;
    }
  }

   Future<bool> removeTaskForToday(Task task) async {
    try {
      isMarkingTaskForToday.value = true;

      await db.updateDocument(
        databaseId: primaryDatabaseId,
        collectionId: tasksCollectionId,
        documentId: task.id,
        data: task
            .copyWith(
              isMarkedForToday: false,
            )
            .toMap(),
      );
      return true;
    } catch (exception) {
      return false;
    } finally {
      isMarkingTaskForToday.value = false;
    }
  }

  Future<Goal?> fetchGoal(String goalId) async {
    try {
      log("fetchGoal");

      isLoadingGoal.value = true;
      final response = await db.getDocument(
          databaseId: primaryDatabaseId,
          collectionId: goalsCollectionId,
          documentId: goalId);
      return goal.value = Goal.fromAppwriteDoc(response);
    } catch (exception) {
      log("Error in fetchGoal - $exception");
      return null;
    } finally {
      isLoadingGoal.value = false;
    }
  }
}
