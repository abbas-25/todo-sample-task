// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:todo_sample/src/config/typography.dart';
import 'package:todo_sample/src/models/menu.dart';

class SingleMenuItemWidget extends StatelessWidget {
  final MenuItem item;
  final int itemCount;
  const SingleMenuItemWidget({
    Key? key,
    required this.item,
    required this.itemCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(item.route);
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTypography.title.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 2),
                Text("$itemCount ${item.title}", style: AppTypography.caption),
              ],
            ),
            const Spacer(),
            Image.asset(item.image, fit: BoxFit.cover, height: 120,),
            const SizedBox(width: 32)
          ],
        ),
      ),
    );
  }
}
