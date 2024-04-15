import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sotulub/src/constants/colors.dart';
import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/constants/text_strings.dart';
import 'package:sotulub/src/features/authentication/screens/charts/line_charts.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu, color: tPrimaryColor),
        title: Text(
          tWelcomeTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20, top: 7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.person, color: tPrimaryColor),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDashboardPadding),
          child: Column(
            children: [
              LineChartSample(), // Displaying the LineChartSample widget here
            ],
          ),
        ),
      ),
    );
  }
}
