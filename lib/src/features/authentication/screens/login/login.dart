import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/constants/image_string.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/constants/text_strings.dart';
import 'package:sotulub/src/features/authentication/screens/forget_password/forget_password_options/forget_password_bottom_sheet.dart';
import 'package:sotulub/src/features/authentication/screens/forget_password/forget_password_options/forget_password_btn_widget.dart';
import 'package:sotulub/src/utils/theme/text_theme.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var height = size.height; // Get the screen height from size variable

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(tDefaultSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /* -- section 1--*/
                Image(
                  image: AssetImage(tWelcomeScreen),
                  height: height * 0.15, // Adjusted the image height
                ),
                Text(tWelcomeTitle,
                    style: TTextTheme.lightTextTheme.titleLarge),
                Text(tWelcomeSubTitle,
                    style: TTextTheme.lightTextTheme.titleMedium),
                /* -- section 2--*/
                Form(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: tFormHeight - 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person_outline_outlined),
                            labelText: tEmail,
                            hintText: "Enter votre email",
                            // enabledBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(color: tPrimaryColor, width: 2.0),
                            // ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: tPrimaryColor, width: 2.0),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                            labelStyle: TextStyle(color: tPrimaryColor),
                          ),
                        ),
                        const SizedBox(height: tFormHeight),
                        TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.fingerprint_outlined),
                            labelText: tPassword,
                            hintText: "Enter votre mot de passe",
                            // enabledBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(color: tPrimaryColor, width: 2.0),
                            // ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: tPrimaryColor, width: 2.0),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                            labelStyle: TextStyle(color: tPrimaryColor),
                            suffixIcon: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.remove_red_eye_sharp),
                            ),
                          ),
                        ),
                        SizedBox(height: tFormHeight - 10.0),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0),
                                  ),
                                ),
                                builder: (context) => ForgetPasswordBottomSheet(),
                              );
                            }, // Removed const keyword here
                            child: Text(tForgotPassword,
                                style: TTextTheme.lightTextTheme.displaySmall),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text(tLogin.toUpperCase()),
                          ),
                        ),
                        SizedBox(height: tFormHeight), // Added some space here
                        TextButton(
                          onPressed: () {},
                          child: Text.rich(TextSpan(
                              text: tDontHaveAccount + " ",
                              style: TTextTheme.lightTextTheme.displaySmall,
                              children: [
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

