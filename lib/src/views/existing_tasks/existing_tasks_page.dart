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

import '../goal_details/goal_details_page.dart';

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
            Row(
              children: [
                _TimeframeFilter(prov: prov),
                const SizedBox(width: 12),
                _TypeFilter(prov: prov),
              ],
            ),

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
            const SizedBox(
              height: 150,
            )
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

class _TimeframeFilter extends StatelessWidget {
  const _TimeframeFilter({
    required this.prov,
  });

  final ExistingTasksProvider prov;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: prov.selectedTimeframeFilter,
        builder: (context, _, __) {
          return SizedBox(
            height: 40,
            child: InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        content: SizedBox(
                          width: double.maxFinite,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const PopupCloseButton(),
                              Center(
                                  child: Text(
                                "Timeframe",
                                style: AppTypography.title
                                    .copyWith(fontWeight: FontWeight.w500),
                              )),
                              const SizedBox(
                                height: 24,
                              ),
                              Flexible(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: prov.existingTaskFilters.length,
                                    itemBuilder: (context, index) {
                                      final item =
                                          prov.existingTaskFilters[index];
                                      return InkWell(
                                        onTap: () {
                                          prov.filterTasksByTimeframe(item);
                                          Navigator.of(context).pop();
                                        },
                                        child: Column(
                                          children: [
                                            FilterItem(item: item),
                                            const SizedBox(
                                              height: 8,
                                            )
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: prov.selectedTimeframeFilter.value != null
                      ? AppTheme.primaryColor
                      : const Color(0xffEDF3FF),
                ),
                child: Row(
                  children: [
                    Text(prov.selectedTimeframeFilter.value ?? "Timeframe",
                        style: AppTypography.input.copyWith(
                            color: prov.selectedTimeframeFilter.value != null
                                ? Colors.white
                                : AppTypography.textDefaultColor)),
                    const SizedBox(
                      width: 7.75,
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: prov.selectedTimeframeFilter.value != null
                          ? Colors.white
                          : const Color(0xff404040),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class FilterItem extends StatelessWidget {
  const FilterItem({
    super.key,
    required this.item,
  });

  final String item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xffF2F2F2),
          boxShadow: [
            // BoxShadow(
            //   blurRadius: 20,
            //   color: Colors.black.withOpacity(0.05),
            //   offset: const Offset(0, 4),
            // )
          ]),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Center(
          child: Text(
        item,
        style: AppTypography.input,
      )),
    );
  }
}

class _TypeFilter extends StatelessWidget {
  const _TypeFilter({
    required this.prov,
  });

  final ExistingTasksProvider prov;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: prov.selectedTypeFilter,
        builder: (context, _, __) {
          return SizedBox(
            height: 40,
            child: InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        content: SizedBox(
                          width: double.maxFinite,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const PopupCloseButton(),
                              Center(
                                  child: Text(
                                "Type",
                                style: AppTypography.title
                                    .copyWith(fontWeight: FontWeight.w500),
                              )),
                              const SizedBox(
                                height: 24,
                              ),
                              Flexible(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: prov.typeFilters.length,
                                    itemBuilder: (context, index) {
                                      final item = prov.typeFilters[index];
                                      return InkWell(
                                        onTap: () {
                                          prov.filterTasksByTimeframe(item);
                                          Navigator.of(context).pop();
                                        },
                                        child: Column(
                                          children: [
                                            FilterItem(item: item),
                                            const SizedBox(
                                              height: 8,
                                            )
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: prov.selectedTypeFilter.value != null
                      ? AppTheme.primaryColor
                      : const Color(0xffEDF3FF),
                ),
                child: Row(
                  children: [
                    Text(prov.selectedTypeFilter.value ?? "Type",
                        style: AppTypography.input.copyWith(
                            color: prov.selectedTimeframeFilter.value != null
                                ? Colors.white
                                : AppTypography.textDefaultColor)),
                    const SizedBox(
                      width: 7.75,
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: prov.selectedTimeframeFilter.value != null
                          ? Colors.white
                          : const Color(0xff404040),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
