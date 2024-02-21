// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, avoid_print, file_names, unused_import, prefer_interpolation_to_compose_strings, avoid_unnecessary_containers, no_leading_underscores_for_local_identifiers, unused_local_variable, prefer_final_fields, unused_field, unnecessary_null_comparison

import 'dart:collection';
import 'package:cinematch/GroupsListPage.dart';
import 'package:cinematch/NoSwipeBackPageRoute.dart';
import 'package:cinematch/queryCommand.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cinematch/SelectServicesPage.dart';
import 'package:cinematch/HomePage.dart';
import 'package:cinematch/globals.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
Set<String>? selectedCustomButtons;
Set<String>? selectedRatingButtons;

void main() {
  runApp(
    const MaterialApp(
      home: EditMemberPage(),
    ),
  );  
}

class EditMemberPage extends StatefulWidget {
  const EditMemberPage({Key? key}) : super(key: key);

  @override
  _EditMemberPageState createState() => _EditMemberPageState();
}

class _EditMemberPageState extends State<EditMemberPage> {
  TextEditingController movieController = TextEditingController();
  TextEditingController actorController = TextEditingController();
  Query query = Query();
  String actorsTextFieldValue = "";
  String moviesTextFieldValue = "";
  late Future<void> _loadMemberData;

  @override
  void initState() {
    super.initState();
    _loadMemberData = loadMemberData();
  }

  Future<List<Map<String, dynamic>>> getMemberData(String sqlCommand) async {
  var url = 'https://dominicn2024.smtchs.org/cinematch/getMemberData.php';
  var response = await http.post(
    Uri.parse(url),
    body: {'sql': sqlCommand},
  );

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['success']) {
      List<dynamic> data = jsonResponse['data'];
      List<Map<String, dynamic>> records = [];

      for (var record in data) {
        // Assuming each record is a Map
        Map<String, dynamic> recordMap = {};
        record.forEach((key, value) {
          recordMap[key] = value;
        });
        records.add(recordMap);
      }
      return records;
    } else {
      throw Exception('Error fetching data: ${jsonResponse['message']}');
    }
  } else {
    throw Exception('Server error: ${response.statusCode}');
  }
}



  Future<void> loadMemberData() async {
    selectedRatingButtons?.clear();
    selectedRatingButtons?.clear();
    moviesTextFieldValue = "";
    actorsTextFieldValue = "";

    // username = "guyrealNOw";
    String sql = "SELECT * FROM members WHERE name = '$memberNameToEditPage'";
    print(sql);
    var data = await getMemberData(sql);
    selectedCustomButtons = data[0]['preferences'].split(',').map((genre) => genre.trim()).toSet().cast<String>();
    selectedRatingButtons = data[0]['mpaaratings'].split(',').map((genre) => genre.trim()).toSet().cast<String>();

    movieController.text = data[0]['movie_preference'];
    actorsTextFieldValue = data[0]['movie_preference'];

    actorController.text = data[0]['actor_preference'];
    moviesTextFieldValue = data[0]['actor_preference'];

    print(selectedCustomButtons);
    print(selectedRatingButtons);
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _loadMemberData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Loading state
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Error state
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Data is loaded
          return builderContent(context);
        },
      ),
    );
  }
  Widget buildCustomButton(String text, double fontSize, bool isRatingButton) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          if (isRatingButton) {
            if (selectedRatingButtons?.contains(text) ?? false) {
              selectedRatingButtons?.remove(text);
          } else {
              selectedRatingButtons?.add(text);
            }
          } else {
            if (selectedCustomButtons?.contains(text) ?? false) {
              selectedCustomButtons?.remove(text);
            } else {
              selectedCustomButtons?.add(text);
            }
          }
        });
      },
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.all(8),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          ((selectedCustomButtons?.contains(text) ?? false) || (selectedRatingButtons?.contains(text) ?? false))
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
        shadowColor: MaterialStateProperty.all<Color>(
          const Color.fromRGBO(255, 255, 255, .2),
        ),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
        ),
      ),
    );
  }

  
  void runsqlcommands() async {
    String genres = "";
    for (int i = 0; i < selectedCustomButtons!.length; i++) {
      genres += selectedCustomButtons!.elementAt(i);
      if (i < selectedCustomButtons!.length - 1) {
        genres += ", ";
      }
    }

    String ratings = "";
    for (int i = 0; i < selectedRatingButtons!.length; i++) {
      ratings += selectedRatingButtons!.elementAt(i);
      if (i < selectedRatingButtons!.length - 1) {
        ratings += ", ";
      }
    }

    String sql = "UPDATE `members` SET `preferences`='$genres',`mpaaratings`='$ratings',`movie_preference`='$moviesTextFieldValue',`actor_preference`='$actorsTextFieldValue' WHERE name = '$memberNameToEditPage'";
    await query.executeSql(sql);
    selectedCustomButtons?.clear();
    selectedRatingButtons?.clear();
  }
  
  Widget builderContent(BuildContext context) {
    return Stack(
        children: [
          SingleChildScrollView(
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
                    padding: const EdgeInsets.only(
                        top: 80.0, left: 80, right: 80, bottom: 25),
                    child: SvgPicture.asset(
                      'assets/logoheader.svg',
                      semanticsLabel: 'My SVG Image',
                      height: 80,
                      fit: BoxFit.fitWidth,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(0),
                    child: Text(
                      memberNameToEditPage,
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 28, top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'Preferred Genres',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Wrap(
                          runSpacing: 10,
                          spacing: 15,
                          children: [
                            buildCustomButton('Comedies', 18, false),
                            buildCustomButton('Dramas', 18, false),
                            buildCustomButton('Documentaries', 18, false),
                            buildCustomButton('Crime', 18, false),
                            buildCustomButton('Action & Adventure', 18, false),
                            buildCustomButton('Animated', 18, false),
                            buildCustomButton('Mystery', 18, false),
                            buildCustomButton('Anime', 18, false),
                            buildCustomButton('Horror', 18, false),
                            buildCustomButton('International', 18, false),
                            buildCustomButton('Reality', 18, false),
                            buildCustomButton('Romance', 18, false),
                            buildCustomButton('Family', 18, false),
                            buildCustomButton('British', 18, false),
                            buildCustomButton('Docuseries', 18, false),
                            buildCustomButton('Sci-Fi & Fantasy', 18, false),
                            buildCustomButton('Kids', 18, false),
                            buildCustomButton('Classic', 18, false),
                            buildCustomButton('Sports', 18, false),
                            buildCustomButton('TV Shows', 18, false),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Preferred Ratings',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Wrap(
                          runSpacing: 10,
                          spacing: 15,
                          children: [
                            buildCustomButton('TV-Y', 18, true),
                            buildCustomButton('TV-Y7', 18, true),
                            buildCustomButton('G', 18, true),
                            buildCustomButton('TV-G', 18, true),
                            buildCustomButton('TV-PG', 18, true),
                            buildCustomButton('PG-13', 18, true),
                            buildCustomButton('TV-14', 18, true),
                            buildCustomButton('R', 18, true),
                            buildCustomButton('TV-MA', 18, true),
                          ],
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'Movies',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 0, right: 100),
                          child: TextFormField(
                            controller: movieController,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            onChanged: (value) {
                              moviesTextFieldValue = value;
                            },
                            decoration: const InputDecoration(
                              hintText: 'Enter movies that you like',
                              hintStyle: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Actors',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 0, right: 100),
                          child: TextFormField(
                            controller: actorController,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            onChanged: (value) {
                              actorsTextFieldValue = value;
                            },
                            decoration: const InputDecoration(
                              hintText: 'Enter actors that you like',
                              hintStyle: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(bottom: 8.8),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SelectServicesPage(),
                              ),
                            );
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Transform.translate(
                                offset: const Offset(93.5, 4.9), // Adjust x and y values for the desired position
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
                              const SizedBox(height: 100),
                              Container(
                                padding: const EdgeInsets.only(bottom: 8.8),
                                child: GestureDetector(
                                onTap: () {
                                    runsqlcommands();
                                    final String? routeName = ModalRoute.of(context)?.settings.name;
                                    removeRouteByName(context, "$routeName");
                                    Navigator.of(context).push(NoSwipeBackPageRoute(page: const GroupsListPage()));
                                },
                                  child: RichText(
                                    text: const TextSpan(
                                      text: 'Save Member',
                                      style: TextStyle(
                                        color: Colors.white,
                                        decoration: TextDecoration.underline,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w900,
                                        fontSize: 20,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: '\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0',
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
                          padding: const EdgeInsets.only(top: 40, right: 28),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(NoSwipeBackPageRoute(page: const SelectServicesPage()));
                            },
                            child: const Center(
                              child: Text(
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
                      ),
                      const SizedBox(height: 140),
                      ],
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
      );
  }
}

void removeRouteByName(BuildContext context, String routeNameToRemove) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => GroupsListPage()), // Where you want to navigate
    (Route<dynamic> route) {
      // Return true to keep the route, false to remove it
      if (route.settings.name == routeNameToRemove) {
        return false; // Remove the route if it matches
      }
      return true; // Keep the route otherwise
    },
  );
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

