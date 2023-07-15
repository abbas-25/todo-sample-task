import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todo_sample/src/config/app_theme.dart';
import 'package:todo_sample/src/config/typography.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final Function? onTap;
  final bool isLoading;
  final bool isDisabled;
  const PrimaryButton({
    Key? key,
    required this.title,
    this.isLoading = false,
    this.isDisabled = false,
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
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  return isDisabled ? Colors.grey : AppTheme.primaryColor;
                }),
              ),
              onPressed: () {
                log("Button tapped");
                if (isDisabled) return;
                if (onTap != null) {
                  onTap!();
                }
              },
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : Text(
                      title,
                      style: AppTypography.button.copyWith(),
                    ))),
    );
  }
}
