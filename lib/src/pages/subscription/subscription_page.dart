import 'dart:async';

import 'package:achievement_view/achievement_view.dart';
import 'package:bithabit/src/pages/home/sound_player.dart';
import 'package:bithabit/src/service/subs_service.dart';
import 'package:bithabit/src/utils/view/section_title.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

import '../../utils/res/res_color.dart';
import '../../utils/view/app_bar_title.dart';

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

  void checkSubs() async {
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
      title: "Thank You!",
      subTitle: "Hope you have fantastic journey",
      alignment: Alignment.bottomCenter,
      icon: const Icon(
        BoxIcons.bxs_medal,
        color: ResColor.white,
        size: 42,
      ),
      borderRadius: BorderRadius.circular(12.0),
      color: ResColor.brown,
    ).show();

    confettiController.play();
    await Future.delayed(const Duration(seconds: 3));
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
                  padding: const EdgeInsets.all(12.0),
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
                          onPressed: () => subsService.restorePurchase(),
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
                const SectionTitle(text: "Features you've unlock:")
              else
                const SectionTitle(text: "Features you'll unlock:"),
            ],
          ),
          Align(
            alignment: Alignment.center,
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

class SubscriptionButton extends StatelessWidget {
  final SubsKind kind;

  const SubscriptionButton({
    super.key,
    required this.kind,
  });

  @override
  Widget build(BuildContext context) {
    final subsService = context.watch<SubsService>();
    final priceText = subsService.getPrice(kind);

    final double buttonLength = (priceText.length * 10) + 12;

    return InkWell(
      onTap: subsService.subsKind == kind ? null : () => subsService.subscribe(kind),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: subsService.subsKind == kind ? ResColor.lightGreen : Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        width: subsService.isLoading ? 50 : buttonLength,
        height: 42,
        child: Center(
          child: subsService.isLoading
              ? SizedBox.square(
                  dimension: 12,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.background),
                  ),
                )
              : FittedBox(
                  child: Text(
                    subsService.subsKind == kind ? 'Paid' : subsService.getPrice(kind),
                    style: TextStyle(color: Theme.of(context).colorScheme.background),
                  ),
                ),
        ),
      ),
    );
  }
}
