import 'package:bithabit/src/utils/const/app_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../utils/view/view_utils.dart';
import 'subs_service.dart';

class NavigationService {
  final BuildContext context;
  final SubsService subsService;

  NavigationService(this.context, this.subsService);

  static NavigationService? mock;

  factory NavigationService.of(BuildContext context) {
    return mock ?? NavigationService(context, context.read());
  }

  final premiumScreens = {
    AppRoute.charts: 'Visual Progress',
    AppRoute.export: 'Export/Import Data',
  };

  Future<bool> maybePop<T extends Object?>([T? result]) {
    return Navigator.of(context).maybePop(result);
  }

  Future<void> open(String routeName, {Object? arguments}) async {
    final navigator = Navigator.of(context);
    final premiumRoute = premiumScreens[routeName] != null;
    final isAllowed = !premiumRoute || subsService.isPremiumUser || kIsWeb;

    if (!isAllowed) {
      final result = await ConfirmingDialog.show(
        context,
        premiumScreens[routeName]!,
        'You need BitHabit Pro subcription to access this premium feature',
        confirmText: 'Read More',
      );
      if (result == ConfirmationResult.yes) {
        navigator.pushNamed(AppRoute.premium);
      }
      return;
    }

    navigator.pushNamed(routeName, arguments: arguments);
  }
}
