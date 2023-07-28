// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo_sample/src/common_widgets/page_header.dart';
import 'package:todo_sample/src/common_widgets/primary_appbar.dart';
import 'package:todo_sample/src/common_widgets/primary_button.dart';
import 'package:todo_sample/src/providers/edit_tasks_provider.dart';
import 'package:todo_sample/src/providers/task_details_provider.dart';
import 'package:todo_sample/src/utils/utils.dart';
import 'package:todo_sample/src/views/goal_details/goal_details_page.dart';
import 'package:todo_sample/src/views/task_details/widgets/single_task_preview_detail_widget.dart';

import '../../models/task.dart';

class TaskDetailsPage extends StatefulWidget {
  final Task task;
  const TaskDetailsPage({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  late TaskDetailsProvider detailsProvider;
  @override
  void initState() {
    detailsProvider = Provider.of<TaskDetailsProvider>(context, listen: false);
    Future.delayed(Duration.zero, () {
      detailsProvider.updateCompletedStatus(widget.task);
      if (widget.task.goalId != null) {
        detailsProvider.fetchGoal(widget.task.goalId!);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    detailsProvider.reset();
    super.dispose();
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
                            const SizedBox(height: 24),
                            _buildOptions() , 
                            const SizedBox(height: 24),
                            const SizedBox(height: 32),
                            SingleTaskPreviewDetailWidget(
                              title: "Task",
                              value: widget.task.title,
                              showDivider: true,
                            ),
                            SingleTaskPreviewDetailWidget(
                              title: "Type",
                              value: Utils.capitalizeWord(
                                  widget.task.getTaskTypeString),
                              showDivider: true,
                            ),
                            SingleTaskPreviewDetailWidget(
                              title: "Priority",
                              value: Utils.capitalizeWord(
                                  widget.task.getTaskPriorityString),
                              showDivider: true,
                            ),
                            SingleTaskPreviewDetailWidget(
                              title: "Timeframe",
                              value:
                                  Utils.capitalizeWord(widget.task.timeframe),
                              showDivider: true,
                            ),
                            SingleTaskPreviewDetailWidget(
                              title: "Description",
                              value: widget.task.description,
                              showDivider: true,
                            ),
                            if (widget.task.goalId != null)
                              ValueListenableBuilder(
                                  valueListenable:
                                      detailsProvider.isLoadingGoal,
                                  builder: (context, _, __) {
                                    return detailsProvider.goal.value == null ||
                                            detailsProvider.isLoadingGoal.value
                                        ? const Text('')
                                        : SingleTaskPreviewDetailWidget(
                                            title: "Goal",
                                            value: detailsProvider
                                                    .goal.value?.title ??
                                                "",
                                            showDivider: false,
                                          );
                                  }),
                            const SizedBox(height: 100)
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
      bottomSheet: Padding(
        padding: const EdgeInsets.all(20),
        child: ValueListenableBuilder(
            valueListenable: detailsProvider.isMarkingTaskForToday,
            builder: (context, _, __) {
              return PrimaryButton(
                  isLoading: detailsProvider.isMarkingTaskForToday.value,
                  title: widget.task.isMarkedForToday
                      ? "Remove From Today's Task"
                      : "Move to Today's Task",
                  onTap: () async {
                    if (widget.task.isMarkedForToday) {
                      detailsProvider
                          .removeTaskForToday(widget.task)
                          .then((value) {
                        if (value) {
                          Navigator.of(context).pop(true);
                        } else {
                          // todo show toast
                        }
                      });
                    } else {
                      detailsProvider
                          .markTaskForToday(widget.task)
                          .then((value) {
                        if (value) {
                          Navigator.of(context).pop(true);
                        } else {
                          // todo show toast
                        }
                      });
                    }
                  });
            }),
      ),
    );
  }

  PreferredSize _buildAppBar() {
    return const PreferredSize(
        preferredSize: Size(double.infinity, 65), child: PrimaryAppBar());
  }

  Widget _buildOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ValueListenableBuilder(
          valueListenable: detailsProvider.isCompleted,
          builder: (c, _, __) => DetailsPageOption(
            icon: "assets/icons/complete-tick.svg",
            state: detailsProvider.isCompleted.value,
            title: "Complete",
            onTap: () {
              detailsProvider.toggleTaskComplete(widget.task);
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

  PageHeader _buildPageHeader(BuildContext context) {
    return const PageHeader(
      title: "Task Preview",
      // trailingIcon: InkWell(
      //   onTap: () {
      //     Provider.of<EditTaskProvider>(context, listen: false)
      //         .deleteDocument(widget.task)
      //         .then((value) => Navigator.of(context).pop(true));
      //   },
      //   child: Container(
      //     height: 48,
      //     width: 48,
      //     decoration: const BoxDecoration(
      //       color: Color(0xffEDF3FF),
      //       shape: BoxShape.circle,
      //     ),
      //     child: Center(
      //       child: SvgPicture.asset("assets/icons/dustbin.svg",
      //           height: 23.33, width: 21, color: AppTheme.primaryColor),
      //     ),
      //   ),
      // ),
    );
  }
}
