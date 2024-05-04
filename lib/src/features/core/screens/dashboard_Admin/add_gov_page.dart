import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sotulub/main.dart';
import 'package:sotulub/src/common_widgets/custom_Text_filed.dart';
import 'package:sotulub/src/common_widgets/custom_dropdown.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/constants/text_strings.dart';
import 'package:sotulub/src/features/core/controllers/admin_controller.dart';
import 'package:sotulub/src/repository/auth_repository/dropdowns_repo.dart';

class AddGovPage extends StatefulWidget {
  const AddGovPage({super.key});

  @override
  State<AddGovPage> createState() => _AddGovPageState();
}

class _AddGovPageState extends State<AddGovPage> {
  final DropdownFetch dropdownController = Get.put(DropdownFetch());
  final AdminController controller = Get.put((AdminController()));
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add new gouvernorat".toUpperCase(),
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(
              tDefaultSize, 70, tDefaultSize, tDefaultSize),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
              const SizedBox(height: tFormHeight - 10.0),
              CustomTextField(
                labelText: 'Designation',
                hintText: '',
                prefixIcon: Icons.map_outlined,
                // controller: controller.responsable,
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
                labelText: 'Code',
                hintText: '',
                prefixIcon: Icons.numbers,
                // controller: controller.responsable,
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(tSubmit.toUpperCase()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
