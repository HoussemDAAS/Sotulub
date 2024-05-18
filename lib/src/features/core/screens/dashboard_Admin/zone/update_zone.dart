import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sotulub/src/common_widgets/custom_Text_filed.dart';
import 'package:sotulub/src/common_widgets/custom_dropdown.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/repository/admin_repos.dart';

class UpdateZonePage extends StatefulWidget {
  final String selectedZone;

  const UpdateZonePage({
    Key? key,
    required this.selectedZone,
  }) : super(key: key);

  @override
  _UpdateZonePageState createState() => _UpdateZonePageState();
}

class _UpdateZonePageState extends State<UpdateZonePage> {
  final AdminRepository adminRepository = Get.put(AdminRepository());
  TextEditingController? zoneController;
  List<String> gouvernorats = [];

  @override
  void initState() {
    super.initState();
    zoneController = TextEditingController(text: widget.selectedZone);
    fetchGouvernorats();
  }

  List<String> selectedGouvernorats = [];

  void toggleGouvernoratSelection(String gouvernorat) {
    setState(() {
      if (selectedGouvernorats.contains(gouvernorat)) {
        selectedGouvernorats.remove(gouvernorat);
      } else {
        selectedGouvernorats.add(gouvernorat);
      }
    });
  }

  @override
  void dispose() {
    zoneController?.dispose();
    super.dispose();
  }

  Future<void> fetchGouvernorats() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("Gouvernorat").get();

    List<String> gouvernorats =
        querySnapshot.docs.map((doc) => doc['Désignation'] as String).toList();

    List<String> associatedGouvernorats =
        await adminRepository.getAssociatedGouvernorats(widget.selectedZone);
    setState(() {
      this.gouvernorats = gouvernorats;
      this.selectedGouvernorats = associatedGouvernorats;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Zone'.toUpperCase(),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              labelText: 'Zone',
              hintText: 'Modifier la zone',
              prefixIcon: Icons.map_outlined,
              controller: zoneController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'S' 'il vous plaît entrer une zone';
                }
                return null;
              },
            ),
            SizedBox(height: tFormHeight),
            Expanded(
              child: ListView.builder(
                itemCount: gouvernorats.length,
                itemBuilder: (context, index) {
                  String gouvernorat = gouvernorats[index];
                  bool isSelected = selectedGouvernorats.contains(gouvernorat);

                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: isSelected
                          ? tPrimaryColor.withOpacity(0.1)
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected ? tPrimaryColor : Colors.grey,
                        width: 1,
                      ),
                    ),
                    child: CheckboxListTile(
                      checkColor: tWhiteColor,
                      activeColor: tPrimaryColor,
                      title: Text(
                        gouvernorat,
                        style: TextStyle(
                          color: isSelected ? tPrimaryColor : Colors.black,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      value: isSelected,
                      onChanged: (value) {
                        toggleGouvernoratSelection(gouvernorat);
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: tFormHeight),
            ElevatedButton(
              onPressed: () async {
                if (zoneController!.text.isNotEmpty) {
                  // Update the zone
                  await adminRepository.updateZone(
                    widget.selectedZone,
                    zoneController!.text,
                    selectedGouvernorats,
                  );
                  Get.snackbar(
                    'Succès',
                    'La zone a été mise à jour avec succès',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                } else {
                  Get.snackbar(
                    'Erreur',
                    'Veuillez remplir tous les champs',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
              child: Text('Mettre à jour'.toUpperCase()),
            ),
          ],
        ),
      ),
    );
  }
}
