// ignore_for_file: unused_import, file_names, incorrect_use_of_parent_data, deprecated_member_use, duplicate_ignore, library_private_types_in_public_api, empty_statements, avoid_print, annotate_overrides

import 'dart:async';

import 'package:cinematch/NoSwipeBackPageRoute.dart';
import 'package:flutter/material.dart';
import 'package:cinematch/SelectServicesPage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cinematch/globals.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(
    const MaterialApp(
      home: CreateAccountPage(),
    ),
  );
}


class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  Timer? _debounce;

  void initState() {
      super.initState();
      print("loaded");
  }

    @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold( 
          body: SingleChildScrollView(
            child: Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 80.0, left: 80, right: 80, bottom: 20),
                  child: SvgPicture.asset(
                    'assets/logoheader.svg',
                    semanticsLabel: 'My SVG Image',
                    height: 80,
                    fit: BoxFit.fitWidth,
                    // ignore: deprecated_member_use
                    color: Colors.white,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 10),
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                buildLabeledInput('Name', (text) => onNameChanged(text), false, false),
                buildLabeledInput('Username', (text) => onUsernameChanged(text), false, true),
                buildLabeledInput('Password', (text) => onPasswordChanged(text), true, false),
                buildLabeledInput('Repeat Password', (text) => onRepeatPasswordChanged(text), true, false),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 60, left: 30, right: 30, bottom: 20),
                    child: GestureDetector(
                      onTap: () {
                        if (wrongPassword == true || usernameExist == true || name.isEmpty == true || username.isEmpty == true || password.isEmpty) {
                          // not good
                        } else {
                          Navigator.of(context).push(NoSwipeBackPageRoute(page: const SelectServicesPage()));
                        };
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                        Transform.translate(
                          offset: const Offset(147, 4.9), // Adjust x and y values for the desired position
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
                            padding: const EdgeInsets.only(bottom: 4),
                            child: RichText(
                              text: const TextSpan(
                                text: 'Select Your Streaming Services',
                                style: TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.underline,
                                  fontSize: 20,
                                  fontFamily: 'Palatino',
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: '\u00A0\u00A0\u00A0\u00A0',
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
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 181),
                    child: Container(
                      height: 100, // Adjust the height as needed
                      color: const Color.fromRGBO(6, 0, 60, 1), // Adjust the color as needed
                      child: const NavBar(), // Your custom bottom navigation bar widget
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onNameChanged(String text) {
    name = text;
  }
  
  void onUsernameChanged(String text) async {
    username = text;
      // Gets User Id
      String sql = "SELECT user_id FROM user WHERE username = '$username'";
      String userID = "";
      try {
        List<Map<String, dynamic>>? records = await getUserID(sql);
        if (records.isNotEmpty) {
          var record = records.first;
          if (record.containsKey("user_id") && record["user_id"] != null) {
            userID = record["user_id"].toString();
          }
        }
      } catch (e) {
        print('Error: $e');
      }

    Future.delayed(const Duration(milliseconds: 1500), () async { 
      if (userID != "") {
        setState(() {
          usernameExist = true;
        });
      } else {
        setState(() {
          usernameExist = false;
        });
      }
    });
  }

  void onPasswordChanged(String text) {
    password = text;
  }

  void onRepeatPasswordChanged(String text) {
  if (_debounce?.isActive ?? false) {
    _debounce!.cancel(); // Cancel the existing timer if it's still running
  }

  _debounce = Timer(const Duration(milliseconds: 750), () {
    if (text == "") {
      setState(() {
        wrongPassword = false;
      });
    } else if (password != text) {
      setState(() {
        wrongPassword = true;
      });
    } else {
      print("password good");
      print(password);
      print(text);
      setState(() {
        wrongPassword = false;
      });
    }
  });
}


  Widget buildLabeledInput(String labelText, Function(String) onTextChanged, bool isPassword, bool isUsername) {
    return Container(
      padding: const EdgeInsets.only(left: 28, top: 28),
      child: Row(
        children: [
          Text(
            labelText,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontFamily: 'Palatino',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 16), // Add spacing between label and text input
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 28), // Add right padding
              child: TextFormField(
                obscureText: isPassword,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white, // Set the text input color
                ),
                onChanged: onTextChanged,
                decoration: InputDecoration(
                  filled: true,
                  // fillColor: (wrongPassword && isPassword || usernameExist && isUsername) ? Colors.red : Colors.transparent,
                  fillColor: Colors.transparent,
                  hintText: labelText,
                  hintStyle: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    // color: (wrongPassword && isPassword || usernameExist && isUsername) ? Colors.white : Colors.grey, // Set the hint text color
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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