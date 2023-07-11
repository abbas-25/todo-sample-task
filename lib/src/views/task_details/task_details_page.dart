// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:todo_sample/src/common_widgets/page_header.dart';
import 'package:todo_sample/src/common_widgets/primary_appbar.dart';
import 'package:todo_sample/src/config/app_theme.dart';
import 'package:todo_sample/src/providers/edit_tasks_provider.dart';
import 'package:todo_sample/src/utils/utils.dart';
import 'package:todo_sample/src/views/task_details/widgets/single_task_preview_detail_widget.dart';

import '../../models/task.dart';

class TaskDetailsPage extends StatelessWidget {
  final Task task;
  const TaskDetailsPage({
    Key? key,
    required this.task,
  }) : super(key: key);

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
                              title: "Task",
                              value: task.title,
                              showDivider: true,
                            ),
                            SingleTaskPreviewDetailWidget(
                              title: "Type",
                              value:
                                  Utils.capitalizeWord(task.getTaskTypeString),
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
                              value: Utils.capitalizeWord(task.timeframe),
                              showDivider: true,
                            ),
                            SingleTaskPreviewDetailWidget(
                              title: "Description",
                              value: task.description,
                              showDivider: true,
                            ),
                            SingleTaskPreviewDetailWidget(
                              title: "Goal",
                              value: task.goal.toString(),
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
    );
  }

  PreferredSize _buildAppBar() {
    return const PreferredSize(
        preferredSize: Size(double.infinity, 65), child: PrimaryAppBar());
  }

  PageHeader _buildPageHeader(BuildContext context) {
    return PageHeader(
      title: "Task Preview",
      trailingIcon: InkWell(
        onTap: () {
          Provider.of<EditTaskProvider>(context, listen: false)
              .deleteDocument(task).then((value) => Navigator.of(context).pop());
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
