import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sotulub/firebase_options.dart';
import 'package:sotulub/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:sotulub/src/repository/DemandeColect_repos.dart';
import 'package:sotulub/src/repository/DemandeCuve_repos.dart';
import 'package:sotulub/src/repository/auth_repository/auth_repos.dart';
import 'package:sotulub/src/repository/detenteur_repos.dart';
import 'package:sotulub/src/utils/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  Get.put(AuthRepository());
  Get.put(DemandeColectRepository()); 
  Get.put(DemandeCuveRepo());
  Get.put(DetenteurRepository()); 

  runApp( App());
}
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.leftToRightWithFade,
      transitionDuration: const Duration(milliseconds: 500),
      home:   const WelcomeScreen(),
    );
  }
  
}
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Delegations"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await addDelegations();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data added to Firestore')));
          },
          child: Text("Add Data"),
        ),
      ),
    );
  }
}




Future<void> addDelegations() async {
   CollectionReference sousSecteurs = FirebaseFirestore.instance.collection('Sous-Secteur');

  List<Map<String, String>> sousSecteurData = [
    {"code_secteur": "A", "code_ss_secteur": "S/L", "designation": "STATION DE LAVAGE"},
    {"code_secteur": "A", "code_ss_secteur": "S/S", "designation": "STATION DE SERVICE"},
    {"code_secteur": "B", "code_ss_secteur": "TC1", "designation": "Transport cheminot"},
    {"code_secteur": "B", "code_ss_secteur": "TC2", "designation": "Transport en commun"},
    {"code_secteur": "B", "code_ss_secteur": "TC3", "designation": "Transport privé"},
    {"code_secteur": "B", "code_ss_secteur": "TC4", "designation": "Transport tourisme"},
    {"code_secteur": "B", "code_ss_secteur": "TC5", "designation": "Transport régional"},
    {"code_secteur": "B", "code_ss_secteur": "TC6", "designation": "Transport aérien"},
    {"code_secteur": "B", "code_ss_secteur": "TC7", "designation": "Transport maritime"},
    {"code_secteur": "C", "code_ss_secteur": "C1", "designation": "Electricité"},
    {"code_secteur": "C", "code_ss_secteur": "C10", "designation": "Tannerie & Chaussures"},
    {"code_secteur": "C", "code_ss_secteur": "C11", "designation": "Industries Electroniques"},
    {"code_secteur": "C", "code_ss_secteur": "C12", "designation": "Electro-ménagers"},
    {"code_secteur": "C", "code_ss_secteur": "C13", "designation": "Industrie Alimentaires"},
    {"code_secteur": "C", "code_ss_secteur": "C14", "designation": "Industrie Pharmaceutiques"},
    {"code_secteur": "C", "code_ss_secteur": "C15", "designation": "Industrie Emballages"},
    {"code_secteur": "C", "code_ss_secteur": "C16", "designation": "Industrie Peinture"},
    {"code_secteur": "C", "code_ss_secteur": "C17", "designation": "Industrie Céramique"},
    {"code_secteur": "C", "code_ss_secteur": "C18", "designation": "Industrie Batiment"},
    {"code_secteur": "C", "code_ss_secteur": "C19", "designation": "Industrie Communication"},
    {"code_secteur": "C", "code_ss_secteur": "C2", "designation": "Industrie Agriculture"},
    {"code_secteur": "C", "code_ss_secteur": "C20", "designation": "Industrie Papiers"},
    {"code_secteur": "C", "code_ss_secteur": "C21", "designation": "Industrie Chimique"},
    {"code_secteur": "C", "code_ss_secteur": "C22", "designation": "Industrie Lubrifiants"},
    {"code_secteur": "C", "code_ss_secteur": "C23", "designation": "Industrie de recherche et d'ex"},
    {"code_secteur": "C", "code_ss_secteur": "C24", "designation": "Industrie Bois & dérivés"},
    {"code_secteur": "C", "code_ss_secteur": "C25", "designation": "Industries & services divers"},
    {"code_secteur": "C", "code_ss_secteur": "C26", "designation": "Location grues & engins"},
    {"code_secteur": "C", "code_ss_secteur": "C27", "designation": "Sidérurgie"},
    {"code_secteur": "C", "code_ss_secteur": "C28", "designation": "Confection"},
    {"code_secteur": "C", "code_ss_secteur": "C3", "designation": "Cimenteries, chaux"},
    {"code_secteur": "C", "code_ss_secteur": "C4", "designation": "Industrie Maritime"},
    {"code_secteur": "C", "code_ss_secteur": "C5", "designation": "Sonede"},
    {"code_secteur": "C", "code_ss_secteur": "C6", "designation": "Industries Textiles"},
    {"code_secteur": "C", "code_ss_secteur": "C7", "designation": "Industries Métal. & mécan"},
    {"code_secteur": "C", "code_ss_secteur": "C8", "designation": "Industries Caoutch. Plastiques"},
    {"code_secteur": "C", "code_ss_secteur": "C9", "designation": "Industries Electriques & Gaz"},
    {"code_secteur": "D", "code_ss_secteur": "D1", "designation": "Phosphates"},
    {"code_secteur": "D", "code_ss_secteur": "D2", "designation": "Fer"},
    {"code_secteur": "DI", "code_ss_secteur": "DI", "designation": "DIAGNONSTIC AUTO"},
    {"code_secteur": "E", "code_ss_secteur": "E1", "designation": "Ports de pêche"},
    {"code_secteur": "E", "code_ss_secteur": "E2", "designation": "Garde et sûreté maritime"},
    {"code_secteur": "E", "code_ss_secteur": "E3", "designation": "Agences maritimes"},
    {"code_secteur": "E", "code_ss_secteur": "E4", "designation": "Bateaux de passage"},
    {"code_secteur": "E", "code_ss_secteur": "E5", "designation": "Compagnies de navigation"},
    {"code_secteur": "E", "code_ss_secteur": "E6", "designation": "Ports de plaisance"},
    {"code_secteur": "E", "code_ss_secteur": "E7", "designation": "Offices"},
    {"code_secteur": "F", "code_ss_secteur": "F1", "designation": "Fermes pilotes, fermes privées"},
    {"code_secteur": "F", "code_ss_secteur": "F10", "designation": "Coopératives & UCP"},
    {"code_secteur": "F", "code_ss_secteur": "F11", "designation": "Parc Ministère Agriculture"},
    {"code_secteur": "F", "code_ss_secteur": "F12", "designation": "Ventes Mat.Agricole"},
    {"code_secteur": "F", "code_ss_secteur": "F13", "designation": "Institut agricole"},
    {"code_secteur": "F", "code_ss_secteur": "F2", "designation": "CRDA, forêts"},
    {"code_secteur": "F", "code_ss_secteur": "F3", "designation": "SMVDA"},
    {"code_secteur": "F", "code_ss_secteur": "F4", "designation": "Régies des sondages"},
    {"code_secteur": "F", "code_ss_secteur": "F5", "designation": "Offices agricoles"},
    {"code_secteur": "F", "code_ss_secteur": "F6", "designation": "Centres formati & serv agricol"},
    {"code_secteur": "F", "code_ss_secteur": "F7", "designation": "Huileries"},
    {"code_secteur": "F", "code_ss_secteur": "F8", "designation": "Centre de production laitière"},
    {"code_secteur": "F", "code_ss_secteur": "F9", "designation": "Usine de conserves & glaces"},
    {"code_secteur": "G", "code_ss_secteur": "G1", "designation": "Mécanique générale"},
    {"code_secteur": "G", "code_ss_secteur": "G2", "designation": "Dépôt férailles"},
    {"code_secteur": "H", "code_ss_secteur": "H1", "designation": "Chantier Wx publ Ponts & Chaus"},
    {"code_secteur": "H", "code_ss_secteur": "H2", "designation": "Carrières"},
    {"code_secteur": "H", "code_ss_secteur": "H3", "designation": "Phosphates"},
    {"code_secteur": "H", "code_ss_secteur": "H4", "designation": "Centre recherche & forage"},
    {"code_secteur": "H", "code_ss_secteur": "H5", "designation": "Barrages & lacs collinaires"},
    {"code_secteur": "H", "code_ss_secteur": "H6", "designation": "Matériaux de construction"},
    {"code_secteur": "I", "code_ss_secteur": "I1", "designation": "Agences de voyage"},
    {"code_secteur": "I", "code_ss_secteur": "I2", "designation": "Location voitures"},
    {"code_secteur": "I", "code_ss_secteur": "I3", "designation": "Tourisme, Hotellerie"},
    {"code_secteur": "I", "code_ss_secteur": "I4", "designation": "Office de tourisme"},
    {"code_secteur": "J", "code_ss_secteur": "J1", "designation": "Hopitaux"},
    {"code_secteur": "J", "code_ss_secteur": "J10", "designation": "Casernes & Armée"},
    {"code_secteur": "J", "code_ss_secteur": "J11", "designation": "Parc Agriculture"},
    {"code_secteur": "J", "code_ss_secteur": "J12", "designation": "Prisons civiles"},
    {"code_secteur": "J", "code_ss_secteur": "J13", "designation": "Parcs privées"},
    {"code_secteur": "J", "code_ss_secteur": "J14", "designation": "Colonies de vacances"},
    {"code_secteur": "J", "code_ss_secteur": "J15", "designation": "Offices"},
    {"code_secteur": "J", "code_ss_secteur": "J16", "designation": "Parcs des Ambassades"},
    {"code_secteur": "J", "code_ss_secteur": "J17", "designation": "Maisons de presse, éditions"},
    {"code_secteur": "J", "code_ss_secteur": "J18", "designation": "Protection civile"},
    {"code_secteur": "J", "code_ss_secteur": "J19", "designation": "Parc ministère de l'intérieur"},
    {"code_secteur": "J", "code_ss_secteur": "J2", "designation": "Parc Municipalités"},
    {"code_secteur": "J", "code_ss_secteur": "J3", "designation": "Banques & PTT"},
    {"code_secteur": "J", "code_ss_secteur": "J4", "designation": "Centres de formation"},
    {"code_secteur": "J", "code_ss_secteur": "J5", "designation": "Parc Gouvernorats"},
    {"code_secteur": "J", "code_ss_secteur": "J6", "designation": "Parc Equipement"},
    {"code_secteur": "J", "code_ss_secteur": "J7", "designation": "Aéroports, Douane & Sûreté"},
    {"code_secteur": "J", "code_ss_secteur": "J8", "designation": "Enseignement"},
    {"code_secteur": "J", "code_ss_secteur": "J9", "designation": "Adm publiques"},
    {"code_secteur": "K", "code_ss_secteur": "K1", "designation": "Dépôt matériaux de constructio"},
    {"code_secteur": "K", "code_ss_secteur": "K2", "designation": "Concessionnaire de voitures"},
    {"code_secteur": "K", "code_ss_secteur": "K3", "designation": "Location ou diagnostic auto"},
    {"code_secteur": "K", "code_ss_secteur": "K4", "designation": "Station autos"},
    {"code_secteur": "K", "code_ss_secteur": "K5", "designation": "Motobicane"},
    {"code_secteur": "K", "code_ss_secteur": "K6", "designation": "Location d'engins"},
    {"code_secteur": "N", "code_ss_secteur": "N1", "designation": "Assainissements, curage.."},
    {"code_secteur": "N", "code_ss_secteur": "N2", "designation": "Dépôts déchets"},
    {"code_secteur": "N", "code_ss_secteur": "N3", "designation": "Détenteurs illicites"}
  ];
  for (var SousSecteur in sousSecteurData ) {
    await sousSecteurs.add({
      'Code Secteur': SousSecteur['code_secteur'],
      'Code SSecteur': SousSecteur['code_ss_secteur'],
      'Désignations': SousSecteur['designation'],
    });
  }
}
