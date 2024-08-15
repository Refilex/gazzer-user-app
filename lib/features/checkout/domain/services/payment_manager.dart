import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:gazzer_userapp/util/app_constants.dart';

class PaymobManager {
  Future<String> getPaymentKey({
    required double amount,
    required String currency,
  }) async {
    try {
      String authToken = await _getAuthToken();
      int orderId = await _getOrderId(
        authToken: authToken,
        amount: (amount * 100).toString(),
        currency: currency,
      );
      String paymentKey = await _getPaymentKey(
        authToken: authToken,
        orderId: orderId.toString(),
        amount: (amount * 100).toString(),
        currency: currency,
      );
      return paymentKey;
    } catch (e, stackTrace) {
      debugPrint("Exception in getPaymentKey: $e\n$stackTrace");
      throw Exception('Failed to get payment key');
    }
  }

  Future<String> _getAuthToken() async {
    try {
      final Response response = await Dio().post(
        "${AppConstants.paymobBaseUrl}/auth/tokens",
        data: {"api_key": AppConstants.paymobApiKey},
      );
      return response.data["token"];
    } catch (e) {
      debugPrint("Exception in _getAuthToken: $e");
      rethrow; // Propagate the exception further
    }
  }

  Future<int> _getOrderId({
    required String authToken,
    required String amount,
    required String currency,
  }) async {
    try {
      final Response response = await Dio().post(
        "${AppConstants.paymobBaseUrl}/ecommerce/orders",
        data: {
          "auth_token": authToken,
          "amount_cents": amount,
          "currency": currency,
          "delivery_needed": false,
          // use boolean instead of string
          "items": [],
          // ensure items are properly serialized
        },
      );
      return response.data["id"];
    } catch (e) {
      debugPrint("Exception in _getOrderId: $e");
      rethrow; // Propagate the exception further
    }
  }

  Future<String> _getPaymentKey({
    required String authToken,
    required String orderId,
    required String amount,
    required String currency,
  }) async {
    try {
      final Response response = await Dio().post(
        "${AppConstants.paymobBaseUrl}/acceptance/payment_keys",
        data: {
          "expiration": 3600,
          "auth_token": authToken,
          "amount_cents": amount,
          "currency": currency,
          "order_id": orderId,
          "integration_id": AppConstants.cartIntegrationId,
          "billing_data": {
            "first_name": "NA",
            "last_name": "NA",
            "email": "NA",
            "phone_number": "NA",
            "apartment": "NA",
            "floor": "NA",
            "street": "NA",
            "building": "NA",
            "shipping_method": "NA",
            "postal_code": "NA",
            "city": "NA",
            "country": "NA",
            "state": "NA"
          },
        },
      );
      return response.data["token"];
    } catch (e) {
      debugPrint("Exception in _getPaymentKey: $e");
      rethrow; // Propagate the exception further
    }
  }
}
