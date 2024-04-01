import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/constants/text_strings.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                tOtpTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                tOtpSubTitle.toUpperCase(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 40.0),
              Text(
                tOtpMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 20.0),
              OtpTextField(
                numberOfFields: 6,
                
                fillColor: tPrimaryColor.withOpacity(0.1),
                 focusedBorderColor: tPrimaryColor,
                filled: true,
                keyboardType: TextInputType.number,
                onSubmit: (code){
                 
                },
              ),
              const SizedBox(height: 20.0),
               SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    
                  },
                  child: Text("Vérifier".toUpperCase()),
                ),
              ),
            ])),
      ),
    );
  }
}
