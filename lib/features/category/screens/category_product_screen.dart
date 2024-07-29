import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/common/widgets/cart_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:stackfood_multivendor/common/widgets/product_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/veg_filter_widget.dart';
import 'package:stackfood_multivendor/common/widgets/web_menu_bar.dart';
import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';

class CategoryProductScreen extends StatefulWidget {
  final String? categoryID;
  final String categoryName;

  const CategoryProductScreen({
    Key? key,
    required this.categoryID,
    required this.categoryName,
  }) : super(key: key);

  @override
  CategoryProductScreenState createState() => CategoryProductScreenState();
}

class CategoryProductScreenState extends State<CategoryProductScreen>
    with TickerProviderStateMixin {
  final ScrollController restaurantScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Fetch the subcategory list and the category restaurant list when the screen initializes
    Get.find<CategoryController>().getSubCategoryList(widget.categoryID);
    Get.find<CategoryController>().getCategoryRestaurantList(
      widget.categoryID,
      1,
      'all',
      false,
    );

    restaurantScrollController.addListener(() {
      if (restaurantScrollController.position.pixels ==
              restaurantScrollController.position.maxScrollExtent &&
          Get.find<CategoryController>().categoryRestaurantList != null &&
          !Get.find<CategoryController>().isLoading) {
        int pageSize =
            (Get.find<CategoryController>().restaurantPageSize! / 10).ceil();
        if (Get.find<CategoryController>().offset < pageSize) {
          debugPrint('End of the page');
          Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getCategoryRestaurantList(
            Get.find<CategoryController>().subCategoryIndex == 0
                ? widget.categoryID
                : Get.find<CategoryController>()
                    .subCategoryList![
                        Get.find<CategoryController>().subCategoryIndex]
                    .id
                    .toString(),
            Get.find<CategoryController>().offset + 1,
            Get.find<CategoryController>().type,
            false,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (catController) {
      List<Restaurant>? restaurants;
      if (catController.categoryRestaurantList != null &&
          catController.searchRestaurantList != null) {
        restaurants = [];
        if (catController.isSearching) {
          restaurants.addAll(catController.searchRestaurantList!);
        } else {
          restaurants.addAll(catController.categoryRestaurantList!);
        }
      }

      return PopScope(
        canPop: Navigator.canPop(context),
        onPopInvoked: (val) async {
          if (catController.isSearching) {
            catController.toggleSearch();
          } else {}
        },
        child: Scaffold(
          appBar: ResponsiveHelper.isDesktop(context)
              ? const WebMenuBar()
              : AppBar(
                  title: catController.isSearching
                      ? TextField(
                          autofocus: true,
                          textInputAction: TextInputAction.search,
                          decoration: const InputDecoration(
                            hintText: 'Search...',
                            border: InputBorder.none,
                          ),
                          style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeLarge),
                          onSubmitted: (String query) =>
                              catController.searchData(
                            query,
                            catController.subCategoryIndex == 0
                                ? widget.categoryID
                                : catController
                                    .subCategoryList![
                                        catController.subCategoryIndex]
                                    .id
                                    .toString(),
                            catController.type,
                          ),
                        )
                      : Text(widget.categoryName,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          )),
                  centerTitle: true,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    onPressed: () {
                      if (catController.isSearching) {
                        catController.toggleSearch();
                      } else {
                        Get.back();
                      }
                    },
                  ),
                  backgroundColor: Theme.of(context).cardColor,
                  elevation: 0,
                  actions: [
                    IconButton(
                      onPressed: () => catController.toggleSearch(),
                      icon: Icon(
                        catController.isSearching
                            ? Icons.close_sharp
                            : Icons.search,
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.toNamed(RouteHelper.getCartRoute()),
                      icon: CartWidget(
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                          size: 25),
                    ),
                    VegFilterWidget(
                        type: catController.type,
                        fromAppBar: true,
                        onSelected: (String type) {
                          if (catController.isSearching) {
                            catController.searchData(
                              catController.searchText,
                              catController.subCategoryIndex == 0
                                  ? widget.categoryID
                                  : catController
                                      .subCategoryList![
                                          catController.subCategoryIndex]
                                      .id
                                      .toString(),
                              type,
                            );
                          } else {
                            catController.getCategoryRestaurantList(
                              catController.subCategoryIndex == 0
                                  ? widget.categoryID
                                  : catController
                                      .subCategoryList![
                                          catController.subCategoryIndex]
                                      .id
                                      .toString(),
                              1,
                              type,
                              true,
                            );
                          }
                        }),
                  ],
                ),
          endDrawer: const MenuDrawerWidget(),
          endDrawerEnableOpenDragGesture: false,
          body: Column(
            children: [
              (catController.subCategoryList != null &&
                      !catController.isSearching)
                  ? Center(
                      child: Container(
                        height: 40,
                        width: Dimensions.webMaxWidth,
                        color: Theme.of(context).cardColor,
                        padding: const EdgeInsets.symmetric(
                            vertical: Dimensions.paddingSizeExtraSmall),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: catController.subCategoryList!.length,
                          padding: const EdgeInsets.only(
                              left: Dimensions.paddingSizeSmall),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                catController.setSubCategoryIndex(
                                    index, widget.categoryID);
                                catController.getCategoryRestaurantList(
                                  catController.subCategoryList![index].id
                                      .toString(),
                                  1,
                                  catController.type,
                                  true,
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeSmall,
                                    vertical: Dimensions.paddingSizeExtraSmall),
                                margin: const EdgeInsets.only(
                                    right: Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusSmall),
                                  color: index == catController.subCategoryIndex
                                      ? Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1)
                                      : Colors.transparent,
                                ),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        catController
                                            .subCategoryList![index].name!,
                                        style: index ==
                                                catController.subCategoryIndex
                                            ? robotoMedium.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall,
                                                color: Theme.of(context)
                                                    .primaryColor)
                                            : robotoRegular.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall),
                                      ),
                                    ]),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : const SizedBox(),
              Expanded(
                child: NotificationListener(
                  onNotification: (dynamic scrollNotification) {
                    if (scrollNotification is ScrollEndNotification) {
                      if ((!catController.isRestaurant) ||
                          (catController.isRestaurant)) {
                        if (catController.isSearching) {
                          catController.searchData(
                            catController.searchText,
                            catController.subCategoryIndex == 0
                                ? widget.categoryID
                                : catController
                                    .subCategoryList![
                                        catController.subCategoryIndex]
                                    .id
                                    .toString(),
                            catController.type,
                          );
                        } else {
                          catController.getCategoryRestaurantList(
                            catController.subCategoryIndex == 0
                                ? widget.categoryID
                                : catController
                                    .subCategoryList![
                                        catController.subCategoryIndex]
                                    .id
                                    .toString(),
                            1,
                            catController.type,
                            false,
                          );
                        }
                      }
                    }
                    return false;
                  },
                  child: SingleChildScrollView(
                    child: FooterViewWidget(
                      child: Center(
                        child: SizedBox(
                          width: Dimensions.webMaxWidth,
                          child: Column(
                            children: [
                              ProductViewWidget(
                                isRestaurant: true,
                                products: null,
                                restaurants: restaurants,
                                noDataText: 'no_category_restaurant_found'.tr,
                              ),
                              catController.isLoading
                                  ? Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(
                                            Dimensions.paddingSizeSmall),
                                        child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Theme.of(context)
                                                        .primaryColor)),
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
