import 'package:flutter/material.dart';

import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/constants/text_strings.dart';
import 'package:sotulub/src/features/authentication/controllers/login_controller.dart';
import 'package:sotulub/src/features/authentication/screens/forget_password/forget_password_options/forget_password_bottom_sheet.dart';
import 'package:sotulub/src/utils/theme/text_theme.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isObscured = true;
final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: tFormHeight - 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email is required';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Enter a valid email address';
                }
                return null;
              },
              decoration: const  InputDecoration(
                prefixIcon: Icon(Icons.person_outline_outlined),
                labelText: tEmail,
                hintText: "Enter your email",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: tPrimaryColor, width: 2.0),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
                labelStyle: TextStyle(color: tPrimaryColor),
              ),
            ),
         const   SizedBox(height: tFormHeight),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }
                // You might add additional validation rules here if needed
                return null;
              },
              obscureText: _isObscured, // Toggle password visibility
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.fingerprint_outlined),
                labelText: tPassword,
                hintText: "Enter your password",
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: tPrimaryColor, width: 2.0),
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
                labelStyle: const TextStyle(color: tPrimaryColor),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured; // Toggle the boolean value
                    });
                  },
                  icon: Icon(_isObscured ? Icons.visibility : Icons.visibility_off), // Toggle icon based on the boolean value
                ),
              ),
            ),
         const   SizedBox(height: tFormHeight - 10.0),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    builder: (context) => const  ForgetPasswordBottomSheet(),
                  );
                },
                child: Text(tForgotPassword, style: TTextTheme.lightTextTheme.displaySmall),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Perform login action
                  if (_formKey.currentState!.validate()) {
                    // If form is valid, proceed with login
                    LoginController.instance.login();
                  }
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
