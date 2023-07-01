// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:todo_sample/src/config/app_theme.dart';
import 'package:todo_sample/src/config/database_constants.dart';
import 'package:todo_sample/src/config/dummy_data.dart';
import 'package:todo_sample/src/routes/app_router.dart';
import 'package:todo_sample/src/views/home/home_page.dart';

class MyApp extends StatefulWidget {
  final Client client;
  const MyApp({
    Key? key,
    required this.client,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    addSampleTodoToTestingCollection();
    super.initState();
  }

  /// Purpose - only to check a valid appwrite connection
  addSampleTodoToTestingCollection() {
    try {
      final db = Databases(widget.client);
      final sampleTodo = DummyData.getTasks().first;
      db.createDocument(
        databaseId: primaryDatabaseId,
        collectionId: testingCollectionId,
        documentId: ID.unique(),
        data: sampleTodo.toMap(),
      );
    } catch (exception) {
      log("Error Logged in Appwrite call addSampleTodoToTestingCollection  - $exception");
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ));

    return ScreenUtilInit(
        designSize: const Size(360, 640),
        builder: (context, _) {
          return MaterialApp(
            title: "Todo App",
            theme: AppTheme.light,
            debugShowCheckedModeBanner: false,
            onGenerateRoute: AppRouter.generateRoute(),
            home: const HomePage(),
          );
        });
  }
}
