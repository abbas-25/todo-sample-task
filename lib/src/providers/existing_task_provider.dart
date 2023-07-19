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

  List<Task> _tasks = [];
  List<Task> visibleTasks = [];

  ValueNotifier<bool> isLoadingTasks = ValueNotifier(true);
  ValueNotifier<bool> isMarkingTaskForToday = ValueNotifier(false);

  ValueNotifier<Task?> selected = ValueNotifier(null);

  List<String> existingTaskFilters = [];
  ValueNotifier<String> selectedFilter = ValueNotifier("All");

  init() {
    selected.value = null;
    _tasks = [];
    visibleTasks = [];
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

      _tasks = models;
      visibleTasks = [];
      filterTasksByTimeframe(selectedFilter.value, true);
      return _tasks;
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

  void filterTasksByTimeframe(String tf, [bool overrideReturn = false]) {
    log("Filterrr $tf");
    if (!overrideReturn) {
      if (tf == selectedFilter.value) return;
    }
    selected.value = null;
    selectedFilter.value = tf;
    visibleTasks = [];

    if (tf == "All") {
      visibleTasks = [..._tasks];
      log("visibleTasksss $_tasks");
    } else {
      final now = DateTime.now();
      List<Task> tempTasks = [];
      final dr = getDurationFromFilterName(tf);
      log("Filtering dr --> $tf");
      for (Task element in _tasks) {
        if (element.expectedCompletion == null) continue;
        
        var exp = element.expectedCompletion!.subtract(const Duration(days: 1));

        if (!now.add(Duration(days: dr)).isBefore(exp)) {
          tempTasks.add(element);
        }
      }
      visibleTasks = [...tempTasks];
    }
    isLoadingTasks.value = true;
    Future.delayed(const Duration(milliseconds: 300), () {
      isLoadingTasks.value = false;
    });
  }
}

int getDurationFromFilterName(String tf) {
  switch (tf.toLowerCase()) {
    /// [not required conditions]
    // case "None":
    //   return null;
    // case "Today":
    //   return const Duration(days: 1);
    case "3 days":
      return 3;
    case "week":
      return 7;
    case "fortnight":
      return 14;
    case "month":
      return 30;
    case "90 days":
      return 90;
    case "year":
      return 365;
    default:
      return 0;
  }
}
