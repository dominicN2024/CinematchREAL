// ignore_for_file: avoid_print, file_names, library_private_types_in_public_api, deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const GroupPage());


class GroupPage extends StatefulWidget {
  const GroupPage({Key? key}) : super(key: key);

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  String selectedGroup = 'Group 1'; // Track the selected value
  Set<String> groupNames = {'Group 1', 'Group 2'};

void post() async {
  // Replace the URL with the actual URL where your PHP script is hosted
final response = await http.get(Uri.parse('http://localhost/cinematch/lib/connection.php'));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);

    // Process the data as needed
    for (var user in data) {
      // Replace 'column_name' with the actual column name you want to access
      print(user['username']);
    }
  } else {
    print('Failed to load data: ${response.statusCode}');
  }
}


  @override
  Widget build(BuildContext context) {
    const TextStyle buttonTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
    );

    return MaterialApp(
      home: Scaffold(
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
                  padding: const EdgeInsets.only(left: 80, top: 80, right: 80),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/logoheader.svg',
                      semanticsLabel: 'My SVG Image',
                      height: 80,
                      fit: BoxFit.fitWidth,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.only(left: 28),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: () {
                        // Add your button logic here
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: const Color.fromRGBO(4, 0, 59, 1), // Text color
                        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                        side: const BorderSide(color: Color.fromRGBO(90, 0, 90, 1)), // Border color
                        shadowColor: const Color.fromRGBO(255, 255, 255, .2), // Shadow color
                        elevation: 4, // Elevation (shadow depth)
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100), // Adjust the border radius
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                        value: selectedGroup, // Default selected value
                        onChanged: (String? value) {
                          setState(() {
                            selectedGroup = value!;
                            print('Selected Group: $selectedGroup');
                          });
                        },
                        dropdownColor: const Color.fromRGBO(4, 0, 59, 1),
                        borderRadius: BorderRadius.circular(20),
                        items: groupNames.map((String option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(
                              option,
                              style: buttonTextStyle,
                            ),
                            
                          );
                        }).toList(),
                      ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.only(left: 28),
                  child: const Text(
                    'Here are your matches!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.only(left: 28),
                  child: const Text(
                    'Adjust Preferences',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 20),
                      child: SizedBox(
                        width: 231,
                        height: 294,
                        child: Image.asset('/Applications/XAMPP/xamppfiles/htdocs/cinematch/assets/imagenotfound.png'),
                      ),
                    ),
                    const SizedBox(width: 8), // Add some spacing between image and text
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 20),
                          alignment: Alignment.topCenter,
                          child: const Text(
                            'Movie Title',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Palatino',
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 44, top: 20),
                          child: const Text(
                            'Rating',
                            style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, .8),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 44, top: 20),
                          child: const Text(
                            'Length',
                            style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, .8),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 44, top: 60),
                          child: const Text(
                            'Services',
                            style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, .8),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.only(left: 28, right: 28),
                child: const MySeparator(),
                ),
                const SizedBox(height: 25),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 20),
                      child: SizedBox(
                        width: 231,
                        height: 294,
                        child: Image.asset('/Applications/XAMPP/xamppfiles/htdocs/cinematch/assets/imagenotfound.png'),
                      ),
                    ),
                    const SizedBox(width: 8), // Add some spacing between image and text
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 20),
                          alignment: Alignment.topCenter,
                          child: const Text(
                            'Movie Title',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Palatino',
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 44, top: 20),
                          child: const Text(
                            'Rating',
                            style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, .8),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 44, top: 20),
                          child: const Text(
                            'Length',
                            style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, .8),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 44, top: 60),
                          child: const Text(
                            'Services',
                            style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, .8),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 60),
                        ElevatedButton(
                          onPressed:() => {
                            post(),
                          },
                          child: const Text(
                            'Button',
                          ), 
                        ),
                      ],
                    )
                  ],
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
          ),
        ),
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 200, // Set a width constraint for the parent container
      child: MySeparator(),
    );
  }
}

class MySeparator extends StatelessWidget {
  const MySeparator({Key? key, this.height = 1, this.color = Colors.black})
      : super(key: key);

  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 10.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: const DecoratedBox(
                decoration: BoxDecoration(color: Colors.white),
              ),
            );
          }),
        );
      },
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