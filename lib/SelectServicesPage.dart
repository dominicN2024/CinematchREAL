// ignore_for_file: file_names, avoid_print, prefer_interpolation_to_compose_strings, deprecated_member_use, duplicate_import, avoid_unnecessary_containers

import 'package:cinematch/CreateAccountPage.dart';
import 'package:cinematch/CreateGroupPage.dart';
import 'package:cinematch/NoSwipeBackPageRoute.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cinematch/globals.dart';

class SelectServicesPage extends StatelessWidget {
  const SelectServicesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: MyWidget(),
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  List<String> groupMembers = [];
  String newMember = '';

  @override
  Widget build(BuildContext context) {
    double containerWidth = MediaQuery.of(context).size.width * 0.6;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(4, 0, 59, 1),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromRGBO(4, 0, 59, 1),
                  Color.fromRGBO(90, 0, 90, 1),
                ],
              ),
            ),
          ),
          // Container around the SVG Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              width: containerWidth,
              padding: const EdgeInsets.all(80.0),
              child: SvgPicture.asset(
                'assets/logoheader.svg',  
                semanticsLabel: 'My SVG Image',
                width: containerWidth,
                height: 80,
                fit: BoxFit.fitWidth,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.only(left: 28, right: 28, bottom: 270),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Create Account',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Select Streaming Services:',
                    style: TextStyle(
                      fontFamily: 'Palatino',
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Rows of buttons with space in between
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildButton('Netflix', 18),
                      const SizedBox(width: 15),
                      buildButton('Hulu', 18),
                      const SizedBox(width: 15),
                      buildButton('Disney +', 15),
                      const SizedBox(width: 15),
                      buildButton('Amazon', 16),
                    ],
                  ),
                  const SizedBox(height: 11),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildButton('Max', 18),
                      const SizedBox(width: 15),
                      buildButton('Crunchyroll', 11),
                      const SizedBox(width: 15),
                      buildButton('Stars', 18),
                      const SizedBox(width: 15),
                      buildButton('Peacock', 15.5),
                    ],
                  ),
                  const SizedBox(height: 11),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildButton('Fubo', 18),
                      const SizedBox(width: 15),
                      buildButton('Apple TV', 15),
                      const SizedBox(width: 15),
                      buildButton('Discovery', 13),
                      const SizedBox(width: 15),
                      buildButton('Starz', 18),
                    ],
                  ),
                  const SizedBox(height: 60),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(bottom: 8.8),
                    child: GestureDetector(
                      onTap: () {
                        if (services.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SelectServicesPage(),
                            ),
                          );
                        }
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Transform.translate(
                      offset: const Offset(103, 4.9), // Adjust x and y values for the desired position
                      child: Transform.rotate(
                        angle: 45 * 3.14159265359 / 26,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.white,
                                width: 1.5,
                              ),
                              right: BorderSide(
                                color: Colors.white,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                          Container(
                            padding: const EdgeInsets.only(bottom: 8.8),
                            child: GestureDetector(
                            onTap: () {
                              if (services.isEmpty == true) {
                              } else {
                                Navigator.of(context).push(NoSwipeBackPageRoute(page: const CreateGroupPage()));
                              }
                            },
                              child: RichText(
                                text: const TextSpan(
                                  text: 'Create Groups',
                                  style: TextStyle(
                                    color: Colors.white,
                                    decoration: TextDecoration.underline,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w900,
                                    fontSize: 20,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.white,
                                        decorationThickness: 1.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.only(top: 80),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(NoSwipeBackPageRoute(page: const CreateAccountPage()));
                        },
                        child: const Text(
                          'Back',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 100, // Adjust the height as needed
              color: const Color.fromRGBO(6, 0, 60, 1), // Adjust the color as needed
              child: const NavBar(), // Your custom bottom navigation bar widget
            ),
          ),
        ],
      ),
    );
  }

 Widget buildButton(String text, double fontSize) {
  return Container(
    child: Expanded(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            if (services.contains(text)) {
              services.remove(text);
            } else {
              services.add(text);
            }
          });
        },
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.all(8), // Adjust padding as needed
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
            services.contains(text)
                ? const Color.fromRGBO(90, 0, 90, 1)
                : const Color.fromRGBO(4, 0, 59, 1),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              side: const BorderSide(
                color: Color.fromRGBO(90, 0, 90, 1),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          elevation: MaterialStateProperty.all<double>(4.5),
          shadowColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(255, 255, 255, .2)),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: fontSize, // Use the provided font size parameter
          ),
        ),
      ),
    ),
  );
}

// ignore: unused_element
void _showAddMemberDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
        title: const Text(
          'Custom Popup',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromRGBO(4, 0, 59, 1),
        content: const SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'This is a custom popup content.',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              // Add more content as needed
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Close',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          // Add more actions as needed
        ],
      );
    },
  );
}


  void addToList(List<String> selectedServices) {
  }
}

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          // padding: EdgeInsets.only(bottom: 20),
          height: 100,
          color: const Color.fromRGBO(6, 0, 60, 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset(
                'assets/home.svg',
                height: 48, // Adjust the height as needed
                color: Colors.white,
              ),
              SvgPicture.asset(
                'assets/profile.svg',
                height: 48, // Adjust the height as needed
                color: Colors.white,
              ),
              // Add more SVG assets as needed
              SvgPicture.asset(
                'assets/group.svg',
                height: 48, // Adjust the height as needed
                color: Colors.white,
              ),
            ],
          ),
        ),
    );
  }
}