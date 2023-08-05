// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'package:todo_sample/src/common_widgets/page_header.dart';
import 'package:todo_sample/src/common_widgets/primary_appbar.dart';
import 'package:todo_sample/src/common_widgets/primary_button.dart';
import 'package:todo_sample/src/config/app_theme.dart';
import 'package:todo_sample/src/config/typography.dart';
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
      detailsProvider.init(widget.task.id, widget.task.goalId);
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
    return  Scaffold(
          appBar: _buildAppBar(),
          body: ValueListenableBuilder(
              valueListenable: detailsProvider.isLoadingTaskAndGoal,
              builder: (context, dp, __) {
                log("TSK task.value rebuilding2 ${detailsProvider.task.value?.totalMinutesSpent}");
                if (detailsProvider.isLoadingTaskAndGoal.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final task = detailsProvider.task.value!;
                return  Stack(
                      children: [
                        Positioned.fill(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  _buildPageHeader(context),
                                  ValueListenableBuilder(
                                      valueListenable:
                                          detailsProvider.isCompleted,
                                      builder: (context, _, __) {
                                        if (!detailsProvider
                                            .isCompleted.value) {
                                          return const Text("");
                                        }
                                        return const CompleteWidget(
                                            text:
                                                "This task is complete");
                                      }),
                                  const SizedBox(height: 32),
                                  _buildOptions(),
                                  const SizedBox(height: 24),
                                  const SizedBox(height: 32),
                                  SingleTaskPreviewDetailWidget(
                                    title: "Task",
                                    value: task.title,
                                    showDivider: true,
                                  ),
                                  SingleTaskPreviewDetailWidget(
                                    title: "Type",
                                    value: Utils.capitalizeWord(
                                        task.getTaskTypeString),
                                    showDivider: true,
                                  ),
                                  SingleTaskPreviewDetailWidget(
                                    title: "Priority",
                                    value: Utils.capitalizeWord(
                                        task.getTaskPriorityString),
                                    showDivider: true,
                                  ),
                                  SingleTaskPreviewDetailWidget(
                                    title: "Timeframe",
                                    value: Utils.capitalizeWord(
                                        task.timeframe),
                                    showDivider: true,
                                  ),
                                  SingleTaskPreviewDetailWidget(
                                    title: "Description",
                                    value: task.description,
                                    showDivider: true,
                                  ),
                                  ValueListenableBuilder(
                                      valueListenable:
                                          detailsProvider.task,
                                      builder: (context, _, __) {
                                        return SingleTaskPreviewDetailWidget(
                                          title: "Total Time Spent",
                                          value: Utils
                                              .hoursAndMinutesByMinutes(
                                                  task.totalMinutesSpent ??
                                                      0),
                                          showDivider: true,
                                        );
                                      }),
                                  SingleTaskPreviewDetailWidget(
                                    title: "Last Activity",
                                    value: DateFormat(
                                            "dd MMM, yyyy | HH:mm a")
                                        .format(task.updatedAt ??
                                            task.createdAt),
                                    showDivider: true,
                                  ),
                                  if (task.goalId != null)
                                    ValueListenableBuilder(
                                        valueListenable:
                                            detailsProvider
                                                .isLoadingTaskAndGoal,
                                        builder: (context, _, __) {
                                          return detailsProvider.goal
                                                          .value ==
                                                      null ||
                                                  detailsProvider
                                                      .isLoadingTaskAndGoal
                                                      .value
                                              ? const Text('')
                                              : SingleTaskPreviewDetailWidget(
                                                  title: "Goal",
                                                  value: detailsProvider
                                                          .goal
                                                          .value
                                                          ?.title ??
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
                      ],
                );
              }),
          bottomSheet: ValueListenableBuilder(
              valueListenable: detailsProvider.task,
              builder: (context, _, __) {
                // if (detailsProvider.isLoadingTaskAndGoal.value) {
                //   return const SizedBox.shrink();
                // }

                final task = detailsProvider.task.value;
                if(task == null) return const SizedBox.shrink();

                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: ValueListenableBuilder(
                      valueListenable: detailsProvider.isMarkingTaskForToday,
                      builder: (context, _, __) {
                        return PrimaryButton(
                            isLoading:
                                detailsProvider.isMarkingTaskForToday.value,
                            title: task.isMarkedForToday
                                ? "Remove From Today's Task"
                                : "Move to Today's Task",
                            onTap: () async {
                              if (task.isMarkedForToday) {
                                detailsProvider
                                    .removeTaskForToday(task)
                                    .then((value) {
                                  if (value) {
                                    Navigator.of(context).pop(true);
                                  } else {
                                    // todo show toast
                                  }
                                });
                              } else {
                                detailsProvider
                                    .markTaskForToday(task)
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
                );
              }),
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
              _showConfirmPopup();
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
            _showAddTimePopup();
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
      //         .deleteDocument(task)
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

  _showConfirmPopup() {
    showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              // contentPadding: const EdgeInsets.all(20),
              actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const PopupCloseButton(),
                  const SizedBox(
                    height: 8,
                  ),
                  Center(
                    child: Text(
                      "You are about to mark this task as ${detailsProvider.isCompleted.value ? "Incomplete" : "Complete"}!",
                      textAlign: TextAlign.center,
                      style: AppTypography.title2,
                    ),
                  ),
                ],
              ),
              actions: [
                PrimaryButton(
                  title: "Confirm",
                  onTap: () {
                    detailsProvider.toggleTaskComplete().then((value) {
                      Navigator.of(context).pop();
                    });
                  },
                )
              ],
            )));
  }

  _showAddTimePopup() {
    showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              // contentPadding: const EdgeInsets.all(20),
              actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const PopupCloseButton(),
                  const SizedBox(
                    height: 8,
                  ),
                  Center(
                    child: Text(
                      "Add Time",
                      textAlign: TextAlign.center,
                      style: AppTypography.title
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              actions: [
                AddTimeDialogButton(
                  onTap: () {
                    Navigator.of(context).pop();
                    _showStopwatchEntryPopup();
                  },
                  text: "Start/Stop Button",
                ),
                const SizedBox(height: 16),
                AddTimeDialogButton(
                  onTap: () {
                    Navigator.of(context).pop();
                    _showManualEntryPopup();
                  },
                  text: "Manual Entry",
                ),
              ],
            )));
  }

  _showManualEntryPopup() {
    int? hour;
    int? minutes;
    showDialog(
        context: context,
        builder: ((context) =>
            StatefulBuilder(builder: (context, setDialogState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const PopupCloseButton(),
                    const SizedBox(
                      height: 8,
                    ),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            "Manual Entry",
                            textAlign: TextAlign.center,
                            style: AppTypography.title
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                              "Input the amount of time that you have spent on this task.",
                              textAlign: TextAlign.center,
                              style: AppTypography.caption),
                          const SizedBox(height: 24),

                          /// hours minutes select section
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Hours",
                              textAlign: TextAlign.center,
                              style: AppTypography.subtitle2
                                  .copyWith(fontWeight: FontWeight.w400),
                            ),
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            height: 40,
                            width: double.maxFinite,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              primary: false,
                              itemCount: 100,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                final bool isSelected = index == hour;
                                return InkWell(
                                  onTap: () {
                                    if (isSelected) return;
                                    setDialogState(() {
                                      hour = index;
                                    });
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: isSelected
                                          ? AppTheme.primaryColor
                                          : const Color(0xffEDF3FF),
                                    ),
                                    child: Center(
                                      child: Text("$index",
                                          style: AppTypography.subtitle2
                                              .copyWith(
                                                  color: isSelected
                                                      ? Colors.white
                                                      : AppTypography
                                                          .textDefaultColor)),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 16),

                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Minutes",
                              textAlign: TextAlign.center,
                              style: AppTypography.subtitle2
                                  .copyWith(fontWeight: FontWeight.w400),
                            ),
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            height: 40,
                            width: double.maxFinite,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              primary: false,
                              itemCount: 4,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                final bool isSelected = index * 15 == minutes;
                                return InkWell(
                                  onTap: () {
                                    if (isSelected) return;
                                    setDialogState(() {
                                      minutes = index * 15;
                                    });
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 64,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: isSelected
                                          ? AppTheme.primaryColor
                                          : const Color(0xffEDF3FF),
                                    ),
                                    child: Center(
                                        child: Text(
                                      "${(index * 15)}",
                                      style: AppTypography.subtitle2.copyWith(
                                          color: isSelected
                                              ? Colors.white
                                              : AppTypography.textDefaultColor),
                                    )),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
                actions: [
                  PrimaryButton(
                      title: "Submit",
                      onTap: () {
                        if (hour == null && minutes == null) return;
                        final int mins = Utils.minutesByHoursAndTime(
                            hours: hour, minutes: minutes);
                        detailsProvider.updateTotalTime(minutes: mins);
                        Navigator.of(context).pop();
                      })
                ],
              );
            })));
  }

  _showStopwatchEntryPopup() {
    final StopWatchTimer stopWatchTimer = StopWatchTimer(); // Create instance.
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: ((context) =>
            StatefulBuilder(builder: (context, setDialogState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  PopupCloseButton(
                    callBeforeClosing: () {
                      stopWatchTimer.dispose();
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "Start/Stop",
                          textAlign: TextAlign.center,
                          style: AppTypography.title
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                            "Tap “Start” when you begin working. When you have finished tap “Stop”.",
                            textAlign: TextAlign.center,
                            style: AppTypography.caption),
                        const SizedBox(height: 32),

                        StreamBuilder(
                          stream: stopWatchTimer.rawTime,
                          initialData: 0,
                          builder: (context, snap) {
                            final value = snap.data;
                            if (value == null) return const SizedBox.shrink();

                            final displayTime = StopWatchTimer.getDisplayTime(
                              value,
                              hours: true,
                              minute: true,
                              second: false,
                              milliSecond: false,
                              hoursRightBreak: "h:",
                              minuteRightBreak: "m",
                            );
                            return Text(
                              "${displayTime}m",
                              style: AppTypography.headline1.copyWith(
                                  fontSize: 48, fontWeight: FontWeight.w400),
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        /// hours minutes select section
                      ],
                    ),
                  ),
                ]),
                actions: [
                  PrimaryButton(
                    icon: Image.asset(stopWatchTimer.isRunning ? "assets/icons/stop.png" : "assets/icons/start.png", height: 28, width: 28,),
                      title: stopWatchTimer.isRunning ? "Stop" : "Start",
                      onTap: () {
                        if (stopWatchTimer.isRunning) {
                          stopWatchTimer.onStopTimer();
                          detailsProvider.updateTotalTime(
                              minutes: stopWatchTimer.minuteTime.value);
                          stopWatchTimer.dispose();
                          Navigator.of(context).pop();
                        } else {
                          stopWatchTimer.onStartTimer();
                        }
                        setDialogState(() {});
                      })
                ],
              );
            })));
  }
}

class AddTimeDialogButton extends StatelessWidget {
  final Function() onTap;
  final String text;
  const AddTimeDialogButton({
    Key? key,
    required this.onTap,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xfff2f2f2),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 4))
            ]),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                text,
                style: AppTypography.subtitle,
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: AppTheme.primaryColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
