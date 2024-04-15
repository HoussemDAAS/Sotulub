import 'dart:async';


import 'package:flutter/material.dart';

import 'package:sotulub/src/common_widgets/slider/promoSlider.dart';

import 'package:sotulub/src/constants/colors.dart';

import 'package:sotulub/src/constants/sizes.dart';
import 'package:sotulub/src/constants/text_strings.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();

  updatePageIndicator(int index) {}
}

class _DashboardState extends State<Dashboard> {
  bool _showToast = false;

  @override
  void initState() {
    super.initState();
    // Show the toast when the page is opened
    _showToast = true;

    // Schedule the appearance of the toast after 20 seconds if it's closed
    Timer(Duration(seconds: 20), () {
      if (!_showToast) {
        setState(() {
          _showToast = true;
        });
      }
    });
  }

  void _hideToast() {
    setState(() {
      _showToast = false;
    });

    // Schedule the appearance of the toast after 20 seconds
    Timer(Duration(seconds: 20), () {
      setState(() {
        _showToast = true;
      });
    });
  }

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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(
                top: tDashboardPadding * 1.5, // Adjust this factor as needed
                left: 10,
                right: 10,
                bottom: tDashboardPadding,
              ),
              child: TpromoSlider(),
            ),
          ),
          if (_showToast)
            Positioned(
              top: 10,
              left: 0,
              right: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Color(0xFFA6E9D2), // Custom background color
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Demande de convention est en cours",
                      style: TextStyle(color: Colors.white),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: _hideToast,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

