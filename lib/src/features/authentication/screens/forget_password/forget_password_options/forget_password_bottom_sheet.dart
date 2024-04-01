import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/constants/text_strings.dart';
import 'package:sotulub/src/features/authentication/screens/forget_password/forget_password_mail/forget_password_mail.dart';
import 'package:sotulub/src/features/authentication/screens/forget_password/forget_password_options/forget_password_btn_widget.dart';
import 'package:sotulub/src/features/authentication/screens/forget_password/forget_password_phone/Forget_password_phone.dart';
import 'package:sotulub/src/utils/theme/text_theme.dart';

class ForgetPasswordBottomSheet extends StatelessWidget {
  const ForgetPasswordBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
       padding: EdgeInsets.all(tDefaultSize),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            tForgetPasswordTitle,
            style: TTextTheme.lightTextTheme.titleSmall,
          ),
          Text(
            tForgetPasswordSubTitle,
            style: TTextTheme.lightTextTheme.displayMedium,
          ),
        const   SizedBox(
            height: 30.0,
          ),
          ResetPasswordOption(
            icon: Icons.mail_outline_rounded,
            title: tEmail,
            subTitle: tRestViaEmail,
            onTap: () {
              Navigator.pop(context);
              Get.to(()=> const ForgetPasswordMailScreen());
            },
          ),
        const   SizedBox(
            height: 30.0,
          ),
          ResetPasswordOption(
            icon: Icons.mobile_friendly_rounded,
            title: tPhone,
            subTitle: tResetViaPhone,
            onTap: () {
              Navigator.pop(context);
              Get.to(()=> const ForgetPasswordPhoneScreen());
            },
          ),
        ],
      ),
    );
  }
}
