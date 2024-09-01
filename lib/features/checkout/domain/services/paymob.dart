import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:gazzer_userapp/util/app_constants.dart';

class Paymob {
  Future<String> getClientSecretKey({
    required double amount,
    required String fName,
    required String lName,
    required String email,
    required String phone,
  }) async {
    try {
      Response response = await Dio().post(
        "${AppConstants.paymobBaseUrl}v1/intention/",
        options: Options(
          headers: {
            "Authorization": "Token ${AppConstants.paymobSecretKey}",
            "Content-Type": "application/json",
          },
        ),
        data: {
          "amount": (amount * 100).toString(),
          "currency": "EGP",
          "expiration": 5800,
          "payment_methods": [AppConstants.cartIntegrationId, "card"],
          "billing_data": {
            "apartment": "NA",
            "first_name": fName,
            "last_name": lName,
            "street": "NA",
            "building": "NA",
            "phone_number": phone,
            "country": "NA",
            "email": email,
            "floor": "NA",
            "state": "NA"
          },
          "customer": {"first_name": fName, "last_name": lName, "email": email}
        },
      );

      if (response.statusCode == 201) {
        debugPrint("client_secret_key= ${response.data['client_secret']}");
        return response.data['client_secret'];
      } else {
        throw Exception(
            'Failed to get client secret. Status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in getClientSecretKey: $e');
      rethrow; // Rethrow the caught exception for higher-level handling
    }
  }
}
