import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_sample/src/config/app_theme.dart';
import 'package:todo_sample/src/routes/app_router.dart';
import 'package:todo_sample/src/views/home/home_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
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
