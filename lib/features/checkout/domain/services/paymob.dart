import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:gazzer_userapp/features/auth/controllers/auth_controller.dart';
import 'package:gazzer_userapp/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class Paymob {
  Future<String?> getPaymobIntention({
    required double amount,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
            "${AppConstants.baseUrl}/api/v1/customer/paymob/intention?amount=$amount"),
        headers: {
          "Authorization":
              "Bearer ${Get.find<AuthController>().getUserToken()}",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty && data[0]['checkout_url'] != null) {
          debugPrint("checkout_url: ${data[0]['checkout_url']}");
          return data[0]['checkout_url'];
        }
      } else {
        debugPrint('Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Exception: $e');
    }

    return null; // Return null if no URL is found
  }
}
