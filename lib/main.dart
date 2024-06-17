import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sotulub/firebase_options.dart';
import 'package:sotulub/src/features/authentication/screens/welcome/welcome_screen.dart';

import 'package:sotulub/src/repository/DemandeColect_repos.dart';
import 'package:sotulub/src/repository/DemandeCuve_repos.dart';
import 'package:sotulub/src/repository/auth_repository/auth_repos.dart';
import 'package:sotulub/src/utils/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  Get.put(AuthRepository());
  Get.put(DemandeColectRepository()); 
  Get.put(DemandeCuveRepo());

  runApp( App());
}
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.leftToRightWithFade,
      transitionDuration: const Duration(milliseconds: 500),
      home: const  WelcomeScreen(),
    );
  }
}
