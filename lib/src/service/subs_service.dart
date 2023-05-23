import 'package:flutter/material.dart';

class SubsService extends ChangeNotifier {
  SubsKind subsKind = SubsKind.none;
  bool isLoading = false;

  bool get isPremiumUser => subsKind != SubsKind.none;

  void checkSubscription() async {
    // TODO: use google service to check subs
  }

  void restorePurchase() async {
    isLoading = true;
    notifyListeners();

    // TODO: use google service to subs
    await Future.delayed(const Duration(seconds: 2));
    subsKind = SubsKind.monthly;

    isLoading = false;
    notifyListeners();
  }

  void subscribe(SubsKind kind) async {
    isLoading = true;
    notifyListeners();

    // TODO: use google service to subs
    await Future.delayed(const Duration(seconds: 2));
    subsKind = kind;

    isLoading = false;
    notifyListeners();
  }

  String getPrice(SubsKind kind) {
    switch (kind) {
      case SubsKind.monthly:
        return 'Rp 15.000';
      case SubsKind.yearly:
        return 'Rp 150.000';
      default: // none
        return '';
    }
  }

  void cancel(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    // TODO: use google service to subs
    await Future.delayed(const Duration(seconds: 2));
    subsKind = SubsKind.none;

    isLoading = false;
    notifyListeners();
  }
}

enum SubsKind { none, monthly, yearly }
