import 'package:gazzer_userapp/common/models/restaurant_model.dart';
import 'package:gazzer_userapp/common/widgets/rating_bar_widget.dart';
import 'package:gazzer_userapp/features/splash/controllers/splash_controller.dart';
import 'package:gazzer_userapp/common/models/product_model.dart';
import 'package:gazzer_userapp/helper/date_converter.dart';
import 'package:gazzer_userapp/helper/price_converter.dart';
import 'package:gazzer_userapp/helper/responsive_helper.dart';
import 'package:gazzer_userapp/util/dimensions.dart';
import 'package:gazzer_userapp/util/images.dart';
import 'package:gazzer_userapp/util/styles.dart';
import 'package:gazzer_userapp/common/widgets/custom_image_widget.dart';
import 'package:gazzer_userapp/common/widgets/discount_tag_widget.dart';
import 'package:gazzer_userapp/common/widgets/not_available_widget.dart';
import 'package:gazzer_userapp/common/widgets/product_bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WebItemWidget extends StatelessWidget {
  final Product? product;
  final Restaurant? store;

  const WebItemWidget({super.key, required this.product, this.store});

  @override
  Widget build(BuildContext context) {
    bool isAvailable = DateConverter.isAvailable(
      product?.availableTimeStarts,
      product?.availableTimeEnds,
    );

    return Stack(children: [
      InkWell(
        onTap: () {
          ResponsiveHelper.isMobile(context)
              ? Get.bottomSheet(
                  ProductBottomSheetWidget(product: product, isCampaign: false),
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                )
              : Get.dialog(
                  Dialog(
                      child: ProductBottomSheetWidget(
                          product: product, isCampaign: false)),
                );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 1))
            ],
          ),
          child: Column(children: [
            Stack(children: [
              CustomImageWidget(
                image:
                    '${Get.find<SplashController>().configModel!.baseUrls!.productImageUrl}'
                    '/${product?.image}',
                height: 160,
                width: 275,
                fit: BoxFit.cover,
                isFood: true,
              ),
              DiscountTagWidget(
                discount: product?.discount,
                discountType: product?.discountType,
              ),
              isAvailable ? const SizedBox() : const NotAvailableWidget(),
            ]),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeExtraSmall),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              product!.name!,
                              style: robotoMedium.copyWith(
                                  fontSize: Dimensions.fontSizeSmall),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                                width: Dimensions.paddingSizeExtraSmall),
                            (Get.find<SplashController>()
                                    .configModel!
                                    .toggleVegNonVeg!)
                                ? Image.asset(
                                    product!.veg == 0
                                        ? Images.nonVegImage
                                        : Images.vegImage,
                                    height: 10,
                                    width: 10,
                                    fit: BoxFit.contain,
                                  )
                                : const SizedBox(),
                          ]),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      Text(
                        product!.restaurantName!,
                        style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeExtraSmall,
                            color: Theme.of(context).disabledColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      RatingBarWidget(
                        rating: product!.avgRating,
                        size: 15,
                        ratingCount: product!.ratingCount,
                      ),
                      Row(children: [
                        Text(
                          PriceConverter.convertPrice(
                            product!.price,
                            discount: product!.discount,
                            discountType: product!.discountType,
                          ),
                          textDirection: TextDirection.ltr,
                          style: robotoBold.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall),
                        ),
                        SizedBox(
                            width: product!.discount! > 0
                                ? Dimensions.paddingSizeExtraSmall
                                : 0),
                        product!.discount! > 0
                            ? Expanded(
                                child: Text(
                                PriceConverter.convertPrice(product!.price),
                                textDirection: TextDirection.ltr,
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeExtraSmall,
                                  color: Theme.of(context).disabledColor,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ))
                            : const Expanded(child: SizedBox()),
                        const Icon(Icons.add, size: 25),
                      ]),
                    ]),
              ),
            ),
          ]),
        ),
      ),
    ]);
  }
}
