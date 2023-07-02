// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:todo_sample/src/config/typography.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final String? headline;
  final int? maxLines;
  final TextEditingController controller;
  const CustomTextField({
    Key? key,
    required this.hint,
    this.headline,
    this.maxLines,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (headline != null) ...[
          Text(headline!,
              style: AppTypography.title2
                  .copyWith(color: const Color(0xff2A2A2A))),
          const SizedBox(height: 4),
        ],
        SizedBox(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(color: const Color(0xffE9E9E9), width: 1),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                      color: const Color(0xff000000).withOpacity(0.05),
                      spreadRadius: 0)
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: TextField(
                  controller: controller,
                  maxLines: maxLines,
                  style: AppTypography.input,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      hintStyle: AppTypography.input
                          .copyWith(color: const Color(0xff808080)),
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      hintText: "Text",
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Color(0xff4942E4)))),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
