

import 'package:flutter/material.dart';
import 'package:sotulub/src/constants/text_strings.dart';

class WelcomeScreen extends StatelessWidget{
    const WelcomeScreen ({Key? Key}) : super (key: Key);

    @override
Widget build(BuildContext context){

  return Scaffold(
    body: Container(
     child: Column(
      children: [
        Image(image: AssetImage("assets/images/oil.png")),
        Text(tWelcomeSubTitle),
        Text(tWelcomeTitle),
        Row(
          children: [
            OutlinedButton(onPressed: () {}, child:  Text(tLogin)),
            ElevatedButton(onPressed: () {}, child:  Text(tRegister)),

          ],
        )
      ],
      
     ),
    )
  );
} 



}