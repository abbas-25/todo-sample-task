import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_sample/src/common_widgets/primary_appbar.dart';
import 'package:todo_sample/src/config/app_theme.dart';
import 'package:todo_sample/src/providers/tasks_list_provider.dart';
import 'package:todo_sample/src/routes/routes.dart';
import 'package:todo_sample/src/views/tasks_list/widgets/single_task_tile_widget.dart';
import 'package:todo_sample/src/common_widgets/page_header.dart';

class TasksListPage extends StatefulWidget {
  const TasksListPage({super.key});

  @override
  State<TasksListPage> createState() => _TasksListPageState();
}

class _TasksListPageState extends State<TasksListPage> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<TasksListProvider>(context, listen: false).getTasksFromDb();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            _buildPageHeader(context),
            const SizedBox(height: 32),
            Expanded(
              child: Consumer<TasksListProvider>(builder: (context, prov, __) {
                if (prov.isLoadingTasks) {
                  return const Center(child: CircularProgressIndicator());
                } else if (prov.tasks.isEmpty) {
                  return const Center(child: Text("No Tasks Created!"));
                }

                return ListView.builder(
                    itemCount: prov.tasks.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          SingleTaskTileWidget(task: prov.tasks[index]),
                          const SizedBox(height: 16),
                        ],
                      );
                    });
              }),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSize _buildAppBar() {
    return const PreferredSize(
        preferredSize: Size(double.infinity, 65), child: PrimaryAppBar());
  }

  Widget _buildPageHeader(BuildContext context) {
    return Consumer<TasksListProvider>(builder: (context, prov, __) {
      return PageHeader(
        title: "Tasks",
        subtitle: "${prov.tasks.length} Tasks",
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
    });
  }
}
