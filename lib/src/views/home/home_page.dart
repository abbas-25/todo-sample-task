import 'package:flutter/material.dart';
import 'package:todo_sample/src/config/app_theme.dart';
import 'package:todo_sample/src/config/typography.dart';
import 'package:todo_sample/src/views/home/widgets/single_menu_item_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Text(
                "Sample App",
                style: AppTypography.headline1
                    .copyWith(color: AppTheme.primaryColor),
              ),
              const SizedBox(height: 40),
              const SingleMenuItemWidget()
            ],
          ),
        ),
      ),
    );
  }
}
