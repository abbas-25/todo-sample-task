import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:todo_sample/src/common_widgets/primary_appbar.dart';
import 'package:todo_sample/src/config/app_theme.dart';
import 'package:todo_sample/src/config/typography.dart';
import 'package:todo_sample/src/providers/today_tasks_list_provider.dart';
import 'package:todo_sample/src/routes/routes.dart';
import 'package:todo_sample/src/views/tasks_list/widgets/single_task_tile_widget.dart';
import 'package:todo_sample/src/common_widgets/page_header.dart';

class TodayTaskListPage extends StatefulWidget {
  const TodayTaskListPage({super.key});

  @override
  State<TodayTaskListPage> createState() => TodayTaskListPageState();
}

class TodayTaskListPageState extends State<TodayTaskListPage> {
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  late TodayTasksListProvider prov =
      Provider.of<TodayTasksListProvider>(context, listen: false);
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      prov.getTodayTasksFromDb();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: RefreshIndicator(
          onRefresh: () async {
            prov.getTodayTasksFromDb();
          },
          child: Column(
            children: [
              _buildPageHeader(context),
              const SizedBox(height: 32),
              Expanded(
                child: Consumer<TodayTasksListProvider>(
                    builder: (context, prov, __) {
                  if (prov.isLoadingTasks) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (prov.tasks.isEmpty) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 150,
                        ),
                        SvgPicture.asset(
                          "assets/images/tasks-empty.svg",
                          color: const Color(0xffA5B5FC),
                        ),
                      ],
                    );
                  }

                  return ListView.builder(
                      itemCount: prov.tasks.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            SingleTaskTileWidget(task: prov.tasks[index]),
                            const SizedBox(height: 16),
                          ],
                        );
                      });
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSize _buildAppBar() {
    return const PreferredSize(
        preferredSize: Size(double.infinity, 65), child: PrimaryAppBar());
  }

  Widget _buildPageHeader(BuildContext context) {
    return Consumer<TodayTasksListProvider>(builder: (context, prov, __) {
      return PageHeader(
        title: "Today's Tasks",
        subtitle: "${prov.tasks.length} Tasks",
        trailingIcon: SpeedDial(
          foregroundColor: Colors.white,
          backgroundColor: AppTheme.primaryColor,
          icon: Icons.add,
          activeIcon: Icons.close,
          spacing: 3,
          openCloseDial: isDialOpen,
          childPadding: const EdgeInsets.all(5),
          spaceBetweenChildren: 4,
          childrenButtonSize: const Size(56.0, 56.0),
          visible: true,
          direction: SpeedDialDirection.down,
          elevation: 0.0,
          animationCurve: Curves.elasticInOut,
          children: [
            SpeedDialChild(
              child: null,
              labelBackgroundColor: AppTheme.primaryColor,
              label: 'Add New',
              labelStyle: AppTypography.button,
              onTap: () =>
                  Navigator.of(context).pushNamed(Routes.newTask).then((value) {
                if (shouldRefresh(value)) {
                  prov.getTodayTasksFromDb();
                }
              }),
            ),
            SpeedDialChild(
              child: null,
              labelBackgroundColor: AppTheme.primaryColor,
              label: 'Choose Existing',
              labelStyle: AppTypography.button,
              onTap: () => Navigator.of(context)
                  .pushNamed(Routes.existingTasks)
                  .then((value) {
                if (shouldRefresh(value)) {
                  prov.getTodayTasksFromDb();
                }
              }),
            ),
          ],
        ),
      );
    });
  }

  bool shouldRefresh(value) =>
      value != null && value.runtimeType == bool && value == true;
}
