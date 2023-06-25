// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:todo_sample/src/config/app_theme.dart';
import 'package:todo_sample/src/config/typography.dart';

import 'package:todo_sample/src/models/task.dart';
import 'package:todo_sample/src/routes/routes.dart';
import 'package:todo_sample/src/utils/utils.dart';

class SingleTaskTileWidget extends StatelessWidget {
  final Task task;
  const SingleTaskTileWidget({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(Routes.taskDetails, arguments: task);
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0x0ff2f2f2),
              width: 1,
            ),
            color: Colors.white,
            gradient: const LinearGradient(colors: [
              Color(0xffFFFFFF),
              Color(0xffEDF3FF),
            ]),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff000000).withOpacity(0.05),
                offset: const Offset(0, 4),
                blurRadius: 20,
                spreadRadius: 0,
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 16, 20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.title2,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
                    Text(Utils.capitalizeWord(task.timeframe),
                        style: AppTypography.caption.copyWith(
                          color: const Color(0xff808080),
                        )),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.arrow_forward_ios_rounded,
                  color: AppTheme.primaryColor, size: 18)
            ],
          ),
        ),
      ),
    );
  }
}
