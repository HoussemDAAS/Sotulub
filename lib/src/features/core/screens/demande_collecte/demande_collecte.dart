import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sotulub/src/common_widgets/bottom_naviagtion_bar.dart';
import 'package:sotulub/src/common_widgets/custom_Text_filed.dart';
import 'package:sotulub/src/constants/image_string.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/features/authentication/screens/login/Login_header_widget.dart';
import 'package:sotulub/src/features/core/controllers/demande_collecte_contorller.dart';
import 'package:sotulub/src/repository/DemandeColect_repos.dart';
import 'package:sotulub/src/repository/auth_repository/auth_repos.dart';

class DemandeCollecte extends StatelessWidget {
  const DemandeCollecte({Key? key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final controller = Get.put(DemandeCollecteController());

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Demande de Collecte'.toUpperCase(),
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        bottomNavigationBar: const BottomNavigation(
          convention: true,
          defaultIndex: 1,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(tDefaultSize),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LoginHeader(
                      image: tTrack,
                      title: "Demande de Collecte",
                      subtitle: "Formulaire demande de collecte",
                    ),
                    Form(
                      key: _formKey,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: tFormHeight - 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              labelText: 'Qté Disponible Estimée',
                              hintText: '',
                              prefixIcon: Icons.question_mark_outlined,
                              controller: controller.quentity,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'This field is required';
                                }
                                if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                  return 'Please enter only numbers';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: tFormHeight - 10.0),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      // Retrieve logged-in user's email
                                      String email = AuthRepository.instance.firebaseUser.value!.email!;
                                      
                                      // Retrieve additional data based on email
                                      Map<String, dynamic> userData = await AuthRepository.instance.getDataByEmail(email);
                                      
                                      // Retrieve data from the userData map
                                      String telephone = userData['telephone'].toString();
                                      String gouvernorat = userData['gouvernorat'].toString();
                                      String delegation = userData['delegation'].toString();
                                      String longitude = userData['longitude'].toString();
                                      String latitude = userData['latitude'].toString();
                                      String responsable = await AuthRepository.instance.getResponsableByEmail(email);

                                      // Retrieve current month and quantity from the controller
                                      String month = DateTime.now().month.toString();
                                      String quantity = controller.quentity.text;

                                      // Add data to the collection
                                      await DemandeColectRepository.instance.addDemandeCollect(
                                        month,
                                        responsable,
                                        email,
                                        quantity,
                                        telephone,
                                        gouvernorat,
                                        delegation,
                                        longitude,
                                        latitude,
                                      );
                                    } catch (e) {
                                      // Handle any errors that occur during the process
                                      print('Error: $e');
                                      // Optionally display an error message to the user
                                      Get.snackbar(
                                        'Error',
                                        'An error occurred while processing your request. Please try again later.',
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                      );
                                    }
                                  }
                                },
                                child: Text(
                                  'envoyer votre demande'.toUpperCase(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
