import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/features/authentication/screens/login/Login_header_widget.dart';
import 'package:sotulub/src/features/core/controllers/reclamation_controller.dart';
import 'package:sotulub/src/repository/admin_repos.dart';

class ReplyReclamtion extends StatefulWidget {
  final String email;
  final String id;

  const ReplyReclamtion({
    Key? key,
    required this.email,
    required this.id,
  }) : super(key: key);

  @override
  _ReplyReclamtionState createState() => _ReplyReclamtionState();
}

class _ReplyReclamtionState extends State<ReplyReclamtion> {
  final AdminRepository adminRepository = Get.put(AdminRepository());
  late Future<Map<String, dynamic>?> _reclamationFuture;

  @override
  void initState() {
    super.initState();
    _reclamationFuture = adminRepository.getReclamationByEmailAndId(widget.email, widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReclamationController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Répondre au reclamation'.toUpperCase(),
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(tDefaultSize),
        child: FutureBuilder<Map<String, dynamic>?>(
          future: _reclamationFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error.toString()}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('Aucune réclamation trouvée pour cet utilisateur.'));
            } else {
              Map<String, dynamic> reclamation = snapshot.data!;
              List<dynamic> replies = reclamation['replies'] ?? [];

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LoginHeader(
                      image: 'assets/images/reply.png',
                      title: "Réclamations et Réponses",
                      subtitle: "Répond des reclamations",
                    ),
                    const SizedBox(height: tDefaultSize),
                    Text(
                      'Raison du Réclamation:',
                      style: TextStyle(fontWeight: FontWeight.bold, color: tSecondaryColor),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      reclamation['raison'],
                      style: TextStyle(color: tAccentColor, fontSize: 24),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Description: ',
                      style: TextStyle(color: tSecondaryColor),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      reclamation['description'],
                      style: TextStyle(color: tAccentColor, fontSize: 18),
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
                    _buildReplyField(controller),
                    const SizedBox(height: 20),
                    _buildSendButton(controller, widget.id, widget.email),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildReplyField(ReclamationController controller) {
    return TextFormField(
      controller: controller.replyController,
      maxLines: 5,
      decoration: InputDecoration(
          labelStyle: const TextStyle(color: tPrimaryColor),
          focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: tPrimaryColor, width: 2.0),
        ),
        labelText: 'Entrez votre réponse ici',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildSendButton(ReclamationController controller, String reclamationId, String email) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => controller.sendReply(email, reclamationId),
        child: Text('Envoyer la Réponse'),
      ),
    );
  }
}
