// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:todo_sample/src/config/app_theme.dart';
import 'package:todo_sample/src/config/typography.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> options;
  final String? headline;
  final Function(String? value) onSelect;

  const CustomDropdown({
    Key? key,
    required this.options,
    this.headline,
    required this.onSelect,
  }) : super(key: key);

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? selected;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.headline != null) ...[
          Text(widget.headline!,
              style: AppTypography.title2
                  .copyWith(color: const Color(0xff2A2A2A))),
          const SizedBox(height: 4),
        ],
        SizedBox(
          height: 60,
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
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: DropdownButton<String>(
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      items: widget.options
                          .map((e) => DropdownMenuItem<String>(
                              value: e,
                              child: Text(e, style: AppTypography.dropdown)))
                          .toList(),
                      value: selected,
                      onChanged: (value) {
                        setState(() {
                          selected = value;
                        });
                        widget.onSelect(value);
                      },
                      isExpanded: true,
                      iconEnabledColor: AppTheme.primaryColor,
                      style: AppTypography.input,
                      underline: Container(),
                      dropdownColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
