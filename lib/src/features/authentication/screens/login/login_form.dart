import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/constants/text_strings.dart';
import 'package:sotulub/src/features/authentication/screens/forget_password/forget_password_options/forget_password_bottom_sheet.dart';
import 'package:sotulub/src/features/core/screens/dashboard/widgets/detenteur_dashboard.dart';
import 'package:sotulub/src/utils/theme/text_theme.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
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
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: tPrimaryColor, width: 2.0),
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
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: tPrimaryColor, width: 2.0),
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
            const SizedBox(height: tFormHeight - 10.0),
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
                },
                child: Text(tForgotPassword,
                    style: TTextTheme.lightTextTheme.displaySmall),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => const Dashboard()); // Updated navigation method
                },
                child: Text(tLogin.toUpperCase()),
              ),
            ),
            SizedBox(height: tFormHeight), // Added some space here
          ],
        ),
      ),
    );
  }
}
