import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sotulub/src/common_widgets/CustomTextArea.dart';
import 'package:sotulub/src/common_widgets/custom_Text_filed.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/features/authentication/screens/login/Login_header_widget.dart';
import 'package:sotulub/src/features/core/controllers/reclamation_controller.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Detenteur/widgets/detenteur_dashboard.dart';
import 'package:sotulub/src/repository/detenteur_repos.dart';

class ReclamationPage extends StatelessWidget {
  const ReclamationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final controller = Get.put(ReclamationController());

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Reclamation'.toUpperCase(),
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Padding(
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
                    padding: EdgeInsets.symmetric(vertical: tFormHeight - 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          labelText: 'Raison du Réclamation',
                          hintText: '',
                          prefixIcon: Icons.question_mark_outlined,
                          controller: controller.Raison,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer une raison';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: tFormHeight - 10.0),
                        CustomTextArea(
                          labelText: 'Description',
                          hintText: 'Entrez votre description ici',
                          prefixIcon: Icons.description,
                          controller: controller.Description,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer du texte';
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
                                  String email = ''; // Replace with actual logic to get email
                                  String responsable = ''; // Replace with actual logic to get responsable
                                  String month = DateTime.now().month.toString();
                                  String raison = controller.Raison.text;
                                  String description = controller.Description.text;
                                  String telephone = ''; // Replace with actual logic to get telephone

                                  await DetenteurRepository.instance.addDemandeReclamation(
                                    month,
                                    responsable,
                                    email,
                                    raison,
                                    description,
                                    telephone,
                                  );

                                  // Show success snackbar in French
                                  Get.snackbar(
                                    'Succès',
                                    'Demande de réclamation envoyée avec succès',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                  );

                                  // Clear form fields
                                  controller.Raison.clear();
                                  controller.Description.clear();

                                  // Navigate to dashboard
                                  Get.to(() => const Dashboard());
                                } catch (e) {
                                  // Show error snackbar in French
                                  Get.snackbar(
                                    'Erreur',
                                    'Erreur lors de l\'envoi de la demande de réclamation',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                  print('Error adding demandeReclamation document: $e');
                                }
                              }
                            },
                            child: Text('Envoyer votre demande'.toUpperCase()),
                          ),
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
