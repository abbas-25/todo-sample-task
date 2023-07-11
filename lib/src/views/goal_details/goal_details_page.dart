// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:todo_sample/src/common_widgets/page_header.dart';
import 'package:todo_sample/src/common_widgets/primary_appbar.dart';
import 'package:todo_sample/src/config/app_theme.dart';
import 'package:todo_sample/src/models/goal.dart';
import 'package:todo_sample/src/providers/edit_goals_provider.dart';
import 'package:todo_sample/src/providers/edit_tasks_provider.dart';
import 'package:todo_sample/src/views/task_details/widgets/single_task_preview_detail_widget.dart';


class GoalDetailPage extends StatelessWidget {
  final Goal goal;
  const GoalDetailPage({
    Key? key,
    required this.goal,
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
                              title: "Goal",
                              value: goal.title,
                              showDivider: true,
                            ),
                            SingleTaskPreviewDetailWidget(
                              title: "Type",
                              value: goal.type,
                              showDivider: true,
                            ),
                            SingleTaskPreviewDetailWidget(
                              title: "Description",
                              value: goal.description,
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
      title: "Goal Details",
      trailingIcon: InkWell(
        onTap: () {
          Provider.of<EditGoalsProvider>(context, listen: false)
              .deleteDocument(goal).then((value) => Navigator.of(context).pop());
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
