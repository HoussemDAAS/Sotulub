import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sotulub/src/common_widgets/custom_Text_filed.dart';
import 'package:sotulub/src/constants/image_string.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/features/authentication/screens/login/Login_header_widget.dart';
import 'package:sotulub/src/features/core/controllers/demande_collecte_contorller.dart';
import 'package:sotulub/src/repository/auth_repository/DemandeColect_repos.dart';
import 'package:sotulub/src/repository/auth_repository/auth_repos.dart';

class DemandeCollecte extends StatelessWidget {
  const DemandeCollecte({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final controller = Get.put(DemandeCollecteController());

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
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
                                    // Retrieve logged-in user's email
                                    
                                    String email =
                                        AuthRepository.instance.firebaseUser.value!.email!;
                                    // Retrieve additional data based on email
                                    String responsable =
                                        await AuthRepository.instance
                                            .getResponsableByEmail(email);

                                    // Retrieve data from the controller
                                 
                                    String month = DateTime.now().month.toString();
                                    String quentity = controller.quentity.text;

                                    // Add data to the collection
                                    await DemandeColectRepository.instance
                                        .addDemandeCollect(
                                    
                                      month,
                                      responsable,
                                      email,
                                      quentity,
                                    );
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
