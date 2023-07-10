// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';

import 'package:todo_sample/src/config/database_constants.dart';

import '../models/goal.dart';

class GoalsListProvider with ChangeNotifier {
  final Databases db;
  GoalsListProvider({
    required this.db,
  });

  List<Goal> goals = [];
  bool isLoadingGoals = true;

  Future<List<Goal>> getGoalsFromDb() async {
    try {
      isLoadingGoals = true;
      notifyListeners();
      final response = await db.listDocuments(
        databaseId: primaryDatabaseId,
        collectionId: goalsCollectionId,
      );

      List<Goal> models = [];

      for (var t in response.documents) {
        models.add(Goal.fromAppwriteDoc(t));
      }

      return goals = models;
    } catch (exception) {
      log("Error Logged in Appwrite call  - $exception");
      return [];
    } finally {
      isLoadingGoals = false;
      notifyListeners();
    }
  }
}
