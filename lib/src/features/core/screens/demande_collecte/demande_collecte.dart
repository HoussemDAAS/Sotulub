import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sotulub/src/common_widgets/custom_Text_filed.dart';
import 'package:sotulub/src/constants/image_string.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/features/authentication/screens/login/Login_header_widget.dart';

class DemandeCollecte extends StatelessWidget {
  const DemandeCollecte({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          // leading: const Icon(Icons.menu, color: tPrimaryColor),
          title: Text('Demande de Collecte'.toUpperCase(),
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
                            // CustomDropdown(
                            //     labelText: 'Capacité de la cuve',
                            //     prefixIcon: Icons.oil_barrel_outlined,
                            //     items: const [
                            //       DropdownMenuItem(
                            //           value: '250L', child: Text('250L')),
                            //       DropdownMenuItem(
                            //           value: '500L', child: Text('500L')),
                            //       DropdownMenuItem(
                            //           value: '1000L', child: Text('1000L')),
                            //     ],
                            //     value: null,
                            //     onChanged: (newValue) {
                            //       // Handle the selected capacity
                            //       print(newValue);
                            //     },
                            //   ),
                          
                            // const SizedBox(height: tFormHeight - 10.0),
                            CustomTextField(
                              labelText: 'Qté Disponible Estimée',
                              hintText: '',
                              prefixIcon: Icons.question_mark_outlined,
                              controller:
                                  null, // You need to provide a TextEditingController
                        
                        
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
                            onPressed: () {
                              // if (_formKey.currentState!.validate()) {
                              //   SignUpController.instance.tRegisterDetenteur(
                              //       controller.email.text.trim(),
                              //       controller.password.text.trim(),
                              //       controller.raisonSocial.text.trim(),
                              //       controller.responsable.text.trim(),
                              //       controller.telephone.text.trim(),
                              //       controller.gouvernorat.value,
                              //       controller.delegation.value,
                              //       controller.secteurActivite.value,
                              //       controller.sousSecteurActivite.value);
                              //   Get.to(() => const Dashboard());
                              // }
                            },
                            child: Text('envoyer votre demande'.toUpperCase()),
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
