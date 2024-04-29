import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';

import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:sotulub/firebase_options.dart';
import 'package:sotulub/src/features/authentication/screens/splash_screen/splash_screen.dart';
import 'package:sotulub/src/features/core/controllers/demande_collecte_contorller.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Detenteur/widgets/detenteur_dashboard.dart';
import 'package:sotulub/src/features/core/screens/profile/profile_screen.dart';
import 'package:sotulub/src/repository/DemandeColect_repos.dart';
import 'package:sotulub/src/repository/DemandeCuve_repos.dart';

import 'package:sotulub/src/repository/auth_repository/auth_repos.dart';
import 'package:sotulub/src/utils/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((value) {
    Get.put(AuthRepository());
    Get.put(DemandeColectRepository()); 
    Get.put(DemandeCuveRepo());// Initialize the controller here
  });
  runApp(const App());
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
      home:const ProfileScreen(),
      
    );
  }
}

// class AppHome extends StatelessWidget {
//   const AppHome({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sotulub'),
//         leading: const Icon(Icons.ondemand_video),
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.add_shopping_cart),
//         onPressed: () {},
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: ListView(
//           children: [
//             Text('Sotulub', style: Theme.of(context).textTheme.displayMedium),
//             // const Text('Sotulub'),
//             // const Text('Sotulub'),
//             // ElevatedButton(
//             //   onPressed: () {},
//             //   child: const Text("Elevated Button"),
//             // ),
//             // OutlinedButton(
//             //   onPressed: () {},
//             //   child: const Text("Outlined Button"),
//             // ),
//             // const Padding(
//             //   padding: EdgeInsets.all(20.0), // No trailing comma here
//             //   child: Image(image: AssetImage("assets/images/books.png")),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }
