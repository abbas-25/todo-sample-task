// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_sample/src/common_widgets/custom_dropdown.dart';

import 'package:todo_sample/src/common_widgets/custom_textfield.dart';
import 'package:todo_sample/src/common_widgets/page_header.dart';
import 'package:todo_sample/src/common_widgets/primary_appbar.dart';
import 'package:todo_sample/src/common_widgets/primary_button.dart';
import 'package:todo_sample/src/config/database_constants.dart';
import 'package:todo_sample/src/models/goal.dart';
import 'package:todo_sample/src/models/task.dart';
import 'package:todo_sample/src/providers/edit_tasks_provider.dart';

class NewTaskPage extends StatefulWidget {
  const NewTaskPage({super.key});

  @override
  State<NewTaskPage> createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  late EditTaskProvider provider;
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  String? type;
  String? priority;
  String? timeframe;

  @override
  void initState() {
    provider = Provider.of<EditTaskProvider>(context, listen: false);
    Future.delayed(Duration.zero, () {
      provider.getGoalsForDropdown();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            appBar: _buildAppBar(),
            body: Consumer<EditTaskProvider>(builder: (context, prov, _) {
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
                                    headline: "Task",
                                    hint: "Text",
                                    controller: titleController),
                                gap,
                                CustomDropdown<String>(
                                    headline: "Type",
                                    selectedValue: type,
                                    options: const [
                                      "Work",
                                      "Personal Project",
                                      "Self"
                                    ],
                                    onChanged: (v) {
                                      provider.chosenGoal = null;
                                      provider.updateGoals(v);
                                      type = v;
                                    }),
                                gap,
                                CustomDropdown<String>(
                                    selectedValue: priority,
                                    headline: "Priority",
                                    options: const [
                                      "Needs done",
                                      "Nice to have",
                                      "Nice Idea"
                                    ],
                                    onChanged: (v) {
                                      priority = v;
                                    }),
                                gap,
                                CustomDropdown<String>(
                                    selectedValue: timeframe,
                                    headline: "Timeframe",
                                    options: timeframes,
                                    onChanged: (v) {
                                      timeframe = v;
                                    }),
                                gap,
                                CustomTextField(
                                    headline: "Description",
                                    controller: descController,
                                    hint: "",
                                    maxLines: 4),
                                gap,
                                ValueListenableBuilder(
                                    valueListenable: provider.isGoalsUpdating,
                                    builder: (context, _, __) {
                                      return provider.isGoalsUpdating.value
                                          ? const Text("Updating Goals...")
                                          : CustomDropdown<Goal>(
                                              selectedValue:
                                                  provider.chosenGoal,
                                              headline: "Goals",
                                              onChanged: (g) {
                                                provider.chosenGoal = g;
                                              },
                                              options:
                                                  provider.goalsForDropdown,
                                            );
                                    }),
                                const SizedBox(
                                  height: 64,
                                ),
                                PrimaryButton(
                                  title: "Submit",
                                  onTap: () {
                                    if (type == null ||
                                        priority == null ||
                                        timeframe == null ||
                                        titleController.text.trim().isEmpty ||
                                        descController.text.trim().isEmpty) {
                                      // todo add toast here to
                                      return;
                                    }

                                    var task = Task(
                                      id: "", // not used in creation
                                      totalMinutesSpent: 0,
                                      updatedAt: null,
                                      createdAt: DateTime.now(),
                                      isMarkedForToday: timeframe!
                                              .toLowerCase()
                                              .contains("today")
                                          ? true
                                          : false,
                                      goalId: provider.chosenGoal?.id,
                                      expectedCompletion: null,
                                      title: titleController.text.trim(),
                                      type: type!,
                                      priority: priority!,
                                      timeframe: timeframe!,
                                      description: descController.text.trim(),
                                      isCompleted: false, 
                                    );

                                    task = task.copyWith(
                                        expectedCompletion:
                                            task.getExpectedDateFromTimeframe);

                                    prov.createTaskFromDb(task: task).then(
                                        (value) =>
                                            Navigator.of(context).pop(true));
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
            })));
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
