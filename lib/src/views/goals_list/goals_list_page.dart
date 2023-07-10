import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_sample/src/common_widgets/primary_appbar.dart';
import 'package:todo_sample/src/config/app_theme.dart';
import 'package:todo_sample/src/providers/goals_list_provider.dart';
import 'package:todo_sample/src/routes/routes.dart';
import 'package:todo_sample/src/views/goals_list/widgets/single_goal_tile_widget.dart';
import 'package:todo_sample/src/common_widgets/page_header.dart';

class GoalsListPage extends StatefulWidget {
  const GoalsListPage({super.key});

  @override
  State<GoalsListPage> createState() => _GoalsListPageState();
}

class _GoalsListPageState extends State<GoalsListPage> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<GoalsListProvider>(context, listen: false).getGoalsFromDb();
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
              child: Consumer<GoalsListProvider>(builder: (context, prov, __) {
                if (prov.isLoadingGoals) {
                  return const Center(child: CircularProgressIndicator());
                } else if (prov.goals.isEmpty) {
                  return const Center(child: Text("No Goals Created!"));
                }

                return ListView.builder(
                    itemCount: prov.goals.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          SingleGoalTileWidget(goal: prov.goals[index]),
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
    return Consumer<GoalsListProvider>(builder: (context, prov, __) {
      return PageHeader(
        title: "Goals",
        subtitle: "${prov.goals.length} Goals",
        trailingIcon: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(Routes.newGoal);
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
