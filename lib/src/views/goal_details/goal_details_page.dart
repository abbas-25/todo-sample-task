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
  late GoalDetailsProvider detailsProv;

  @override
  void initState() {
    super.initState();
    detailsProv = Provider.of<GoalDetailsProvider>(context, listen: false);
    detailsProv.init(widget.goal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: ValueListenableBuilder(
        valueListenable: detailsProv.loadingGoal,
        builder: (context, _, __) {
          if(detailsProv.loadingGoal.value) {
            return const Center(child: CircularProgressIndicator(),);
          }
          return  ValueListenableBuilder(
              valueListenable: detailsProv.processing,
              builder: (context, _, __) {
                return Stack(
                  children: [
                    Positioned.fill(
                      child: IgnorePointer(
                        ignoring: detailsProv.processing.value,
                        child: Opacity(
                          opacity: detailsProv.processing.value ? 0.5 : 1,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildPageHeader(context),
                                  const SizedBox(height: 24),
                                  _buildOptions(),
                                  const SizedBox(height: 24),
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
                    if (detailsProv.processing.value)
                      const Center(child: CircularProgressIndicator()),
                  ],
                );
              });
        }
      ),
      bottomSheet: _buildTasksByGoalsButton(),
    );
  }

  Widget _buildOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ValueListenableBuilder(
          valueListenable: detailsProv.isCompleted,
          builder: (c, _, __) => DetailsPageOption(
            icon: "assets/icons/complete-tick.svg",
            state: detailsProv.isCompleted.value,
            title: "Complete",
            onTap: () {
              if (detailsProv.isCompleted.value) {
                return;
              } else {
                detailsProv.markGoalAsComplete(goal: widget.goal);
              }
            },
          ),
        ),
        const SizedBox(
          width: 40,
        ),
        DetailsPageOption(
          icon: "assets/icons/clock.svg",
          state: true,
          title: "Add Time",
          onTap: () {
            // todo show add time poppup
          },
        ),
      ],
    );
  }

  Container _buildTasksByGoalsButton() {
    return Container(
        padding: const EdgeInsets.all(20),
        child: PrimaryOutlineButton(
            title: "View Tasks",
            onTap: () {
              detailsProv.getTasksFromDb(widget.goal.id);
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
                        valueListenable: detailsProv.loadingTasks,
                        builder: (context, _, __) {
                          if (detailsProv.loadingTasks.value) {
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
                                  if (detailsProv.tasksByGoals.isEmpty)
                                    const Padding(
                                      padding: EdgeInsets.only(top: 50),
                                      child: Text(
                                        "No Tasks to show!",
                                        style: AppTypography.caption,
                                      ),
                                    ),
                                  for (final item in detailsProv.tasksByGoals)
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
    return const PageHeader(
      title: "Goal Details",
      // trailingIcon: InkWell(
      //   onTap: () {
      //     Provider.of<EditGoalsProvider>(context, listen: false)
      //         .deleteDocument(widget.goal)
      //         .then((value) => Navigator.of(context).pop());
      //   },
      // ),
    );
  }
}

class DetailsPageOption extends StatelessWidget {
  final Function onTap;
  final String icon;
  final bool state;
  final String title;
  const DetailsPageOption({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.state,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => onTap(),
          // child: Container(
          //   height: 48,
          //   width: 48,
          //   decoration: BoxDecoration(
          //     color: state ? const Color(0xffEDF3FF) : Colors.transparent,
          //     shape: BoxShape.circle,
          //   ),
          child: Center(
            child: SvgPicture.asset(
              icon,
              color: state ? AppTheme.primaryColor : Colors.grey,
            ),
            // ),
          ),
        ),
        const SizedBox(
          height: 6,
        ),
        Text(
          title,
          style: AppTypography.subtitle2.copyWith(color: AppTheme.primaryColor),
        )
      ],
    );
  }
}
