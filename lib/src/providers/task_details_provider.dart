// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:todo_sample/src/config/database_constants.dart';

import 'package:todo_sample/src/models/goal.dart';

class TaskDetailsProvider with ChangeNotifier {
  final Databases db;
  TaskDetailsProvider({
    required this.db,
  });

  ValueNotifier<Goal?> goal = ValueNotifier(null);
  ValueNotifier<bool> isLoadingGoal = ValueNotifier(true);

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
