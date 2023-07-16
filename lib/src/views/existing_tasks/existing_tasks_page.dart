import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:todo_sample/src/common_widgets/page_header.dart';
import 'package:todo_sample/src/common_widgets/primary_appbar.dart';
import 'package:todo_sample/src/common_widgets/primary_button.dart';
import 'package:todo_sample/src/config/app_theme.dart';
import 'package:todo_sample/src/config/typography.dart';
import 'package:todo_sample/src/providers/existing_task_provider.dart';
import 'package:todo_sample/src/views/existing_tasks/widgets/single_existing_task_tile.dart';

class ExistingTasksPage extends StatefulWidget {
  const ExistingTasksPage({super.key});

  @override
  State<ExistingTasksPage> createState() => _ExistingTasksPageState();
}

class _ExistingTasksPageState extends State<ExistingTasksPage> {
  late ExistingTasksProvider prov;

  @override
  void initState() {
    prov = Provider.of<ExistingTasksProvider>(context, listen: false);
    prov.init();
    Future.delayed(Duration.zero, () {
      prov.getTasksFromDb();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            _buildPageHeader(context),
            const SizedBox(height: 32),

            // filters
            ValueListenableBuilder(
                valueListenable: prov.selectedFilter,
                builder: (context, _, __) {
                  return SizedBox(
                    height: 40,
                    child: ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        scrollDirection: Axis.horizontal,
                        itemCount: prov.existingTaskFilters.length,
                        itemBuilder: (context, index) {
                          final item = prov.existingTaskFilters[index];
                          return InkWell(
                            onTap: () {
                              prov.filterTasksByTimeframe(item);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 12),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: prov.selectedFilter.value == item
                                    ? AppTheme.primaryColor
                                    : const Color(0xffEDF3FF),
                              ),
                              child: Text(item,
                                  style: AppTypography.input.copyWith(
                                      color: prov.selectedFilter.value == item
                                          ? Colors.white
                                          : AppTypography.textDefaultColor)),
                            ),
                          );
                        }),
                  );
                }),

            const SizedBox(height: 24),

            // all tasks
            Expanded(
              child: ValueListenableBuilder(
                  valueListenable: prov.isLoadingTasks,
                  builder: (context, _, __) {
                    if (prov.isLoadingTasks.value) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (prov.visibleTasks.isEmpty) {
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
                        itemCount: prov.visibleTasks.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              SingleExistingTaskTile(
                                  task: prov.visibleTasks[index]),
                              const SizedBox(height: 16),
                            ],
                          );
                        });
                  }),
            ),
            const SizedBox(height: 150,)
          ],
          
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(20),
        child: ValueListenableBuilder(
            valueListenable: prov.selected,
            builder: (context, _, __) {
              return ValueListenableBuilder(
                  valueListenable: prov.isMarkingTaskForToday,
                  builder: (context, _, __) {
                    return PrimaryButton(
                        isDisabled: prov.selected.value == null,
                        isLoading: prov.isMarkingTaskForToday.value,
                        title: "Move to Today's Task",
                        onTap: () async {
                          prov.markTaskForToday().then((value) {
                            if (value) {
                              prov.getTasksFromDb();
                            }
                          });
                        });
                  });
            }),
      ),
    );
  }

  PreferredSize _buildAppBar() {
    return const PreferredSize(
        preferredSize: Size(double.infinity, 65), child: PrimaryAppBar());
  }

  Widget _buildPageHeader(BuildContext context) {
    return const PageHeader(
      title: "Existing Task",
    );
  }
}
