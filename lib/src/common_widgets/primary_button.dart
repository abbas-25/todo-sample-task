import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todo_sample/src/config/typography.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final Function? onTap;
  const PrimaryButton({
    Key? key,
    required this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
          height: 56,
          width: double.infinity,
          child: ElevatedButton(
              onPressed: () {
                log("Button tapped");
                if (onTap != null) {
                  onTap!();
                }
              },
              child: Text(
                title,
                style: AppTypography.button,
              ))),
    );
  }
}
