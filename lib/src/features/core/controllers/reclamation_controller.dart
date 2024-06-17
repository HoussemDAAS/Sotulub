import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:sotulub/src/repository/detenteur_repos.dart';

class ReclamationController extends GetxController {
  static ReclamationController get instance => Get.find();
  
  final TextEditingController numeroReclamation = TextEditingController();
  final TextEditingController month = TextEditingController();
  final TextEditingController responsable = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController Raison = TextEditingController();
  final TextEditingController Description = TextEditingController();
  final TextEditingController replyController = TextEditingController();

  final DetenteurRepository _repository = DetenteurRepository.instance;

  

  void sendReply(String email, String documentId) async {
    try {
      String replyText = replyController.text.trim();
      
      if (replyText.isEmpty) {
        Get.snackbar(
          'Erreur',
          'Veuillez entrer une réponse',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      await _repository.addReplyToReclamation(email, documentId, replyText);

      replyController.clear();

      Get.snackbar(
        'Succès',
        'Réponse envoyée avec succès',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Erreur lors de l\'envoi de la réponse',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error sending reply: $e');
    }
  }
}
