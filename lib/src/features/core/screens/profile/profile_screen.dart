import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:sotulub/src/common_widgets/ProfileMenu.dart';
import 'package:sotulub/src/common_widgets/bottom_naviagtion_bar.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/features/authentication/screens/splash_screen/splash_screen.dart';
import 'package:sotulub/src/features/core/screens/profile/update_profile_screen.dart';
import 'package:sotulub/src/repository/auth_repository/auth_repos.dart';
import 'package:sotulub/src/repository/detenteur_repos.dart';
import 'package:sotulub/src/utils/theme/text_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DetenteurRepository detenteurRepository = DetenteurRepository();
  String? _detenteurUid;
  String? _detenteurResponsable;
  String? _detenteurEmail;

  @override
  void initState() {
    super.initState();
    _fetchDetenteurData();
  }

  Future<void> _fetchDetenteurData() async {
    String? detenteurUid = await detenteurRepository.getCurrentDetenteurUid();
    if (detenteurUid != null) {
      setState(() {
        _detenteurUid = detenteurUid;
      });

      String? responsable = await detenteurRepository.getDetenteurResponsableNameByUid(detenteurUid);
      setState(() {
        _detenteurResponsable = responsable;
      });

      String? email = await detenteurRepository.getDetenteurEmailByUid(detenteurUid);
      setState(() {
        _detenteurEmail = email;
      });
    } else {
      _showSnackbar('Erreur', 'ID du détenteur introuvable.');
    }
  }

  Future<void> _handleRefresh() async {
    await _fetchDetenteurData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('PROFIL',
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
      bottomNavigationBar: const BottomNavigation(
        convention: true,
        defaultIndex: 2,
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(
              children: [
                Text(_detenteurResponsable ?? 'Détenteur', style: Theme.of(context).textTheme.titleSmall),
                Text(_detenteurEmail ?? 'Email', style: TTextTheme.lightTextTheme.displayMedium),
                const SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => const UpdateProfileScreen());
                    },
                    child: Text('MODIFIER LE PROFIL'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tSecondaryColor,
                      shape: const StadiumBorder(),
                      side: const BorderSide(color: tSecondaryColor),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(),
                ProfileMenuWidget(
                  title: "Paramètres",
                  icon: LineAwesomeIcons.cog,
                  onPress: () {},
                ),
                ProfileMenuWidget(
                  title: "Assistance",
                  icon: LineAwesomeIcons.user_check,
                  onPress: () {},
                ),
                ProfileMenuWidget(
                  title: "Réclamation",
                  icon: LineAwesomeIcons.exclamation_circle,
                  onPress: () {},
                ),
                const Divider(),
                const SizedBox(height: 10),
                ProfileMenuWidget(
                  title: "Se déconnecter",
                  icon: LineAwesomeIcons.alternate_sign_out,
                  textColor: Colors.red,
                  endIcon: false,
                  onPress: () {
                    _handleLogout();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogout() {
    AuthRepository.instance.logout().then((_) {
      Get.offAll(() => SplachScreen());
      _showSnackbar('Succès', 'Déconnexion réussie.');
    }).catchError((error) {
      _showSnackbar('Erreur', 'Erreur de déconnexion: $error');
    });
  }

  void _showSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black54,
      colorText: Colors.white,
    );
  }
}
