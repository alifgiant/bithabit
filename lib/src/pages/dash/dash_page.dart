import 'package:bithabit/src/model/habit.dart';
import 'package:flutter/material.dart';

import '../../utils/view/app_bar_title.dart';
import 'completed_count.dart';

class DashPage extends StatelessWidget {
  const DashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar.large(
              pinned: true,
              actions: [
                IconButton(
                  onPressed: () => Navigator.of(context).pushNamed('/detail'),
                  tooltip: 'Add Habit',
                  icon: const Icon(Icons.add_rounded),
                ),
                IconButton(
                  onPressed: () {},
                  tooltip: 'Sort Habit',
                  icon: const Icon(Icons.sort_rounded),
                ),
              ],
              expandedHeight: 140.0,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CompletedCount(
                        completed: 1,
                        total: 4,
                      ),
                    ],
                  ),
                ),
                centerTitle: false,
                titlePadding: const EdgeInsets.all(16),
                title: const AppBarTitle(),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return ListTile(
                    title: Text('Item $index'),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        '/detail',
                        arguments: Habit(
                          index.toString(),
                          index.toString(),
                          HabitColor.lightBlue,
                        ),
                      );
                    },
                  );
                },
                childCount: 20,
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: kBottomNavigationBarHeight + 16),
            )
          ],
        ),
      ),
    );
  }
}
