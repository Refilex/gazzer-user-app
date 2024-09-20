import 'package:flutter/material.dart';
import 'package:gazzer_userapp/common/widgets/custom_snackbar_widget.dart';
import 'package:gazzer_userapp/features/checkout/controllers/checkout_controller.dart';
import 'package:gazzer_userapp/features/coupon/controllers/coupon_controller.dart';
import 'package:gazzer_userapp/features/coupon/domain/models/coupon_model.dart';
import 'package:gazzer_userapp/features/language/controllers/localization_controller.dart';
import 'package:gazzer_userapp/features/restaurant/controllers/restaurant_controller.dart';
import 'package:gazzer_userapp/helper/price_converter.dart';
import 'package:gazzer_userapp/helper/responsive_helper.dart';
import 'package:gazzer_userapp/util/dimensions.dart';
import 'package:gazzer_userapp/util/styles.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class CouponBottomSheet extends StatefulWidget {
  final CheckoutController checkoutController;
  final double price;
  final double discount;
  final double addOns;
  final double deliveryCharge;
  final double charge;
  final double total;

  const CouponBottomSheet(
      {super.key,
      required this.checkoutController,
      required this.price,
      required this.discount,
      required this.addOns,
      required this.deliveryCharge,
      required this.total,
      required this.charge});

  @override
  State<CouponBottomSheet> createState() => _CouponBottomSheetState();
}

class _CouponBottomSheetState extends State<CouponBottomSheet> {
  List<CouponModel>? _couponList;
  List<JustTheController>? _toolTipControllerList;

  @override
  void initState() {
    super.initState();

    if (Get.find<CouponController>().couponList != null &&
        Get.find<CouponController>().couponList!.isNotEmpty) {
      _couponList = [];
      _toolTipControllerList = [];
      for (var coupon in Get.find<CouponController>().couponList!) {
        if (widget.deliveryCharge == 0 &&
            coupon.couponType != 'free_delivery') {
          _couponList!.add(coupon);
          _toolTipControllerList!.add(JustTheController());
        } else if (widget.deliveryCharge != 0) {
          _couponList!.add(coupon);
          _toolTipControllerList!.add(JustTheController());
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();

    if (_toolTipControllerList != null) {
      for (var toolTip in _toolTipControllerList!) {
        toolTip.dispose();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = widget.total;
    return Container(
      width: Dimensions.webMaxWidth,
      height: context.height * 0.7,
      margin: EdgeInsets.only(top: GetPlatform.isWeb ? 0 : 30),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: ResponsiveHelper.isMobile(context)
            ? const BorderRadius.vertical(
                top: Radius.circular(Dimensions.radiusExtraLarge))
            : const BorderRadius.all(
                Radius.circular(Dimensions.radiusExtraLarge)),
      ),
      child: GetBuilder<CouponController>(builder: (couponController) {
        return Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const SizedBox(width: 30),
              !ResponsiveHelper.isDesktop(context)
                  ? Container(
                      height: 4,
                      width: 35,
                      margin: const EdgeInsets.symmetric(
                          vertical: Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(
                          color: Theme.of(context).disabledColor,
                          borderRadius: BorderRadius.circular(10)),
                    )
                  : const SizedBox(),
              IconButton(
                onPressed: () => Get.back(),
                icon: Icon(Icons.clear, color: Theme.of(context).disabledColor),
              ),
            ]),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                border: Border.all(
                    color: Theme.of(context).primaryColor, width: 0.3),
              ),
              padding:
                  const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
              margin: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeDefault),
              child: Row(children: [
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: TextField(
                      controller: widget.checkoutController.couponController,
                      style: robotoRegular.copyWith(
                          height:
                              ResponsiveHelper.isMobile(context) ? null : 2),
                      decoration: InputDecoration(
                          hintText: 'enter_promo_code'.tr,
                          hintStyle: robotoRegular.copyWith(
                              color: Theme.of(context).hintColor),
                          isDense: true,
                          filled: true,
                          enabled: couponController.discount == 0,
                          fillColor: Theme.of(context).cardColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(
                                  Get.find<LocalizationController>().isLtr
                                      ? 10
                                      : 0),
                              right: Radius.circular(
                                  Get.find<LocalizationController>().isLtr
                                      ? 0
                                      : 10),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: Icon(Icons.local_offer_outlined,
                              color: Theme.of(context).primaryColor)),
                      onSubmitted: (coupon) {
                        String couponCode = widget
                            .checkoutController.couponController.text
                            .trim();
                        if (couponController.discount! < 1 &&
                            !couponController.freeDelivery) {
                          if (couponCode.isNotEmpty &&
                              !couponController.isLoading) {
                            couponController
                                .applyCoupon(
                                    couponCode,
                                    (widget.price - widget.discount) +
                                        widget.addOns,
                                    widget.deliveryCharge,
                                    widget.charge,
                                    totalPrice,
                                    Get.find<RestaurantController>()
                                        .restaurant!
                                        .id)
                                .then((discount) {
                              if (discount! > 0) {
                                showCustomSnackBar(
                                  '${'you_got_discount_of'.tr} ${PriceConverter.convertPrice(discount)}',
                                  isError: false,
                                  showToaster: true,
                                );
                                if (widget.checkoutController.isPartialPay ||
                                    widget.checkoutController
                                            .paymentMethodIndex ==
                                        1) {
                                  totalPrice = totalPrice - discount;
                                  widget.checkoutController
                                      .checkBalanceStatus(totalPrice);
                                }
                              }
                              Get.back();
                            });
                          } else if (couponCode.isEmpty) {
                            showCustomSnackBar('enter_a_coupon_code'.tr);
                          }
                        } else {
                          totalPrice = totalPrice + couponController.discount!;
                          couponController.removeCouponData(true);
                          widget.checkoutController.couponController.text = '';
                          if (widget.checkoutController.isPartialPay ||
                              widget.checkoutController.paymentMethodIndex ==
                                  1) {
                            widget.checkoutController
                                .checkBalanceStatus(totalPrice);
                          }
                        }
                      },
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    String couponCode =
                        widget.checkoutController.couponController.text.trim();
                    if (couponController.discount! < 1 &&
                        !couponController.freeDelivery) {
                      if (couponCode.isNotEmpty &&
                          !couponController.isLoading) {
                        couponController
                            .applyCoupon(
                                couponCode,
                                (widget.price - widget.discount) +
                                    widget.addOns,
                                widget.deliveryCharge,
                                widget.charge,
                                totalPrice,
                                Get.find<RestaurantController>().restaurant!.id)
                            .then((discount) {
                          if (discount! > 0) {
                            showCustomSnackBar(
                              '${'you_got_discount_of'.tr} ${PriceConverter.convertPrice(discount)}',
                              isError: false,
                              showToaster: true,
                            );
                            if (widget.checkoutController.isPartialPay ||
                                widget.checkoutController.paymentMethodIndex ==
                                    1) {
                              totalPrice = totalPrice - discount;
                              widget.checkoutController
                                  .checkBalanceStatus(totalPrice);
                            }
                          }
                          Get.back();
                        });
                      } else if (couponCode.isEmpty) {
                        showCustomSnackBar('enter_a_coupon_code'.tr);
                      }
                    } else {
                      totalPrice = totalPrice + couponController.discount!;
                      couponController.removeCouponData(true);
                      widget.checkoutController.couponController.text = '';
                      if (widget.checkoutController.isPartialPay ||
                          widget.checkoutController.paymentMethodIndex == 1) {
                        widget.checkoutController
                            .checkBalanceStatus(totalPrice);
                      }
                    }
                  },
                  child: Container(
                    height: 45,
                    width: (couponController.discount! <= 0 &&
                            !couponController.freeDelivery)
                        ? 100
                        : 50,
                    alignment: Alignment.center,
                    margin:
                        const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      color: (couponController.discount! <= 0 &&
                              !couponController.freeDelivery)
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    child: (couponController.discount! <= 0 &&
                            !couponController.freeDelivery)
                        ? !couponController.isLoading
                            ? Text(
                                'apply'.tr,
                                style:
                                    robotoMedium.copyWith(color: Colors.white),
                              )
                            : const SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white)),
                              )
                        : Icon(Icons.clear,
                            color: Theme.of(context).colorScheme.error),
                  ),
                ),
              ]),
            ),
          ],
        );
      }),
    );
  }
}
