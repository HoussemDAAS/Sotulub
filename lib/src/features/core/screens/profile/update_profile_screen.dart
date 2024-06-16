import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/constants/text_strings.dart';
import 'package:sotulub/src/features/authentication/screens/splash_screen/splash_screen.dart';
import 'package:sotulub/src/repository/auth_repository/auth_repos.dart';
import 'package:sotulub/src/repository/detenteur_repos.dart';
import '../../../../common_widgets/custom_Text_filed.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final DetenteurRepository detenteurRepository = DetenteurRepository();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _raisonSocialController = TextEditingController();
  final TextEditingController _responsableController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchDetenteurData();
  }

  Future<void> _fetchDetenteurData() async {
    Map<String, dynamic>? detenteurData = await detenteurRepository.getCurrentDetenteurData();
    if (detenteurData != null) {
      setState(() {
        _emailController.text = detenteurData['email'] ?? '';
        _raisonSocialController.text = detenteurData['raisonSocial'] ?? '';
        _responsableController.text = detenteurData['responsable'] ?? '';
        _telephoneController.text = detenteurData['telephone'] ?? '';
      });
    }
  }

  Future<void> _handleUpdateProfile() async {
    if (_formKey.currentState!.validate()) {
      String? uid = await detenteurRepository.getCurrentDetenteurUid();
      if (uid != null) {
        Map<String, dynamic> updatedData = {
          'email': _emailController.text,
          'raisonSocial': _raisonSocialController.text,
          'responsable': _responsableController.text,
          'telephone': _telephoneController.text,
        };

        await detenteurRepository.updateDetenteurData(uid, updatedData);

        if (_currentPasswordController.text.isNotEmpty && _newPasswordController.text.isNotEmpty) {
          await _changePassword(_currentPasswordController.text, _newPasswordController.text);
        }

        _showSnackbar('Succès', 'Profil mis à jour avec succès.', Colors.green);
      }
    }
  }

  Future<void> _changePassword(String currentPassword, String newPassword) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Re-authenticate the user with the current password
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);

        // Update the user's password
        await user.updatePassword(newPassword);
        _showSnackbar('Succès', 'Mot de passe mis à jour avec succès.', Colors.green);
      } catch (e) {
        _showSnackbar('Erreur', 'Erreur lors de la mise à jour du mot de passe: $e', Colors.red);
      }
    }
  }

  void _handleLogout() {
    AuthRepository.instance.logout().then((_) {
      Get.offAll(() => SplachScreen());
    }).catchError((error) {
      print('Logout error: $error');
    });
  }

  void _showSnackbar(String title, String message, Color color) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: color,
      colorText: Colors.white,
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tEditProfil.toUpperCase(),
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: tPrimaryColor),
            onPressed: () {
              _handleLogout();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDefaultSize),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  labelText: 'E-mail *',
                  hintText: '',
                  prefixIcon: Icons.mail_outline_outlined,
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: tFormHeight - 10.0),
                CustomTextField(
                  labelText: 'Current Password',
                  hintText: 'Enter your current password',
                  prefixIcon: Icons.lock_outline,
                  controller: _currentPasswordController,
                  validator: (value) {
                    return null;
                  },
                  isPassword: true,
                ),
                const SizedBox(height: tFormHeight - 10.0),
                CustomTextField(
                  labelText: 'New Password',
                  hintText: 'Enter your new password',
                  prefixIcon: Icons.lock_outline,
                  controller: _newPasswordController,
                  validator: (value) {
                    if (value != null && value.isNotEmpty && value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                  isPassword: true,
                ),
                const SizedBox(height: tFormHeight - 10.0),
                const Divider(
                  color: Colors.grey,
                  thickness: 1.0,
                ),
                const SizedBox(height: tFormHeight - 10.0),
                CustomTextField(
                  labelText: 'Raison Social *',
                  hintText: 'Raison Sociale (identité demandeur)',
                  prefixIcon: Icons.home_work_outlined,
                  controller: _raisonSocialController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field is required';
                    }
                    if (value.length < 8) {
                      return 'Must be at least 8 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: tFormHeight - 10.0),
                CustomTextField(
                  labelText: 'Responsable *',
                  hintText: '',
                  prefixIcon: Icons.person_2_outlined,
                  controller: _responsableController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field is required';
                    }
                    if (value.length < 8) {
                      return 'Must be at least 8 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: tFormHeight - 10.0),
                CustomTextField(
                  labelText: 'Téléphone *',
                  hintText: '',
                  prefixIcon: Icons.local_phone_outlined,
                  controller: _telephoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    if (value.length < 8) {
                      return 'Must be at least 8 characters long';
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
                    onPressed: _handleUpdateProfile,
                    child: Text('Update Profile'),
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
