import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gazzer_userapp/features/auth/widgets/sign_up_widget.dart';
import 'package:gazzer_userapp/helper/responsive_helper.dart';
import 'package:gazzer_userapp/util/app_constants.dart';
import 'package:gazzer_userapp/util/dimensions.dart';
import 'package:gazzer_userapp/util/images.dart';
import 'package:gazzer_userapp/util/styles.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ResponsiveHelper.isDesktop(context)
          ? Colors.transparent
          : Theme.of(context).cardColor,
      body: SafeArea(
          child: Center(
        child: Container(
          width: context.width > 700 ? 700 : context.width,
          padding: context.width > 700
              ? const EdgeInsets.all(40)
              : const EdgeInsets.all(Dimensions.paddingSizeLarge),
          decoration: context.width > 700
              ? BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                )
              : null,
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                child: Text('sign_up'.tr,
                    style: robotoBold.copyWith(
                        fontSize: Dimensions.fontSizeExtraLarge)),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              const SignUpWidget(),
            ]),
          ),
        ),
      )),
    );
  }
}
