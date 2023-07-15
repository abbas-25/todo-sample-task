import 'package:flutter/material.dart';
import 'package:todo_sample/src/config/typography.dart';

class PrimaryAppBar extends StatelessWidget {
  const PrimaryAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).canvasColor,
      elevation: 0,
      leading:
          Navigator.of(context).canPop() ?  InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTypography.textDefaultColor)) : null,
    );
  }
}
