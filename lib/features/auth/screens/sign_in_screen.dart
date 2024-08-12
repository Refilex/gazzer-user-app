import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gazzer_userapp/features/auth/controllers/auth_controller.dart';
import 'package:gazzer_userapp/features/auth/widgets/sign_in_widget.dart';
import 'package:gazzer_userapp/helper/responsive_helper.dart';
import 'package:gazzer_userapp/helper/route_helper.dart';
import 'package:gazzer_userapp/util/app_constants.dart';
import 'package:gazzer_userapp/util/dimensions.dart';
import 'package:gazzer_userapp/util/images.dart';
import 'package:gazzer_userapp/util/styles.dart';

class SignInScreen extends StatefulWidget {
  final bool exitFromApp;
  final bool backFromThis;

  const SignInScreen(
      {super.key, required this.exitFromApp, required this.backFromThis});

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _canExit = GetPlatform.isWeb ? true : false;

  @override
  void initState() {
    super.initState();

    _phoneController.text = Get.find<AuthController>().getUserNumber();
    _passwordController.text = Get.find<AuthController>().getUserPassword();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Navigator.canPop(context),
      onPopInvoked: (val) async {
        if (widget.exitFromApp) {
          if (_canExit) {
            if (GetPlatform.isAndroid) {
              SystemNavigator.pop();
            } else if (GetPlatform.isIOS) {
              exit(0);
            } else {
              Navigator.pushNamed(context, RouteHelper.getInitialRoute());
            }
            // return Future.value(false);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('back_press_again_to_exit'.tr,
                  style: const TextStyle(color: Colors.white)),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
              margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            ));
            _canExit = true;
            Timer(const Duration(seconds: 2), () {
              _canExit = false;
            });
            // return Future.value(false);
          }
        } else {
          return;
          // Get.back(result: false);
        }
      },
      child: Scaffold(
        backgroundColor: ResponsiveHelper.isDesktop(context)
            ? Colors.transparent
            : Theme.of(context).cardColor,
        appBar: ResponsiveHelper.isDesktop(context)
            ? null
            : !widget.exitFromApp
                ? AppBar(
                    leading: IconButton(
                      onPressed: () => Get.back(result: false),
                      icon: Icon(Icons.arrow_back_ios_rounded,
                          color: Theme.of(context).textTheme.bodyLarge!.color),
                    ),
                    elevation: 0,
                    backgroundColor: Theme.of(context).cardColor)
                : null,
        body: SafeArea(
            child: Center(
          child: Container(
            width: context.width > 700 ? 500 : context.width,
            padding: context.width > 700
                ? const EdgeInsets.all(50)
                : const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
            margin: context.width > 700
                ? const EdgeInsets.all(50)
                : EdgeInsets.zero,
            decoration: context.width > 700
                ? BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    boxShadow: ResponsiveHelper.isDesktop(context)
                        ? null
                        : [
                            BoxShadow(
                                color: Colors.grey[Get.isDarkMode ? 700 : 300]!,
                                blurRadius: 5,
                                spreadRadius: 1)
                          ],
                  )
                : null,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ResponsiveHelper.isDesktop(context)
                          ? Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                onPressed: () => Get.back(),
                                icon: const Icon(Icons.clear),
                              ),
                            )
                          : const SizedBox(),
                      Image.asset(Images.gazzerLogo, width: 100),
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                      const Text(
                        AppConstants.appName,
                        style: TextStyle(
                          color: Colors.deepOrange,
                          fontSize: 25.0,
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text('sign_in'.tr,
                            style: robotoBold.copyWith(
                                fontSize: Dimensions.fontSizeExtraLarge)),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),
                      SignInWidget(
                          exitFromApp: widget.exitFromApp,
                          backFromThis: widget.backFromThis),
                    ]),
              ),
            ),
          ),
        )),
      ),
    );
  }
}
