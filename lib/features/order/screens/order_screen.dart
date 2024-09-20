import 'package:gazzer_userapp/features/order/controllers/order_controller.dart';
import 'package:gazzer_userapp/features/order/widgets/guest_track_order_input_view_widget.dart';
import 'package:gazzer_userapp/features/order/widgets/order_view_widget.dart';
import 'package:gazzer_userapp/helper/auth_helper.dart';
import 'package:gazzer_userapp/helper/responsive_helper.dart';
import 'package:gazzer_userapp/helper/route_helper.dart';
import 'package:gazzer_userapp/util/dimensions.dart';
import 'package:gazzer_userapp/util/styles.dart';
import 'package:gazzer_userapp/common/widgets/custom_app_bar_widget.dart';
import 'package:gazzer_userapp/common/widgets/menu_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderScreen extends StatefulWidget {
  OrderScreen({super.key, required this.isScreen});

  bool isScreen;
  @override
  OrderScreenState createState() => OrderScreenState();
}

class OrderScreenState extends State<OrderScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, initialIndex: 0, vsync: this);
    initCall();
  }

  void initCall() {
    if (AuthHelper.isLoggedIn()) {
      Get.find<OrderController>().getRunningOrders(1, notify: false);
      Get.find<OrderController>()
          .getRunningSubscriptionOrders(1, notify: false);
      Get.find<OrderController>().getHistoryOrders(1, notify: false);
      // Get.find<OrderController>().getSubscriptions(1, notify: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = AuthHelper.isLoggedIn();
    return Scaffold(
      appBar: CustomAppBarWidget(
          title: 'my_orders'.tr,
        isBackButtonExist:
            widget.isScreen || ResponsiveHelper.isDesktop(context),
        onBackPressed: () {
          Get.offNamed(RouteHelper.main);
        },
      ),
      endDrawer: const MenuDrawerWidget(),
      endDrawerEnableOpenDragGesture: false,
      body: isLoggedIn
          ? GetBuilder<OrderController>(
              builder: (orderController) {
                return Column(children: [
                  Container(
                    color: ResponsiveHelper.isDesktop(context)
                        ? Theme.of(context).primaryColor.withOpacity(0.1)
                        : Colors.transparent,
                    child: Column(
                      children: [
                        ResponsiveHelper.isDesktop(context)
                            ? Center(
                                child: Padding(
                                padding: const EdgeInsets.only(
                                    top: Dimensions.paddingSizeSmall),
                                child:
                                    Text('my_orders'.tr, style: robotoMedium),
                              ))
                            : const SizedBox(),
                        Center(
                          child: SizedBox(
                            width: Dimensions.webMaxWidth,
                            child: Align(
                              alignment: ResponsiveHelper.isDesktop(context)
                                  ? Alignment.centerLeft
                                  : Alignment.center,
                              child: Container(
                                width: ResponsiveHelper.isDesktop(context)
                                    ? 350
                                    : Dimensions.webMaxWidth,
                                color: ResponsiveHelper.isDesktop(context)
                                    ? Colors.transparent
                                    : Theme.of(context).cardColor,
                                child: TabBar(
                                  controller: _tabController,
                                  indicatorColor:
                                      Theme.of(context).primaryColor,
                                  indicatorWeight: 3,
                                  labelColor: Theme.of(context).primaryColor,
                                  unselectedLabelColor:
                                      Theme.of(context).disabledColor,
                                  unselectedLabelStyle: robotoRegular.copyWith(
                                      color: Theme.of(context).disabledColor,
                                      fontSize: Dimensions.fontSizeSmall),
                                  labelStyle: robotoBold.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      color: Theme.of(context).primaryColor),
                                  tabs: [
                                    Tab(text: 'running'.tr),
                                    Tab(text: 'subscription'.tr),
                                    Tab(text: 'history'.tr),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: TabBarView(
                    controller: _tabController,
                    children: const [
                      OrderViewWidget(isRunning: true),
                      OrderViewWidget(isRunning: false, isSubscription: true),
                      OrderViewWidget(isRunning: false),
                    ],
                  )),
                ]);
              },
            )
          : const GuestTrackOrderInputViewWidget(),
    );
  }
}
