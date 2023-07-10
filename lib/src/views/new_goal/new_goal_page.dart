// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_sample/src/common_widgets/custom_dropdown.dart';

import 'package:todo_sample/src/common_widgets/custom_textfield.dart';
import 'package:todo_sample/src/common_widgets/page_header.dart';
import 'package:todo_sample/src/common_widgets/primary_appbar.dart';
import 'package:todo_sample/src/common_widgets/primary_button.dart';
import 'package:todo_sample/src/models/goal.dart';
import 'package:todo_sample/src/providers/edit_goals_provider.dart';

class NewGoalPage extends StatefulWidget {
  const NewGoalPage({super.key});

  @override
  State<NewGoalPage> createState() => _NewGoalPageState();
}

class _NewGoalPageState extends State<NewGoalPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  String? type;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Consumer<EditGoalsProvider>(builder: (context, prov, _) {
          return Stack(
            children: [
              Positioned.fill(
                child: IgnorePointer(
                  ignoring: prov.isProcessing ? true : false,
                  child: Opacity(
                    opacity: prov.isProcessing ? 0.5 : 1,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            _buildPageHeader(),
                            const SizedBox(height: 32),
                            CustomTextField(
                                headline: "Goal",
                                hint: "Text",
                                controller: titleController),
                            gap,
                            CustomDropdown(
                                headline: "Type",
                                options: const [
                                  "Work",
                                  "Personal Project",
                                  "Self"
                                ],
                                onSelect: (v) {
                                  type = v;
                                }),
                            gap,
                            CustomTextField(
                                headline: "Description",
                                controller: descController,
                                hint: "",
                                maxLines: 4),
                            const SizedBox(
                              height: 64,
                            ),
                            PrimaryButton(
                              title: "Submit",
                              onTap: () {
                                if (type == null ||
                                    titleController.text.trim().isEmpty ||
                                    descController.text.trim().isEmpty) {
                                  // todo add toast here to
                                  return;
                                }

                                prov
                                    .createGoalFromDb(
                                        goal: Goal(
                                      id: "",
                                      title: titleController.text.trim(),
                                      type: type!,
                                      description: descController.text.trim(),
                                    ))
                                    .then(
                                        (value) => Navigator.of(context).pop());
                              },
                            ),
                            const SizedBox(height: 100)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (prov.isProcessing)
                const Center(child: CircularProgressIndicator()),
            ],
          );
        }),
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
      title: "New Goal",
    );
  }
}
