import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_sample/src/config/app_theme.dart';
import 'package:todo_sample/src/config/typography.dart';
import 'package:todo_sample/src/models/menu.dart';
import 'package:todo_sample/src/providers/home_provider.dart';
import 'package:todo_sample/src/views/home/widgets/single_menu_item_widget.dart';

import '../../routes/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MenuItem> items = [
    MenuItem(
        id: "id1",
        title: "Tasks",
        image: "assets/images/tasks-tile-icon.png",
        route: Routes.todayTasksList),
    MenuItem(
        id: "id2",
        title: "Goals",
        image: "assets/images/goals-tile-icon.png",
        route: Routes.goalsList),
  ];

  late HomeProvider homeProv;

  @override
  void initState() {
    homeProv = Provider.of<HomeProvider>(context, listen: false);
    Future.delayed(Duration.zero).then((value) {
      homeProv.init();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<HomeProvider>(builder: (context, _, __) {
          return homeProv.loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),
                      Text(
                        "Sample App",
                        style: AppTypography.headline1
                            .copyWith(color: AppTheme.primaryColor),
                      ),
                      const SizedBox(height: 40),
                      for (int i = 0; i < items.length; i++) ...[

                        SingleMenuItemWidget(
                          item: items[i],
                          itemCount: homeProv.menuItemsCount[i],
                        ), 
                        const SizedBox(height:20)
                      ]
                    ],
                  ),
                );
        }),
      ),
    );
  }
}
