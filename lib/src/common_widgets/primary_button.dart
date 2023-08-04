// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:todo_sample/src/config/app_theme.dart';
import 'package:todo_sample/src/config/typography.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final Function? onTap;
  final bool isLoading;
  final bool isDisabled;
  final Widget? icon;
  const PrimaryButton({
    Key? key,
    required this.title,
    this.onTap,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
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
                if (isDisabled || isLoading) return;
                if (onTap != null) {
                  onTap!();
                }
              },
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : icon != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            icon!,
                            const SizedBox(width: 8),
                            _buildText(),
                          ],
                        )
                      : _buildText())),
    );
  }

  Text _buildText() {
    return Text(
      title,
      style: AppTypography.button.copyWith(),
    );
  }
}

class PrimaryOutlineButton extends StatelessWidget {
  final String title;
  final Function? onTap;
  final bool isLoading;
  final bool isDisabled;
  const PrimaryOutlineButton({
    Key? key,
    required this.title,
    this.isLoading = false,
    this.isDisabled = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        // margin: const EdgeInsets.all(12),
        height: 56,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: OutlinedButton(
              style: ButtonStyle(
                side: MaterialStateProperty.resolveWith<BorderSide>(
                    (Set<MaterialState> states) {
                  return BorderSide(
                    color: isDisabled ? Colors.grey : AppTheme.primaryColor,
                    width: 2,
                  );
                }),
              ),
              onPressed: () {
                if (isDisabled || isLoading) return;
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
                      style: AppTypography.button
                          .copyWith(color: AppTheme.primaryColor),
                    )),
        ));
  }
}
