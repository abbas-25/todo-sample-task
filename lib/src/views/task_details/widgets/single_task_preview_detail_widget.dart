import 'package:flutter/material.dart';
import 'package:todo_sample/src/config/typography.dart';

class SingleTaskPreviewDetailWidget extends StatelessWidget {
  final String title;
  final String value;
  final bool showDivider;
  const SingleTaskPreviewDetailWidget({
    Key? key,
    required this.title,
    required this.value,
    required this.showDivider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: AppTypography.subtitle.copyWith(
                fontWeight: FontWeight.w300, color: const Color(0xff555555))),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTypography.title.copyWith(color: const Color(0xff2A2A2A)),
        ),
        const SizedBox(height: 24),
        if (showDivider) ...[
          const Divider(),
          const SizedBox(height: 24),
        ]
      ],
    );
  }
}
