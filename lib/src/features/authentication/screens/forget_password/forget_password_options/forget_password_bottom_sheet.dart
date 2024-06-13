import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/constants/text_strings.dart';
import 'package:sotulub/src/features/authentication/screens/forget_password/forget_password_options/forget_password_btn_widget.dart';
import 'package:sotulub/src/utils/theme/text_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class ForgetPasswordBottomSheet extends StatelessWidget {
  const ForgetPasswordBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Uri phoneNumber = Uri.parse('tel:+216-71-861-234');
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'admin@gmail.com',
      query: 'subject=Mot de passe Reset&body=Merci de reinitialiser ma mot de passe',
    );

    return Container(
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
          const SizedBox(
            height: 30.0,
          ),
          ResetPasswordOption(
            icon: Icons.mail_outline_rounded,
            title: 'Par Email',
            subTitle: 'admin@gmail.com',
            onTap: () async {
              Navigator.pop(context);
              if (await canLaunch(emailUri.toString())) {
                await launch(emailUri.toString());
              } else {
                Get.snackbar('Erreur', 'Impossible d\'ouvrir l\'application de messagerie.',
                    snackPosition: SnackPosition.BOTTOM);
              }
            },
          ),
          const SizedBox(
            height: 30.0,
          ),
          ResetPasswordOption(
            icon: Icons.mobile_friendly_rounded,
            title: 'Par Téléphone',
            subTitle: '(+216) 71 86 12 34',
            onTap: () async {
              Navigator.pop(context);
              if (await canLaunch(phoneNumber.toString())) {
                await launch(phoneNumber.toString());
              } else {
                Get.snackbar('Erreur', 'Impossible d\'ouvrir l\'application de téléphone.',
                    snackPosition: SnackPosition.BOTTOM);
              }
            },
          ),
        ],
      ),
    );
  }
}
