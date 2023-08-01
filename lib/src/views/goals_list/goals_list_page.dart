import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_sample/src/common_widgets/primary_appbar.dart';
import 'package:todo_sample/src/config/app_theme.dart';
import 'package:todo_sample/src/config/typography.dart';
import 'package:todo_sample/src/providers/goals_list_provider.dart';
import 'package:todo_sample/src/routes/routes.dart';
import 'package:todo_sample/src/views/existing_tasks/existing_tasks_page.dart';
import 'package:todo_sample/src/views/goal_details/goal_details_page.dart';
import 'package:todo_sample/src/views/goals_list/widgets/single_goal_tile_widget.dart';
import 'package:todo_sample/src/common_widgets/page_header.dart';

class GoalsListPage extends StatefulWidget {
  const GoalsListPage({super.key});

  @override
  State<GoalsListPage> createState() => _GoalsListPageState();
}

class _GoalsListPageState extends State<GoalsListPage> {
  late GoalsListProvider prov;
  @override
  void initState() {
    prov = Provider.of<GoalsListProvider>(context, listen: false);
    Future.delayed(Duration.zero, () {
      prov.getGoalsFromDb();
    });
    super.initState();
  }

  @override
  void dispose() {
    prov.reset();
    super.dispose();
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
                _TypeFilter(prov: prov),
              ],
            ),

            const SizedBox(height: 24),
            Expanded(
              child: Consumer<GoalsListProvider>(builder: (context, prov, __) {
                if (prov.isLoadingGoals) {
                  return const Center(child: CircularProgressIndicator());
                } else if (prov.goals.isEmpty) {
                  return const Center(child: Text("No Goals Created!"));
                }

                return ListView.builder(
                    itemCount: prov.goals.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          SingleGoalTileWidget(goal: prov.goals[index]),
                          const SizedBox(height: 16),
                        ],
                      );
                    });
              }),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSize _buildAppBar() {
    return const PreferredSize(
        preferredSize: Size(double.infinity, 65), child: PrimaryAppBar());
  }

  Widget _buildPageHeader(BuildContext context) {
    return Consumer<GoalsListProvider>(builder: (context, prov, __) {
      return PageHeader(
        title: "Goals",
        subtitle: "${prov.goals.length} Goals",
        trailingIcon: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(Routes.newGoal);
          },
          child: Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryColor,
            ),
            child: const Center(
              child: Icon(Icons.add_rounded, color: Colors.white, size: 42),
            ),
          ),
        ),
      );
    });
  }
}


class _TypeFilter extends StatelessWidget {
  const _TypeFilter({
    required this.prov,
  });

  final GoalsListProvider prov;

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
                                          // prov.filterTasksByTimeframe(item);
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
                            color: prov.selectedTypeFilter.value != null
                                ? Colors.white
                                : AppTypography.textDefaultColor)),
                    const SizedBox(
                      width: 7.75,
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: prov.selectedTypeFilter.value != null
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
