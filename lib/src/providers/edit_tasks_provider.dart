// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';

import 'package:todo_sample/src/config/database_constants.dart';
import 'package:todo_sample/src/models/task.dart';
import 'package:todo_sample/src/providers/tasks_list_provider.dart';

class EditTaskProvider with ChangeNotifier {
  final Databases db;
  final TasksListProvider tasksListProvider;
  EditTaskProvider({
    required this.db,
    required this.tasksListProvider,
  });

  bool isProcessing = false;

  void switchProcessingState(bool newState) {
    isProcessing = newState;
    notifyListeners();
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
