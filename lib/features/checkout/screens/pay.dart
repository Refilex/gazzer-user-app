import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gazzer_userapp/features/auth/controllers/auth_controller.dart';
import 'package:gazzer_userapp/features/cart/controllers/cart_controller.dart';
import 'package:gazzer_userapp/features/checkout/controllers/checkout_controller.dart';
import 'package:gazzer_userapp/features/checkout/domain/models/place_order_body_model.dart';
import 'package:gazzer_userapp/features/coupon/controllers/coupon_controller.dart';
import 'package:gazzer_userapp/features/profile/controllers/profile_controller.dart';
import 'package:gazzer_userapp/helper/address_helper.dart';
import 'package:gazzer_userapp/helper/date_converter.dart';
import 'package:gazzer_userapp/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayScreen extends StatefulWidget {
  final String url;
  final CheckoutController checkoutController;
  final List<OnlineCart> carts;
  final double totalPrice;
  final DateTime scheduleStartDate;
  final double deliveryCharge;
  final bool fromCart;
  final double discount;
  final double tax;
  final double extraPackagingAmount;
  final int subscriptionQty;
  final List<SubscriptionDays> days;

  PayScreen({
    super.key,
    required this.url,
    required this.checkoutController,
    required this.carts,
    required this.totalPrice,
    required this.scheduleStartDate,
    required this.extraPackagingAmount,
    required this.discount,
    required this.tax,
    required this.subscriptionQty,
    required this.fromCart,
    required this.deliveryCharge,
    required this.days,
  });

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel("PaymobPayment", onMessageReceived: (message) {
       // var jsonData = jsonDecode(message.message);
        if (message.message.contains('payment-status')) {

          debugPrint('PAYMENT FINISHED');

          // Your code

        } else {

          debugPrint('PAYMENT NOT FINISHED OR MAY BE WINDOW CLOSED OR URL CHAINED');

        }
      })
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            debugPrint("Navigating to: ${request.url}");

            if (request.url.contains("payment-status")) {
              debugPrint("Payment status detected. Waiting for response...");
              backToApp();
              return NavigationDecision.prevent;
            }
            debugPrint("Allowing navigation to: ${request.url}");
            return NavigationDecision.navigate;
          },
          onPageFinished: (String url) {
            debugPrint("Page finished loading: $url");
            injectJavaScriptForSpaUrlChanges();
            disableDetailsButton(_controller);
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint("Web resource error: ${error.description}");
          },
        ),
      )
      ..setOnConsoleMessage((message) {
        debugPrint(message.message);
      })
      ..loadRequest(Uri.parse(widget.url));
  }

  void injectJavaScriptForSpaUrlChanges() {
    // Inject JavaScript that listens for URL changes in the SPA
    _controller.runJavaScript('''
    (function() {
      let lastUrl = location.href;
      new MutationObserver(() => {
        const currentUrl = location.href;
        if (lastUrl !== currentUrl) {
          lastUrl = currentUrl;
          window.PaymobPayment.postMessage(JSON.stringify({ url: currentUrl }));
        }
      }).observe(document, { subtree: true, childList: true });
    })();
  ''');
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("payment".tr),
          leading: IconButton(
            onPressed: () {
              backToApp();
            },
            icon: const Icon(Icons.close),
          ),
          centerTitle: true,
        ),
        body: WebViewWidget(controller: _controller),
      ),
    );
  }

  void startPaymentProcess() {
    widget.checkoutController.placeOrder(
      PlaceOrderBodyModel(
        cart: widget.carts,
        couponDiscountAmount: Get.find<CouponController>().discount,
        distance: widget.checkoutController.distance,
        couponDiscountTitle: Get.find<CouponController>().discount! > 0
            ? Get.find<CouponController>().coupon!.title
            : null,
        scheduleAt: !widget.checkoutController.restaurant!.scheduleOrder!
            ? null
            : (widget.checkoutController.selectedDateSlot == 0 &&
            widget.checkoutController.selectedTimeSlot == 0)
            ? null
            : DateConverter.dateToDateAndTime(widget.scheduleStartDate),
        orderAmount: widget.totalPrice,
        orderNote: widget.checkoutController.noteController.text,
        orderType: widget.checkoutController.orderType,
        paymentMethod: 'digital_payment',
        couponCode: (Get.find<CouponController>().discount! > 0 ||
            (Get.find<CouponController>().coupon != null &&
                Get.find<CouponController>().freeDelivery))
            ? Get.find<CouponController>().coupon!.code
            : null,
        restaurantId: widget.checkoutController.restaurant!.id,
        address: AddressHelper.getAddressFromSharedPref()!.address,
        latitude: AddressHelper.getAddressFromSharedPref()!.latitude,
        longitude: AddressHelper.getAddressFromSharedPref()!.longitude,
        addressType: AddressHelper.getAddressFromSharedPref()!.addressType,
        contactPersonName:
        AddressHelper.getAddressFromSharedPref()!.contactPersonName ??
            '${Get.find<ProfileController>().userInfoModel!.fName} '
                '${Get.find<ProfileController>().userInfoModel!.lName}',
        contactPersonNumber:
        AddressHelper.getAddressFromSharedPref()!.contactPersonNumber ??
            Get.find<ProfileController>().userInfoModel!.phone,
        discountAmount: widget.discount,
        taxAmount: widget.tax,
        cutlery: Get.find<CartController>().addCutlery ? 1 : 0,
        road: Get.find<AuthController>().isGuestLoggedIn()
            ? AddressHelper.getAddressFromSharedPref()!.road ?? ''
            : widget.checkoutController.streetNumberController.text.trim(),
        house: Get.find<AuthController>().isGuestLoggedIn()
            ? AddressHelper.getAddressFromSharedPref()!.house ?? ''
            : widget.checkoutController.houseController.text.trim(),
        floor: Get.find<AuthController>().isGuestLoggedIn()
            ? AddressHelper.getAddressFromSharedPref()!.floor ?? ''
            : widget.checkoutController.floorController.text.trim(),
        dmTips: (widget.checkoutController.orderType == 'take_away' ||
            widget.checkoutController.subscriptionOrder ||
            widget.checkoutController.selectedTips == 0)
            ? ''
            : widget.checkoutController.tips.toString(),
        subscriptionOrder:
        widget.checkoutController.subscriptionOrder ? '1' : '0',
        subscriptionType: widget.checkoutController.subscriptionType,
        subscriptionQuantity: widget.subscriptionQty.toString(),
        subscriptionDays: widget.days,
        subscriptionStartAt: widget.checkoutController.subscriptionOrder
            ? DateConverter.dateToDateAndTime(
            widget.checkoutController.subscriptionRange!.start)
            : '',
        subscriptionEndAt: widget.checkoutController.subscriptionOrder
            ? DateConverter.dateToDateAndTime(
            widget.checkoutController.subscriptionRange!.end)
            : '',
        unavailableItemNote: Get.find<CartController>().notAvailableIndex != -1
            ? Get.find<CartController>()
            .notAvailableList[Get.find<CartController>().notAvailableIndex]
            : '',
        deliveryInstruction: widget.checkoutController.selectedInstruction != -1
            ? AppConstants.deliveryInstructionList[
        widget.checkoutController.selectedInstruction]
            : '',
        partialPayment: widget.checkoutController.isPartialPay ? 1 : 0,
        guestId: Get.find<AuthController>().isGuestLoggedIn()
            ? int.parse(Get.find<AuthController>().getGuestId())
            : 0,
        isBuyNow: widget.fromCart ? 0 : 1,
        guestEmail: Get.find<AuthController>().isGuestLoggedIn()
            ? AddressHelper.getAddressFromSharedPref()!.email
            : null,
        extraPackagingAmount: widget.extraPackagingAmount,
        deliveryCharge: widget.deliveryCharge,
      ),
      widget.checkoutController.restaurant!.zoneId!,
      widget.totalPrice,
      widget.deliveryCharge,
      widget.fromCart,
      false,
    );
  }

  void backToApp() {
    widget.checkoutController.loading();
    Get.back();
  }

  Future<void> disableDetailsButton(WebViewController controller) async {
    await controller.runJavaScript("""
      (function autoCalledFunction() {
      const element = document.querySelector('p.flex.cursor-pointer.justify-center.py-4.text-blue-500.font-semibold.text-sm');
                  if (element && element.innerText.includes('View order details')) {
                      element.style.display = 'none';
                  }
          })();
            """);
  }
}
