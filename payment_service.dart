import 'dart:async';

class PaymentService {
  /// Simulating bKash Payment Process
  static Future<bool> processBkashPayment({
    required String phoneNumber,
    required double amount,
    required String trxId,
  }) async {
    // API Call Simulation
    await Future.delayed(const Duration(seconds: 2));

    // Simple validation rule for demo
    if (phoneNumber.length >= 11 && trxId.isNotEmpty) {
      return true; // Payment Success
    }
    return false; // Payment Failed
  }

  /// Simulating Rocket Payment Process
  static Future<bool> processRocketPayment({
    required String accountNumber,
    required double amount,
    required String trxId,
  }) async {
    // API Call Simulation
    await Future.delayed(const Duration(seconds: 2));

    if (accountNumber.length >= 11 && trxId.isNotEmpty) {
      return true; // Payment Success
    }
    return false; // Payment Failed
  }
}
