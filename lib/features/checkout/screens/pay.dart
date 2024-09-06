import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gazzer_userapp/common/widgets/custom_snackbar_widget.dart';
import 'package:gazzer_userapp/features/checkout/controllers/checkout_controller.dart';
import 'package:get/get.dart';

class PayScreen extends StatefulWidget {
  final String url;
  final CheckoutController checkoutController;

  PayScreen({super.key, required this.url, required this.checkoutController});

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
        title: Text("payment".tr),
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri.uri(Uri.parse(widget.url))),
        initialSettings: InAppWebViewSettings(javaScriptEnabled: true),
        onWebViewCreated: (controller) {
          _webViewController = controller;
          setState(() {
            disableDetailsButton(controller);
          });
        },
        onLoadStart: (controller, url) {
          setState(() {
            disableDetailsButton(controller).then((_) {
              debugPrint('Loading: $url');
              const Center(child: CircularProgressIndicator());
            });
          });
        },
        onLoadStop: (controller, url) {
          setState(() {
            disableDetailsButton(controller);
          });
          if (url != null &&
              url.queryParameters.containsKey("success") &&
              url.queryParameters["success"] == "true") {
            widget.checkoutController.setPaymentMethod(2);
            Get.back();
          } else if (url != null &&
              url.queryParameters.containsKey("success") &&
              url.queryParameters["success"] == "false") {
            widget.checkoutController.setPaymentMethod(0);
            Get.back();
            showCustomSnackBar("failed".tr);
          }
        },
      ),
    );
  }

  disableDetailsButton(InAppWebViewController controller) =>
      controller.evaluateJavascript(source: """
      (function autoCalledFunction() {
      const element = document.querySelector('p.flex.cursor-pointer.justify-center.py-4.text-blue-500.font-semibold.text-sm');
                  if (element && element.innerText.includes('View order details')) {
                      element.style.display = 'none';
                  }
          })(); 
            """);
}
