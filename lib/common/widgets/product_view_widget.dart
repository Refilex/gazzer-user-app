import 'package:flutter/material.dart';
import 'package:gazzer_userapp/common/models/product_model.dart';
import 'package:gazzer_userapp/common/models/restaurant_model.dart';
import 'package:gazzer_userapp/common/widgets/no_data_screen_widget.dart';
import 'package:gazzer_userapp/common/widgets/product_shimmer_widget.dart';
import 'package:gazzer_userapp/common/widgets/product_widget.dart';
import 'package:gazzer_userapp/common/widgets/web_restaurant_widget.dart';
import 'package:gazzer_userapp/features/home/widgets/theme1/restaurant_widget.dart';
import 'package:gazzer_userapp/helper/responsive_helper.dart';
import 'package:gazzer_userapp/util/dimensions.dart';
import 'package:get/get.dart';

class ProductViewWidget extends StatelessWidget {
  final List<Product?>? products;
  final List<Restaurant?>? restaurants;
  final bool isRestaurant;
  final EdgeInsetsGeometry padding;
  final bool isScrollable;
  final int shimmerLength;
  final String? noDataText;
  final bool isCampaign;
  final bool inRestaurantPage;
  final bool showTheme1Restaurant;
  final bool? isWebRestaurant;
  final bool? fromFavorite;
  final bool? fromSearch;

  const ProductViewWidget(
      {super.key,
      required this.restaurants,
      required this.products,
      required this.isRestaurant,
      this.isScrollable = false,
      this.shimmerLength = 20,
      this.padding = const EdgeInsets.all(Dimensions.paddingSizeSmall),
      this.noDataText,
      this.isCampaign = false,
      this.inRestaurantPage = false,
      this.showTheme1Restaurant = false,
      this.isWebRestaurant = false,
      this.fromFavorite = false,
      this.fromSearch = false});

  @override
  Widget build(BuildContext context) {
    bool isNull = true;
    int length = 0;
    if (isRestaurant) {
      isNull = restaurants == null;
      if (!isNull) {
        length = restaurants!.length;
      }
    } else {
      isNull = products == null;
      if (!isNull) {
        length = products!.length;
      }
    }
    if (restaurants != null && restaurants!.isEmpty) {
      return NoDataScreen(
        isEmptyRestaurant: isRestaurant ? true : false,
        isEmptyWishlist: fromFavorite! ? true : false,
        isEmptySearchFood: fromSearch! ? true : false,
        title: noDataText ??
            (isRestaurant
                ? 'there_is_no_restaurant'.tr
                : 'there_is_no_food'.tr),
      );
    }

    return Column(children: [
      !isNull
          ? length > 0
              ? GridView.builder(
                  key: UniqueKey(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: Dimensions.paddingSizeLarge,
                    mainAxisSpacing:
                        ResponsiveHelper.isDesktop(context) && !isWebRestaurant!
                            ? Dimensions.paddingSizeLarge
                            : isWebRestaurant!
                                ? Dimensions.paddingSizeLarge
                                : 0.01,
                    //childAspectRatio: ResponsiveHelper.isDesktop(context) && !isWebRestaurant! ? 3 : isWebRestaurant! ? 1.5 : showTheme1Restaurant ? 1.9 : 3.3,
                    mainAxisExtent:
                        ResponsiveHelper.isDesktop(context) && !isWebRestaurant!
                            ? 142
                            : isWebRestaurant!
                                ? 280
                                : showTheme1Restaurant
                                    ? 200
                                    : 150,
                    crossAxisCount:
                        ResponsiveHelper.isMobile(context) && !isWebRestaurant!
                            ? 1
                            : isWebRestaurant!
                                ? 4
                                : 3,
                  ),
                  physics: isScrollable
                      ? const BouncingScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  shrinkWrap: isScrollable ? false : true,
                  itemCount: length,
                  padding: padding,
                  itemBuilder: (context, index) {
                    return showTheme1Restaurant
                        ? RestaurantWidget(
                            restaurant: restaurants![index],
                            index: index,
                            inStore: inRestaurantPage)
                        : isWebRestaurant!
                            ? WebRestaurantWidget(
                                restaurant: restaurants![index])
                            : ProductWidget(
                                isRestaurant: isRestaurant,
                                product: isRestaurant ? null : products![index],
                                restaurant:
                                    isRestaurant ? restaurants![index] : null,
                                index: index,
                                length: length,
                                isCampaign: isCampaign,
                                inRestaurant: inRestaurantPage,
                              );
                  },
                )
              : const Center(
                  child: SizedBox(
                    width: 30.0, // Adjust the width as needed
                    height: 30.0, // Adjust the height as needed
                    child: CircularProgressIndicator(
                      strokeWidth:
                          2.0, // Optional: Adjust the stroke width if needed
                    ),
                  ),
                )
          : GridView.builder(
              key: UniqueKey(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: Dimensions.paddingSizeLarge,
                mainAxisSpacing: ResponsiveHelper.isDesktop(context)
                    ? Dimensions.paddingSizeLarge
                    : 0.01,
                //childAspectRatio: ResponsiveHelper.isDesktop(context) && !isWebRestaurant! ? 3 : isWebRestaurant! ? 1.5 : showTheme1Restaurant ? 1.9 : 3.3,
                mainAxisExtent:
                    ResponsiveHelper.isDesktop(context) && !isWebRestaurant!
                        ? 142
                        : isWebRestaurant!
                            ? 280
                            : showTheme1Restaurant
                                ? 200
                                : 150,
                crossAxisCount:
                    ResponsiveHelper.isMobile(context) && !isWebRestaurant!
                        ? 1
                        : isWebRestaurant!
                            ? 4
                            : 3,
              ),
              physics: isScrollable
                  ? const BouncingScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              shrinkWrap: isScrollable ? false : true,
              itemCount: shimmerLength,
              padding: padding,
              itemBuilder: (context, index) {
                return showTheme1Restaurant
                    ? RestaurantShimmer(isEnable: isNull)
                    : isWebRestaurant!
                        ? const WebRestaurantShimmer()
                        : ProductShimmer(
                            isEnabled: isNull,
                            isRestaurant: isRestaurant,
                            hasDivider: index != shimmerLength - 1);
              },
            ),
    ]);
  }
}
