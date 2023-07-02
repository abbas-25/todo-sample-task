// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';

import 'package:todo_sample/src/config/database_constants.dart';

import '../models/task.dart';

class TasksListProvider with ChangeNotifier {
  final Databases db;
  TasksListProvider({
    required this.db,
  });

  List<Task> tasks = [];
  bool isLoadingTasks = true;

  Future<List<Task>> getTasksFromDb() async {
    try {
      isLoadingTasks = true;
      notifyListeners();
      final response = await db.listDocuments(
        databaseId: primaryDatabaseId,
        collectionId: tasksCollectionId,
      );

      List<Task> models = [];

      for (var t in response.documents) {
        models.add(Task.fromAppwriteDoc(t));
      }

      return tasks = models;
    } catch (exception) {
      log("Error Logged in Appwrite call  - $exception");
      return [];
    } finally {
      isLoadingTasks = false;
      notifyListeners();
    }
  }
}
