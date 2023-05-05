import 'package:flutter/material.dart';

class DashPage extends StatelessWidget {
  const DashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
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
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Completed'),
                ],
              ),
              centerTitle: false,
              titlePadding: const EdgeInsets.all(16),
              title: Text('BitHabit'),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return ListTile(
                  title: Text('Item $index'),
                  onTap: () {},
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
    );
  }
}
