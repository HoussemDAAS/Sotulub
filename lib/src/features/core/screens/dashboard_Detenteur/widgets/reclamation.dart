import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sotulub/src/common_widgets/CustomTextArea.dart';
import 'package:sotulub/src/common_widgets/custom_Text_filed.dart';
import 'package:sotulub/src/common_widgets/custom_dropdown.dart';
import 'package:sotulub/src/constants/image_string.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/features/authentication/screens/login/Login_header_widget.dart';
import 'package:sotulub/src/features/core/controllers/demande_cuve_controller.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Detenteur/widgets/detenteur_dashboard.dart';
import 'package:sotulub/src/repository/DemandeCuve_repos.dart';
import 'package:sotulub/src/repository/auth_repository/auth_repos.dart';

class ReclamationPage extends StatelessWidget {
  const ReclamationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final controller = Get.put(DemandeCuveController());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          // leading: const Icon(Icons.menu, color: tPrimaryColor),
          title: Text('Reclamation'.toUpperCase(),
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
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
                      image: 'assets/images/alert.png',
                      title: "Remplir une Reclamation",
                      subtitle: "Formulaire Reclamation",
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
                              labelText: 'Raison du Réclamation',
                              hintText: '',
                              prefixIcon: Icons.question_mark_outlined,
                              controller: controller
                                  .nbCuve, // Use textEditingController property
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'S' 'il vous plaît entrer une raison';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: tFormHeight - 10.0),
                            CustomTextArea(
                              labelText: 'Description',
                              hintText: 'Enter your description here',
                              prefixIcon: Icons.description,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
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
                                    String email = AuthRepository
                                        .instance.firebaseUser.value!.email!;
                                    String responsable = await AuthRepository
                                        .instance
                                        .getResponsableByEmail(email);
                                    Map<String, dynamic> userData =
                                        await AuthRepository.instance
                                            .getDataByEmail(email);
                                    String month =
                                        DateTime.now().month.toString();
                                    String nbCuve = controller.nbCuve.text;
                                    String capaciteCuve =
                                        controller.capaciteCuve.value;
                                    String telephone =
                                        userData['telephone'].toString();
                                    String gouvernorat =
                                        userData['gouvernorat'].toString();
                                    String delegation =
                                        userData['delegation'].toString();
                                    String longitude =
                                        userData['longitude'].toString();
                                    String latitude =
                                        userData['latitude'].toString();

                                    await DemandeCuveRepo.instance
                                        .addDemandeCuve(
                                            month,
                                            responsable,
                                            email,
                                            nbCuve,
                                            capaciteCuve,
                                            telephone,
                                            gouvernorat,
                                            delegation,
                                            longitude,
                                            latitude);
                                  }
                                  Get.to(() => const Dashboard());
                                },
                                child:
                                    Text('envoyer votre demande'.toUpperCase()),
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
