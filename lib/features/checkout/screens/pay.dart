import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gazzer_userapp/common/widgets/custom_snackbar_widget.dart';
import 'package:gazzer_userapp/features/checkout/controllers/checkout_controller.dart';
import 'package:get/get.dart';

class PayScreen extends StatefulWidget {
  final String url;
  final CheckoutController checkoutController; // Add this line
  const PayScreen(
      {Key? key, required this.url, required this.checkoutController})
      : super(key: key);

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  InAppWebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
    startPayment();
  }

  void startPayment() {
    _webViewController?.loadUrl(
        urlRequest: URLRequest(
      url: WebUri.uri(Uri.parse(widget.url)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paymob payment'),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri.uri(Uri.parse(widget.url))),
        initialSettings: InAppWebViewSettings(javaScriptEnabled: true),
        onWebViewCreated: (controller) {
          _webViewController = controller;
          startPayment();
        },
        onLoadStart: (controller, url) {
          print('Loading: $url');
          const Center(child: CircularProgressIndicator());
        },
        onLoadStop: (controller, url) {
          if (url != null &&
              url.queryParameters.containsKey("success") &&
              url.queryParameters["success"] == "true") {
            widget.checkoutController.setPaymentMethod(2);
            Get.back();
          } else if (url != null &&
              url.queryParameters.containsKey("success") &&
              url.queryParameters["success"] == "false") {
            showCustomSnackBar("failed".tr);
            widget.checkoutController.setPaymentMethod(0);
            Get.back();
          }
        },
      ),
    );
  }
}
