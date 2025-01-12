import 'dart:io';
import 'package:limpia/core/utils/config.dart';
import 'package:limpia/state.dart';
import 'package:flutter/material.dart';
import 'package:flutterwave_standard/flutterwave.dart';

class FlutterwavePaymentService {
  Future<ChargeResponse> makePayment({
    required BuildContext context,
    required String amount,
    String? publicKey,
    String? encryptionKey,
    String? phoneNumber,
    String? reference,
    bool isTestMode = false,
  }) async {
    final Customer customer = Customer(
      name: '${profile.value.firstname} ${profile.value.lastname}' ?? "Limpia NG",
      phoneNumber: profile.value.phone ?? "07045007400",
      email: profile.value.email ?? 'dev@Limpia.com',
    );

    final Flutterwave flutterwave = Flutterwave(
      context: context,
      publicKey: AppConfig.flutterWaveTestKey,
      currency: "NGN",
      amount: amount,
      txRef: reference!,
      redirectUrl: "https://www.Limpia.com",
      customer: customer,
      paymentOptions: "card, ussd, payattitude, barter",
      customization: Customization(title: "Limpia Test Payment"),
      isTestMode: isTestMode,
    );

    final ChargeResponse response = await flutterwave.charge();
    return response;
  }


  String getReference() {
    var platform = (Platform.isIOS) ? 'iOS' : 'Android';
    final thisDate = DateTime.now().millisecondsSinceEpoch;
    return 'ChargedFrom${platform}_$thisDate';
  }
}
