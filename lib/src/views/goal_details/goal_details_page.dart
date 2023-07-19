// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:todo_sample/src/common_widgets/page_header.dart';
import 'package:todo_sample/src/common_widgets/primary_appbar.dart';
import 'package:todo_sample/src/common_widgets/primary_button.dart';
import 'package:todo_sample/src/config/app_theme.dart';
import 'package:todo_sample/src/config/typography.dart';
import 'package:todo_sample/src/models/goal.dart';
import 'package:todo_sample/src/providers/edit_goals_provider.dart';
import 'package:todo_sample/src/providers/edit_tasks_provider.dart';
import 'package:todo_sample/src/providers/goal_details_provider.dart';
import 'package:todo_sample/src/views/task_details/widgets/single_task_preview_detail_widget.dart';
import 'package:todo_sample/src/views/tasks_list/widgets/single_task_tile_widget.dart';

class GoalDetailPage extends StatefulWidget {
  final Goal goal;
  const GoalDetailPage({
    Key? key,
    required this.goal,
  }) : super(key: key);

  @override
  State<GoalDetailPage> createState() => _GoalDetailPageState();
}

class _GoalDetailPageState extends State<GoalDetailPage> {
  late GoalDetailsProvider prov;

  @override
  void initState() {
    super.initState();
    prov = Provider.of<GoalDetailsProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Consumer<EditTaskProvider>(
        builder: (context, prov, __) {
          return Stack(
            children: [
              Positioned.fill(
                child: IgnorePointer(
                  ignoring: prov.isProcessing,
                  child: Opacity(
                    opacity: prov.isProcessing ? 0.5 : 1,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildPageHeader(context),
                            const SizedBox(height: 32),
                            SingleTaskPreviewDetailWidget(
                              title: "Goal",
                              value: widget.goal.title,
                              showDivider: true,
                            ),
                            SingleTaskPreviewDetailWidget(
                              title: "Type",
                              value: widget.goal.type,
                              showDivider: true,
                            ),
                            SingleTaskPreviewDetailWidget(
                              title: "Description",
                              value: widget.goal.description,
                              showDivider: false,
                            ),
                            const SizedBox(height: 50)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (prov.isProcessing)
                const Center(child: CircularProgressIndicator()),
            ],
          );
        },
      ),
      bottomSheet: _buildTasksByGoalsButton(),
    );
  }

  Container _buildTasksByGoalsButton() {
    return Container(
        padding: const EdgeInsets.all(20),
        child: PrimaryOutlineButton(
            title: "View Tasks",
            onTap: () {
              prov.getTasksFromDb(widget.goal.id);
              showModalBottomSheet(
                  isScrollControlled: true,
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.75,
                    maxHeight: MediaQuery.of(context).size.height * 0.75,
                  ),
                  backgroundColor: Theme.of(context).canvasColor,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  )),
                  context: context,
                  builder: (ctx) {
                    return ValueListenableBuilder(
                        valueListenable: prov.loadingTasks,
                        builder: (context, _, __) {
                          if (prov.loadingTasks.value) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return SingleChildScrollView(
                                child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 30),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Tasks",
                                      style: AppTypography.headline1.copyWith(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  if (prov.tasksByGoals.isEmpty)
                                    const Padding(
                                      padding: EdgeInsets.only(top: 50),
                                      child: Text(
                                        "No Tasks to show!",
                                        style: AppTypography.caption,
                                      ),
                                    ),
                                  for (final item in prov.tasksByGoals)
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16),
                                        child:
                                            SingleTaskTileWidget(task: item)),
                                ],
                              ),
                            ));
                          }
                        });
                  });
            }));
  }

  PreferredSize _buildAppBar() {
    return const PreferredSize(
        preferredSize: Size(double.infinity, 65), child: PrimaryAppBar());
  }

  PageHeader _buildPageHeader(BuildContext context) {
    return PageHeader(
      title: "Goal Details",
      trailingIcon: InkWell(
        onTap: () {
          Provider.of<EditGoalsProvider>(context, listen: false)
              .deleteDocument(widget.goal)
              .then((value) => Navigator.of(context).pop());
        },
        child: Container(
          height: 48,
          width: 48,
          decoration: const BoxDecoration(
            color: Color(0xffEDF3FF),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset("assets/icons/dustbin.svg",
                height: 23.33, width: 21, color: AppTheme.primaryColor),
          ),
        ),
      ),
    );
  }
}
