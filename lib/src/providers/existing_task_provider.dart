// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';

import 'package:todo_sample/src/config/database_constants.dart';

import '../models/task.dart';

class ExistingTasksProvider with ChangeNotifier {
  final Databases db;
  ExistingTasksProvider({
    required this.db,
  });

  List<Task> tasks = [];
  ValueNotifier<List<Task>> visibleTasks = ValueNotifier([]);

  ValueNotifier<bool> isLoadingTasks = ValueNotifier(true);
  ValueNotifier<bool> isMarkingTaskForToday = ValueNotifier(false);

  ValueNotifier<Task?> selected = ValueNotifier(null);

  List<String> existingTaskFilters = [];
  ValueNotifier<String> selectedFilter = ValueNotifier("All");

  init() {
    selected.value = null;
    tasks = [];
    visibleTasks.value = [];
    isMarkingTaskForToday.value = false;
    selectedFilter.value = "All";
    final tfs = timeframes.sublist(2);
    existingTaskFilters = ["All", ...tfs];
  }

  Future<List<Task>> getTasksFromDb() async {
    try {
      isLoadingTasks.value = true;
      final response = await db.listDocuments(
          databaseId: primaryDatabaseId,
          collectionId: tasksCollectionId,
          queries: [Query.equal("isMarkedForToday", false)]);

      List<Task> models = [];

      for (var t in response.documents) {
        models.add(Task.fromAppwriteDoc(t));
      }

      visibleTasks.value = models;
      return tasks = models;
    } catch (exception) {
      log("Error Logged in Appwrite call  - $exception");
      return [];
    } finally {
      isLoadingTasks.value = false;
    }
  }

  Future<bool> markTaskForToday() async {
    try {
      if (selected.value == null) return false;

      isMarkingTaskForToday.value = true;

      await db.updateDocument(
        databaseId: primaryDatabaseId,
        collectionId: tasksCollectionId,
        documentId: selected.value!.id,
        data: selected.value!
            .copyWith(
              isMarkedForToday: true,
            )
            .toMap(),
      );

      selected.value = null;
      return true;
    } catch (exception) {
      return false;
    } finally {
      isMarkingTaskForToday.value = false;
    }
  }

  void filterTasksByTimeframe(String tf) {
    log("Filter $tf");
    if (tf == selectedFilter.value) return;
    selectedFilter.value = tf;
    visibleTasks.value.clear();

    if (tf == "All") {
      visibleTasks.value = tasks;
    } else {
      final now = DateTime.now();
      final dr = getDurationFromExpectedTime(tf);
      for (Task element in tasks) {
        if (dr != null) {
          if ((element.expectedCompletion?.isBefore(now.add(dr)) ?? false)) {
            visibleTasks.value.add(element);
          }
        }
      }
    }
    isLoadingTasks.value = true;
    Future.delayed(const Duration(milliseconds: 200), () {
      isLoadingTasks.value = false;
    });
  }
}

Duration? getDurationFromExpectedTime(String tf) {
  switch (tf) {
    case "None":
      return null;
    case "Today":
      return const Duration(days: 1);
    case "3":
      return const Duration(days: 3);
    case "Week":
      return const Duration(days: 7);
    case "Fortnight":
      return const Duration(days: 14);
    case "Month":
      return const Duration(days: 30);
    case "90":
      return const Duration(days: 90);
    case "Year":
      return const Duration(days: 365);
    default:
      return null;
  }
}
