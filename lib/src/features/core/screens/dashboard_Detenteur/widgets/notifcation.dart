import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/features/authentication/screens/login/Login_header_widget.dart';
import 'package:sotulub/src/features/core/controllers/reclamation_controller.dart';
import 'package:sotulub/src/repository/detenteur_repos.dart';

class NotifcationPage extends StatelessWidget {
  const NotifcationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DetenteurRepository _repository = DetenteurRepository.instance;
    final controller = Get.put(ReclamationController());

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Réponses'.toUpperCase(),
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
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LoginHeader(
                  image: 'assets/images/alert.png',
                  title: "Réclamations et Réponses",
                  subtitle: "Détails de la Réclamation",
                ),
                const SizedBox(height: tDefaultSize),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _fetchReclamationsForCurrentUser(_repository),
                  builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      Get.snackbar(
                        'Erreur',
                        'Erreur lors du chargement des détails de réclamation',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                      return Center(child: Text('Erreur: ${snapshot.error.toString()}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('Aucune réclamation trouvée pour cet utilisateur.'));
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: snapshot.data!.map((reclamation) {
                          List<dynamic> replies = reclamation['replies'] ?? [];

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Raison du Réclamation:',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: tSecondaryColor),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    reclamation['raison'],
                                    style: TextStyle(color: tAccentColor, fontSize: 24),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Column(
                                children: [
                                  const Text(
                                    'Description: ',
                                    style: TextStyle(color: tSecondaryColor),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    reclamation['description'],
                                    style: TextStyle(color: tAccentColor, fontSize: 18),
                                  ),
                                ],
                              ),
                              const SizedBox(height: tDefaultSize),
                              if (replies.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Réponses:',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: tPrimaryColor),
                                    ),
                                    const SizedBox(height: 10),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: replies.length,
                                      itemBuilder: (context, index) {
                                        return Card(
                                          elevation: 0,
                                          child: ListTile(
                                            title: Text(replies[index]),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                )
                              else
                                Text(
                                  'Aucune réponse disponible pour cette réclamation.',
                                  style: TextStyle(color: tSecondaryColor),
                                ),
                              const SizedBox(height: tDefaultSize),
                              const Divider(color: tPrimaryColor),
                              const SizedBox(height: 10),
                              Text(
                                'Répondre à la Réclamation',
                                style: TextStyle(fontWeight: FontWeight.bold, color: tPrimaryColor),
                              ),
                              const SizedBox(height: 10),
                              _buildReplyField(controller, reclamation['id']), // Pass reclamation id or identifier
                              const SizedBox(height: 20),
                              _buildSendButton(controller, reclamation['id']), // Pass reclamation id or identifier
                            ],
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReplyField(ReclamationController controller, String reclamationId) {
    return TextFormField(
      controller: controller.replyController,
      decoration: const InputDecoration(
        labelStyle: TextStyle(color: tPrimaryColor),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: tPrimaryColor, width: 2.0),
        ),
        labelText: 'Votre Réponse',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: tPrimaryColor),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      maxLines: 4,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Veuillez entrer une réponse';
        }
        return null;
      },
    );
  }

  Widget _buildSendButton(ReclamationController controller, String reclamationId) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () async {
        if (controller.replyController.text.isEmpty) {
          Get.snackbar(
            'Erreur',
            'Veuillez entrer une réponse avant d\'envoyer.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } else {
          try {
            String? uid = await DetenteurRepository.instance.getCurrentDetenteurUid();
            if (uid != null) {
              String? email = await DetenteurRepository.instance.getDetenteurEmailByUid(uid);
              if (email != null) {
                controller.sendReply(email); // Pass email to sendReply
              } else {
                throw Exception("Email not found for current user");
              }
            } else {
              throw Exception("UID not found for current user");
            }
          } catch (e) {
            print('Error sending reply: $e');
            Get.snackbar(
              'Erreur',
              'Erreur lors de l\'envoi de la réponse',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        }
      },
      child: Text('Envoyer la Réponse'.toUpperCase()),
    ),
  );
}


  Future<List<Map<String, dynamic>>> _fetchReclamationsForCurrentUser(DetenteurRepository repository) async {
    try {
      String? uid = await repository.getCurrentDetenteurUid();
      if (uid != null) {
        String? email = await repository.getDetenteurEmailByUid(uid);
        if (email != null) {
          print(email);
          return await repository.getReclamationsByEmail(email);
          
        } else {
          throw Exception("Email not found for current user");
        }
      } else {
        throw Exception("UID not found for current user");
      }
    } catch (e) {
      print('Error fetching reclamation data: $e');
      throw e;
    }
  }
}
