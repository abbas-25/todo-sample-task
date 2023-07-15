// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:todo_sample/src/config/app_theme.dart';
import 'package:todo_sample/src/providers/edit_goals_provider.dart';
import 'package:todo_sample/src/providers/edit_tasks_provider.dart';
import 'package:todo_sample/src/providers/existing_task_provider.dart';
import 'package:todo_sample/src/providers/goals_list_provider.dart';
import 'package:todo_sample/src/providers/home_provider.dart';
import 'package:todo_sample/src/providers/task_details_provider.dart';
import 'package:todo_sample/src/providers/tasks_list_provider.dart';
import 'package:todo_sample/src/providers/today_tasks_list_provider.dart';
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
  late Databases db;
  late TasksListProvider tasksListProvider;
  late GoalsListProvider goalsListProvider;
  @override
  void initState() {
    db = Databases(widget.client);
    tasksListProvider = TasksListProvider(db: db);
    goalsListProvider = GoalsListProvider(db: db);
    super.initState();
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

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => tasksListProvider),
        ChangeNotifierProvider(create: (context) => goalsListProvider),
        ChangeNotifierProvider(
            create: (context) => HomeProvider(
                tasksListProvider: tasksListProvider,
                goalsListProvider: goalsListProvider)),
        ChangeNotifierProvider(
            create: (context) =>
                EditTaskProvider(db: db, tasksListProvider: tasksListProvider, goalsListProvider: goalsListProvider)),
        ChangeNotifierProvider(
            create: (context) => EditGoalsProvider(
                db: db, goalsListProvider: goalsListProvider)),
        ChangeNotifierProvider(
            create: (context) => TaskDetailsProvider(
                db: db)),
        ChangeNotifierProvider(
            create: (context) => TodayTasksListProvider(
                db: db)),
        ChangeNotifierProvider(
            create: (context) => ExistingTasksProvider(
                db: db)),
      ],
      child: ScreenUtilInit(
          designSize: const Size(360, 640),
          builder: (context, _) {
            return MaterialApp(
              title: "Todo App",
              theme: AppTheme.light,
              debugShowCheckedModeBanner: false,
              onGenerateRoute: AppRouter.generateRoute(),
              home: const HomePage(),
            );
          }),
    );
  }
}
