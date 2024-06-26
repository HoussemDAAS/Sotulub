import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/constants/image_string.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/constants/text_strings.dart';
import 'package:sotulub/src/features/authentication/screens/forget_password/forget_password_otp/otp_screen.dart';
import 'package:sotulub/src/features/authentication/screens/login/Login_header_widget.dart';

class ForgetPasswordPhoneScreen extends StatelessWidget {
  const ForgetPasswordPhoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(
              children:   [
              const  SizedBox(
                 height: tDefaultSize*4,
               ),
              const  LoginHeader(
                image: tForget,
                title: tPhone,
                subtitle: "Merci d'enter votre Numéro de Telephone",
                crossAxisAlignment: CrossAxisAlignment.center,
                heightBetween: 30.0,
                textAlign: TextAlign.center,
                
               ),
              const  SizedBox(
                 height: tFormHeight,
                 ),
                 Form(child: Column(
                  children: [
                   const  TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_outline_outlined),
                    labelText: "Phone",
                    hintText: " Numéro de Telephone",
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
                 SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(()=>const OTPScreen());
                  },
                  child: Text("Envoyer".toUpperCase()),
                ),
              ),
                  ],
                 ),
                 )
          
               
              ],
            ),
            
          ),
        ),
      ),
    );
  }
}