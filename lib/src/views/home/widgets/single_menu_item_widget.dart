import 'package:flutter/material.dart';
import 'package:todo_sample/src/config/app_theme.dart';
import 'package:todo_sample/src/config/typography.dart';
import 'package:todo_sample/src/routes/routes.dart';

class SingleMenuItemWidget extends StatelessWidget {
  const SingleMenuItemWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(Routes.tasksList);
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/images/laptop.png", height: 28, width: 28),
              const SizedBox(width: 24),
              Column(
                children: const [
                  Text(
                    "Tasks",
                    style: AppTypography.title,
                  ),
                  SizedBox(height: 2),
                  Text("6 Tasks"),
                ],
              ),
              const Spacer(),
              Icon(Icons.arrow_forward_ios_rounded,
                  color: AppTheme.primaryColor, size: 18)
            ],
          ),
        ),
      ),
    );
  }
}
