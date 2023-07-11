// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';

import 'package:todo_sample/src/config/database_constants.dart';
import 'package:todo_sample/src/models/goal.dart';
import 'package:todo_sample/src/models/task.dart';
import 'package:todo_sample/src/providers/goals_list_provider.dart';
import 'package:todo_sample/src/providers/tasks_list_provider.dart';

class EditTaskProvider with ChangeNotifier {
  final Databases db;
  final TasksListProvider tasksListProvider;
  final GoalsListProvider goalsListProvider;
  ValueNotifier isFirstLoading = ValueNotifier(true);
  List<Goal> goalsForDropdown = [];

  EditTaskProvider({
    required this.db,
    required this.tasksListProvider,
    required this.goalsListProvider,
  });

  bool isProcessing = false;

  void switchProcessingState(bool newState) {
    isProcessing = newState;
    notifyListeners();
  }

  Future<List<Goal>> getGoalsForDropdown() async {
    try {
      isFirstLoading.value = true;
      goalsForDropdown = [];
      return goalsForDropdown = await goalsListProvider.getGoalsFromDb();
    } catch (exception) {
      return [];
    } finally {
      isFirstLoading.value = false;
    }
  }

  Future<void> createTaskFromDb({
    required Task task,
  }) async {
    try {
      switchProcessingState(true);
      await db.createDocument(
        databaseId: primaryDatabaseId,
        collectionId: tasksCollectionId,
        documentId: ID.unique(),
        data: task.toMap(),
      );
      await tasksListProvider.getTasksFromDb();
    } catch (exception) {
      log("Error Logged in Appwrite call  - $exception");
    } finally {
      switchProcessingState(false);
    }
  }

  Future<void> deleteDocument(Task task) async {
    try {
      switchProcessingState(true);
      await db.deleteDocument(
        collectionId: tasksCollectionId,
        databaseId: primaryDatabaseId,
        documentId: task.id,
      );
      await tasksListProvider.getTasksFromDb();
    } catch (exception) {
      log("Error in deleteDocument $exception");
    } finally {
      switchProcessingState(false);
    }
  }
}
