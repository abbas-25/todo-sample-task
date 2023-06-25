// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:todo_sample/src/common_widgets/custom_dropdown.dart';

import 'package:todo_sample/src/common_widgets/custom_textfield.dart';
import 'package:todo_sample/src/common_widgets/page_header.dart';
import 'package:todo_sample/src/common_widgets/primary_appbar.dart';
import 'package:todo_sample/src/common_widgets/primary_button.dart';

class NewTaskPage extends StatelessWidget {
  const NewTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _buildPageHeader(),
                const SizedBox(height: 32),
                const CustomTextField(headline: "Task", hint: "Text"),
                gap,
                const CustomDropdown(headline: "Type", options: [
                  "Work", "Personal Project", "Self"
                ]),
                gap,
                const CustomDropdown(headline: "Priority", options: [
                  "Needs done", "Nice to have", "Nice Idea"
                ]),
                gap,
                const CustomDropdown(headline: "Timeframe", options: [
                  "None", 
                  "Today", 
                  "3 days", 
                  "Week", "Fortnight", "Month", "90 Days", "Year"
                ]),
                gap,
                const CustomTextField(
                    headline: "Description", hint: "", maxLines: 4),
                const SizedBox(
                  height: 64,
                ),
                PrimaryButton(
                  title: "Submit",
                  onTap: () {},
                ),
                const SizedBox(height: 100)
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox get gap => const SizedBox(height: 24);

  PreferredSize _buildAppBar() {
    return const PreferredSize(
        preferredSize: Size(double.infinity, 65), child: PrimaryAppBar());
  }

  PageHeader _buildPageHeader() {
    return const PageHeader(
      title: "New Task",
    );
  }
}
