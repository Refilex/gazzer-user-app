import 'package:flutter/material.dart';
import 'package:gazzer_userapp/common/widgets/custom_button_widget.dart';
import 'package:gazzer_userapp/common/widgets/custom_snackbar_widget.dart';
import 'package:gazzer_userapp/features/auth/controllers/auth_controller.dart';
import 'package:gazzer_userapp/features/business/controllers/business_controller.dart';
import 'package:gazzer_userapp/features/checkout/controllers/checkout_controller.dart';
import 'package:gazzer_userapp/features/checkout/widgets/payment_button_new.dart';
import 'package:gazzer_userapp/features/profile/controllers/profile_controller.dart';
import 'package:gazzer_userapp/features/splash/controllers/splash_controller.dart';
import 'package:gazzer_userapp/helper/responsive_helper.dart';
import 'package:gazzer_userapp/util/dimensions.dart';
import 'package:gazzer_userapp/util/images.dart';
import 'package:gazzer_userapp/util/styles.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class PaymentMethodBottomSheet extends StatefulWidget {
  final bool isCashOnDeliveryActive;
  final bool isDigitalPaymentActive;
  final bool isOfflinePaymentActive;
  final bool isWalletActive;
  final double totalPrice;
  final bool isSubscriptionPackage;

  const PaymentMethodBottomSheet(
      {super.key,
      required this.isCashOnDeliveryActive,
      required this.isDigitalPaymentActive,
      required this.isWalletActive,
      required this.totalPrice,
      this.isSubscriptionPackage = false,
      required this.isOfflinePaymentActive});

  @override
  State<PaymentMethodBottomSheet> createState() =>
      _PaymentMethodBottomSheetState();
}

class _PaymentMethodBottomSheetState extends State<PaymentMethodBottomSheet> {
  bool canSelectWallet = true;
  bool notHideCod = true;
  bool notHideWallet = true;
  bool notHideDigital = true;
  final JustTheController tooltipController = JustTheController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    if (!widget.isSubscriptionPackage &&
        !Get.find<AuthController>().isGuestLoggedIn()) {
      double walletBalance =
          Get.find<ProfileController>().userInfoModel!.walletBalance!;
      if (walletBalance < widget.totalPrice) {
        canSelectWallet = false;
      }
      if (Get.find<CheckoutController>().isPartialPay) {
        notHideWallet = false;
        if (Get.find<SplashController>().configModel!.partialPaymentMethod! ==
            'cod') {
          notHideCod = true;
          notHideDigital = false;
        } else if (Get.find<SplashController>()
                .configModel!
                .partialPaymentMethod! ==
            'digital_payment') {
          notHideCod = false;
          notHideDigital = true;
        } else if (Get.find<SplashController>()
                .configModel!
                .partialPaymentMethod! ==
            'both') {
          notHideCod = true;
          notHideDigital = true;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = Get.find<AuthController>().isLoggedIn();

    return SizedBox(
      width: 550,
      child: GetBuilder<CheckoutController>(builder: (checkoutController) {
        return GetBuilder<BusinessController>(builder: (businessController) {
          return Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.9),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.vertical(
                  top: const Radius.circular(Dimensions.radiusLarge),
                  bottom: Radius.circular(ResponsiveHelper.isDesktop(context)
                      ? Dimensions.radiusLarge
                      : 0)),
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeLarge,
                vertical: Dimensions.paddingSizeLarge),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              ResponsiveHelper.isDesktop(context)
                  ? Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () => Get.back(),
                        child: Container(
                          height: 30,
                          width: 30,
                          margin: const EdgeInsets.symmetric(
                              vertical: Dimensions.paddingSizeExtraSmall),
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(50)),
                          child: const Icon(Icons.clear),
                        ),
                      ),
                    )
                  : Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 4,
                        width: 35,
                        margin: const EdgeInsets.symmetric(
                            vertical: Dimensions.paddingSizeExtraSmall),
                        decoration: BoxDecoration(
                            color: Theme.of(context).disabledColor,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
              const SizedBox(height: Dimensions.paddingSizeLarge),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'payment_method'.tr,
                          style: robotoBold.copyWith(
                              fontSize: Dimensions.fontSizeLarge),
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                      !widget.isSubscriptionPackage && notHideCod
                          ? Text(
                              'choose_payment_method'.tr,
                              style: robotoBold.copyWith(
                                  fontSize: Dimensions.fontSizeDefault),
                            )
                          : const SizedBox(),
                      SizedBox(
                        height: !widget.isSubscriptionPackage && notHideCod
                            ? Dimensions.paddingSizeExtraSmall
                            : 0,
                      ),
                      !widget.isSubscriptionPackage && notHideCod
                          ? Text(
                              'click_one_of_the_option_below'.tr,
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context).hintColor,
                              ),
                            )
                          : const SizedBox(),
                      SizedBox(
                        height: !widget.isSubscriptionPackage
                            ? Dimensions.paddingSizeLarge
                            : 0,
                      ),
                      !widget.isSubscriptionPackage
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    widget.isCashOnDeliveryActive && notHideCod
                                        ? Expanded(
                                            child: PaymentButtonNew(
                                              icon: Images.codIcon,
                                              title: 'cash_on_delivery'.tr,
                                              isSelected: checkoutController
                                                      .paymentMethodIndex ==
                                                  0,
                                              onTap: () {
                                                checkoutController
                                                    .setPaymentMethod(0);
                                              },
                                            ),
                                          )
                                        : const SizedBox(),
                                    // const SizedBox(
                                    //   width: 10,
                                    // ),
                                    // widget.isDigitalPaymentActive &&
                                    //         notHideDigital
                                    //     ? Expanded(
                                    //         child: PaymentButtonNew(
                                    //           icon: Images.digitalPayment,
                                    //           title: 'pay_visa'.tr,
                                    //           isSelected: checkoutController
                                    //                   .paymentMethodIndex ==
                                    //               2,
                                    //           onTap: () {
                                    //             if (!Get.find<CartController>()
                                    //                     .cartList
                                    //                     .first
                                    //                     .product!
                                    //                     .scheduleOrder! &&
                                    //                 Get.find<CartController>()
                                    //                     .availableList
                                    //                     .contains(false)) {
                                    //               showCustomSnackBar(
                                    //                   'one_or_more_product_unavailable'
                                    //                       .tr);
                                    //             } else if (Get.find<
                                    //                             RestaurantController>()
                                    //                         .restaurant!
                                    //                         .freeDelivery ==
                                    //                     null ||
                                    //                 Get.find<RestaurantController>()
                                    //                         .restaurant!
                                    //                         .cutlery ==
                                    //                     null) {
                                    //               showCustomSnackBar(
                                    //                   'restaurant_is_unavailable'
                                    //                       .tr);
                                    //             } else {
                                    //               setState(() {
                                    //                 isLoading = true;
                                    //               });
                                    //               PaymobManager()
                                    //                   .getPaymentKey(
                                    //                 amount: widget.totalPrice,
                                    //                 currency: "EGP",
                                    //                 fName:
                                    //                     "${Get.find<ProfileController>().userInfoModel?.fName}",
                                    //                 lName:
                                    //                     "${Get.find<ProfileController>().userInfoModel?.lName}",
                                    //                 email:
                                    //                     "${Get.find<ProfileController>().userInfoModel?.email}",
                                    //                 phone:
                                    //                     "${Get.find<ProfileController>().userInfoModel?.phone}",
                                    //               )
                                    //                   .then(
                                    //                       (String paymentKey) {
                                    //                 String paymentUrl =
                                    //                     "${AppConstants.paymobBaseUrl}/acceptance/iframes/861803?payment_token=$paymentKey";
                                    //                 Get.to(() => PayScreen(
                                    //                       url: paymentUrl,
                                    //                     checkoutController:
                                    //                           checkoutController,
                                    //                     ))?.then((value) {
                                    //                   setState(() {
                                    //                     isLoading = false;
                                    //                   });
                                    //                 });
                                    //               });
                                    //             }
                                    //           },
                                    //         ),
                                    //       )
                                    //     : const SizedBox(),
                                  ],
                                ),
                                const SizedBox(
                                    height: Dimensions.paddingSizeSmall),
                                widget.isWalletActive &&
                                        notHideWallet &&
                                        !checkoutController.subscriptionOrder &&
                                        isLoggedIn
                                    ? PaymentButtonNew(
                                        icon: Images.partialWallet,
                                        title: 'pay_via_wallet'.tr,
                                        isSelected: checkoutController
                                                .paymentMethodIndex ==
                                            1,
                                        onTap: () {
                                          if (canSelectWallet) {
                                            checkoutController
                                                .setPaymentMethod(1);
                                          } else if (checkoutController
                                              .isPartialPay) {
                                            showCustomSnackBar(
                                              'you_can_not_user_wallet_in_partial_payment'
                                                  .tr,
                                            );
                                            Get.back();
                                          } else {
                                            showCustomSnackBar(
                                              'your_wallet_have_not_sufficient_balance'
                                                  .tr,
                                            );
                                            Get.back();
                                          }
                                        },
                                      )
                                    : const SizedBox(),
                                isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator())
                                    : const SizedBox(),
                              ],
                            )
                          : const SizedBox(),
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.paddingSizeSmall),
                  child: CustomButtonWidget(
                    buttonText: 'select'.tr,
                    onPressed: () => Get.back(),
                  ),
                ),
              ),
            ]),
          );
        });
      }),
    );
  }
}
