// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:todo_sample/src/config/typography.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailingIcon;
  const PageHeader({
    Key? key,
    required this.title,
    this.subtitle,
    this.trailingIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildHeading(title: title, subtitle: subtitle),
        if (trailingIcon != null) trailingIcon!,
      ],
    );
  }

  Column _buildHeading({required String title, String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style:
                AppTypography.headline3.copyWith()),
        if (subtitle != null)
          Text(
            subtitle,
            style:
                AppTypography.subtitle.copyWith(color: const Color(0xff808080)),
          )
      ],
    );
  }
}
