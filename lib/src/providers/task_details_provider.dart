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
  ValueNotifier<bool> isTogglingTaskStatus = ValueNotifier(false);
  ValueNotifier<bool> isCompleted = ValueNotifier(false);

  reset() {
    isCompleted.value = false;
    isTogglingTaskStatus.value = false;
  }

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
  
  Future<void> updateCompletedStatus(Task task) async {
    try {
      final response = await db.getDocument(
          databaseId: primaryDatabaseId,
          collectionId: tasksCollectionId,
          documentId: task.id);
      final t = Task.fromAppwriteDoc(response);

      log("updateCompletedStatus - ${t.isCompleted}");
      isCompleted.value = t.isCompleted ?? false;
    } catch (exception) {
      log("Error in updateCompletedStatus - $exception");
    } finally {
    }
  }

  Future<void> toggleTaskComplete(Task task) async {
    try {
      isTogglingTaskStatus.value = true;

      log("updateCompletedStatus current value - ${isCompleted.value}");

      await db.updateDocument(
        databaseId: primaryDatabaseId,
        collectionId: tasksCollectionId,
        documentId: task.id,
        data: task
            .copyWith(
              isCompleted: isCompleted.value ? false : true,
            )
            .toMap(),
      );

      isCompleted.value = !isCompleted.value;
    } catch (exception) {
      // todo show toast
      // rethrow;
      // do nothing
    } finally {
      isTogglingTaskStatus.value = false;
    }
  }
}
