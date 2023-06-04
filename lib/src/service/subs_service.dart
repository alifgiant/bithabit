import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubsService extends ChangeNotifier {
  SubsKind subsKind = SubsKind.none;
  bool isLoading = false;
  final InAppPurchase storeClient;

  SubsService({
    InAppPurchase? storeClient,
  }) : storeClient = storeClient ?? InAppPurchase.instance;

  bool get isPremiumUser => subsKind != SubsKind.none;
  StreamSubscription<List<PurchaseDetails>>? _statusUpdateSubs;

  void updateKind(SubsKind kind) {
    subsKind = kind;
    notifyListeners();
  }

  void startListening() async {
    // feature not available on web
    if (kIsWeb) return;

    await _statusUpdateSubs?.cancel();
    _statusUpdateSubs = storeClient.purchaseStream.listen((details) async {
      for (var detail in details) {
        // main error flow, propagate to all listener
        if ([
          PurchaseStatus.error,
          PurchaseStatus.canceled,
        ].contains(detail.status)) {
          // for (var listener in _statusUpdateListeners.values) {
          //   await listener(detail);
          // }
          // // remove all listeners when error occur
          // _statusUpdateListeners.clear();
          // continue;
        }

        // main success flow
        // final listener = _statusUpdateListeners[detail.productID];
        // if (listener != null) {
        //   await listener(detail);
        //   // remove only selected listener
        //   _statusUpdateListeners.remove(detail.productID);
        //   continue;
        // }

        // default/restoring flow
        handlePurchaseStatus(detail);
      }
    });
  }

  Future<void> handlePurchaseStatus(PurchaseDetails event) async {
    // if (event.pendingCompletePurchase) {
    //   _storeClient.completePurchase(event);
    //   return null;
    // }

    // switch (event.status) {
    //   case PurchaseStatus.restored:
    //   case PurchaseStatus.purchased:
    //     if (_purchasedProducts.contains(event.productID)) break;
    //     // add to temp data
    //     _purchasedProducts.add(event.productID);
    //     // save to local storage
    //     _savePurchasedPack(event.productID);
    //     notifyListeners();
    //     return PaymentResult.success;
    //   case PurchaseStatus.canceled:
    //     return PaymentResult.cancel;
    //   case PurchaseStatus.error:
    //     return PaymentResult.error;
    //   default:
    //     //PurchaseStatus.pending:
    //     return null;
    // }
    // return null;
  }

  Future<void> checkSubscription() async {
    // TODO: use google service to check subs
    restorePurchase();
  }

  Future<void> restorePurchase() async {
    isLoading = true;
    notifyListeners();

    // feature not available on web
    if (kIsWeb) return;

    try {
      // read from remote store
      final available = await storeClient.isAvailable();
      if (!available) return;

      await storeClient.restorePurchases();
    } catch (e) {
      FlutterError.reportError(FlutterErrorDetails(exception: e));
    }
    // TODO: use google service to subs
    await Future<void>.delayed(const Duration(seconds: 2));
    subsKind = SubsKind.monthly;

    isLoading = false;
    notifyListeners();
  }

  Future<void> subscribe(SubsKind kind) async {
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
      case SubsKind.none:
        return '';
    }
  }

  Future<void> cancel(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    // TODO: use google service to subs
    await Future<void>.delayed(const Duration(seconds: 2));
    subsKind = SubsKind.none;

    isLoading = false;
    notifyListeners();
  }
}

enum SubsKind { none, monthly, yearly }
