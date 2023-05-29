import 'dart:async';

import 'package:achievement_view/achievement_view.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

import '../../service/subs_service.dart';
import '../../utils/res/res_color.dart';
import '../../utils/view/app_bar_title.dart';
import '../../utils/view/section_title.dart';
import '../home/sound_player.dart';
import 'subscription_button.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> with SoundPlayer {
  late ConfettiController confettiController;
  late final SubsService subsService;
  late bool isPremiumUser;

  @override
  void initState() {
    super.initState();
    confettiController = ConfettiController(duration: const Duration(seconds: 6));

    subsService = context.read<SubsService>();
    isPremiumUser = subsService.isPremiumUser;
    subsService.addListener(checkSubs);
  }

  Future<void> checkSubs() async {
    if (subsService.isPremiumUser && isPremiumUser != subsService.isPremiumUser) {
      startAnimation(context);
      playCompleteSound();
    }

    setState(() {
      isPremiumUser = subsService.isPremiumUser;
    });
  }

  Future<void> startAnimation(BuildContext context) async {
    AchievementView(
      context,
      title: 'Thank You!',
      subTitle: 'Hope you have fantastic journey',
      alignment: Alignment.bottomCenter,
      icon: const Icon(
        BoxIcons.bxs_medal,
        color: ResColor.white,
        size: 42,
      ),
      borderRadius: BorderRadius.circular(12),
      color: ResColor.brown,
    ).show();

    confettiController.play();
    await Future<void>.delayed(const Duration(seconds: 3));

    if (!mounted) return;
    confettiController.stop();
  }

  @override
  void dispose() {
    subsService.removeListener(checkSubs);
    confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paddingBottom = MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(text: 'BitHabit Pro'),
        titleSpacing: 0,
        centerTitle: false,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(12).copyWith(
              bottom: paddingBottom > 0 ? paddingBottom : 12,
            ),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Subscribe Now, Cancel Anytime',
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      const SizedBox(height: 18),
                      const ListTile(
                        title: Text('Monthly'),
                        contentPadding: EdgeInsets.zero,
                        trailing: SubscriptionButton(kind: SubsKind.monthly),
                      ),
                      const ListTile(
                        title: Text('Yearly'),
                        contentPadding: EdgeInsets.zero,
                        trailing: SubscriptionButton(kind: SubsKind.yearly),
                      ),
                      const SizedBox(height: 18),
                      if (isPremiumUser)
                        TextButton(
                          onPressed: () => subsService.cancel(context),
                          style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('Cancel subscription? Read How'),
                            ],
                          ),
                        )
                      else
                        TextButton(
                          onPressed: subsService.restorePurchase,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('Already subscribed? Restore purchase'),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (isPremiumUser)
                const SectionTitle(text: "Features you've unlocked:")
              else
                const SectionTitle(text: "Features you'll unlock:"),
              const _FeatureTile(
                title: 'Export Data',
                subtitle: 'Generate a file from your habits and completions',
                icon: BoxIcons.bxs_arrow_from_bottom,
                color: ResColor.darkBlue,
              ),
              const _FeatureTile(
                title: 'Import Data',
                subtitle: 'Switching phones? Restore a previously exported backup',
                icon: BoxIcons.bxs_arrow_from_top,
                color: ResColor.lightBlue,
              ),
              const _FeatureTile(
                title: 'Unlimited tracked day',
                subtitle: 'Track an habit for more than 3 months',
                icon: BoxIcons.bxs_collection,
                color: Colors.orange,
              ),
              const _FeatureTile(
                title: 'Charts',
                subtitle: 'Visualize your progress to better understand yourself',
                icon: BoxIcons.bx_line_chart,
                color: ResColor.lightGreen,
              ),
              const _FeatureTile(
                title: 'Restore Archived',
                subtitle: 'Restore unactive habit when you feel like it',
                icon: BoxIcons.bx_upload,
                color: ResColor.lightPurple,
              ),
              const _FeatureTile(
                title: 'Support Indie Develpoer',
                subtitle: 'You help us maintain the app',
                icon: BoxIcons.bx_pulse,
                color: ResColor.red,
              ),
            ],
          ),
          Align(
            child: ConfettiWidget(
              key: const Key('Subscription Page Confetti'),
              confettiController: confettiController,
              blastDirectionality: BlastDirectionality.explosive, // don't specify a direction, blast randomly
              shouldLoop: true, // start again as soon as the animation is finished
              colors: const [
                ResColor.lightGreen,
                ResColor.lightBlue,
                ResColor.pink,
                Colors.orange,
                ResColor.purple
              ], // manually specify the colors to be used
              // createParticlePath: drawStar, // define a custom shape/path.
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _FeatureTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 6),
      leading: Container(
        height: 54,
        width: 54,
        decoration: BoxDecoration(
          color: color.withOpacity(0.6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: ResColor.white,
          size: 32,
        ),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}
