import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sotulub/src/common_widgets/custom_dropdown.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/constants/text_strings.dart';
import 'package:sotulub/src/features/core/controllers/admin_controller.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/add_gov_page.dart';
import 'package:sotulub/src/features/core/screens/dashboard_Admin/users_page.dart';
import 'package:sotulub/src/repository/auth_repository/dropdowns_repo.dart';

class GovPage extends StatefulWidget {
  const GovPage({super.key});

  @override
  State<GovPage> createState() => _GovPageState();
}

class _GovPageState extends State<GovPage> {
  List<QueryDocumentSnapshot> data = [];

  getData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("Gouvernorat").get();

    setState(() {
      data.addAll(querySnapshot.docs);
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  final DropdownFetch dropdownController = Get.put(DropdownFetch());
  final AdminController controller = Get.put((AdminController()));

  Future openDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Add new gouvernorat"),
          content: SafeArea(
            child: Column(
              children: [
                Obx(() {
                  return CustomDropdown(
                      labelText: 'Zone',
                      prefixIcon: Icons.map_outlined,
                      items: dropdownController.zoneItems.map((zone) {
                        return DropdownMenuItem(
                          value: zone,
                          child: Text(zone),
                        );
                      }).toList(),
                      value: null,
                      onChanged: (newValue) {
                        controller.zone.value = newValue ?? "";
                      });
                }),
                TextField(
                    autofocus: true,
                    decoration:
                        InputDecoration(hintText: "Enter gouvernorat name")),
                TextField(
                    autofocus: true,
                    decoration:
                        InputDecoration(hintText: "Enter gouvernorat code")),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          // leading: const Icon(Icons.menu, color: tPrimaryColor),
          title: Text("Liste gouvernorat".toUpperCase(),
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              icon: Icon(Icons.add, color: tPrimaryColor),
              onPressed: () {
                Get.to(AddGovPage());
              },
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, i) {
            return Container(
              decoration: BoxDecoration(
                color: tLightBackground,
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Gouvernorat:" "${data[i]['Désignation']}"),
                      Text("Code gouvernorat:"
                          "${data[i]['Code Gouvernorat']}"),
                    ],
                  ),
                  Text("Code zone:" "${data[i]['code zone']}")
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
