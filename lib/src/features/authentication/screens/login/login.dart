import 'package:flutter/material.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/constants/image_string.dart';

import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/constants/text_strings.dart';
import 'package:sotulub/src/features/authentication/screens/login/Login_header_widget.dart';

import 'package:sotulub/src/features/authentication/screens/login/login_form.dart';
import 'package:sotulub/src/utils/theme/text_theme.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {;
// Get the screen height from size variable

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(tDefaultSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /* -- section 1 Form HeaderWidget--*/
               const LoginHeader(
                 image: tWelcomeScreen,
                 title: tWelcomeTitle,
                 subtitle: tWelcomeSubTitle,
               ),
                /* -- section 2 Form widget--*/
               const LoginForm(),
                 /* -- section 3 Form FooterWidget--*/
                TextButton(
                  onPressed: () {},
                  child: Text.rich(TextSpan(
                      text: tDontHaveAccount + " ",
                      style: TTextTheme.lightTextTheme.displaySmall,
                      children:const [
                        TextSpan(
                          text: tRegister,
                          style: TextStyle(color: tPrimaryColor),
                        )
                      ])),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
