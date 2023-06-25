import 'package:flutter/material.dart';
import 'package:todo_sample/src/common_widgets/primary_appbar.dart';
import 'package:todo_sample/src/config/app_theme.dart';
import 'package:todo_sample/src/config/dummy_data.dart';
import 'package:todo_sample/src/models/task.dart';
import 'package:todo_sample/src/routes/routes.dart';
import 'package:todo_sample/src/views/tasks_list/widgets/single_task_tile_widget.dart';
import 'package:todo_sample/src/common_widgets/page_header.dart';

class TasksListPage extends StatefulWidget {
  const TasksListPage({super.key});

  @override
  State<TasksListPage> createState() => _TasksListPageState();
}

class _TasksListPageState extends State<TasksListPage> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    tasks = DummyData.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _buildPageHeader(context),
              const SizedBox(height: 32),
              for (final task in tasks) ...[
                SingleTaskTileWidget(task: task), 
                const SizedBox(height: 16)
              ],
            ],
          ),
        ),
      ),
    );
  }

  PreferredSize _buildAppBar() {
    return const PreferredSize(
        preferredSize: Size(double.infinity, 65), child: PrimaryAppBar());
  }

  PageHeader _buildPageHeader(BuildContext context) {
    return PageHeader(
      title: "Tasks",
      subtitle: "${tasks.length} Tasks",
      trailingIcon: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(Routes.newTask);
        },
        child: Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.primaryColor,
          ),
          child: const Center(
            child: Icon(Icons.add_rounded, color: Colors.white, size: 42),
          ),
        ),
      ),
    );
  }
}