// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, avoid_print, file_names, unused_import, prefer_interpolation_to_compose_strings, avoid_unnecessary_containers, no_leading_underscores_for_local_identifiers, unused_local_variable, prefer_final_fields, unused_field, unnecessary_null_comparison

import 'dart:collection';
import 'package:cinematch/NoSwipeBackPageRoute.dart';
import 'package:cinematch/NewGroupMemberListPage.dart';
import 'package:cinematch/queryCommand.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cinematch/SelectServicesPage.dart';
import 'package:cinematch/HomePage.dart';
import 'package:cinematch/globals.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;


void main() {
  runApp(
    const MaterialApp(
      home: NewGroupPage(),
    ),
  );
}

class NewGroupPage extends StatefulWidget {
  const NewGroupPage({Key? key}) : super(key: key);

  @override
  _NewGroupPageState createState() => _NewGroupPageState();
}

class _NewGroupPageState extends State<NewGroupPage> {
  int ratingsSelected = 0;
  List<dynamic> _data = [];
  Query query = Query();
  Set<String> selectedButtons = {};
  Set<String> selectedCustomButtons = {};
  Set<String> selectedRatingButtons = {};
  String moviesTextFieldValue = '';
  String actorsTextFieldValue = '';
  String selectedUser = '';

  @override
void initState() {
  super.initState();
  // Set the initial text for the TextEditingController
  groupName = 'New Group';
  userPreferences.clear();
  selectedCustomButtons.clear();
  memberNames.clear();
  userMoviePreferences.clear();
  userActorsPreferences.clear();
  selectedButtons.clear();
}

@override
void dispose() {
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    const int characterLimit = 20;

    String limitedText = groupName.length > characterLimit
        ? '${groupName.substring(0, characterLimit)}...'
        : groupName;

  return GestureDetector(
    onTap: () => FocusScope.of(context).unfocus(),
    child: Scaffold(
    body: Stack(
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
                  child: const Text(
                    'Create Groups',
                    style: TextStyle(
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
                      Container(
                        padding: const EdgeInsets.only(top: 40),
                        child: const Text(
                          'Group Name',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 310,
                        child: TextFormField(
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          onChanged: (value) {
                            setState(() {
                            newGroupName = value;
                            });
                          },
                        decoration: const InputDecoration(
                          hintText: "Enter a name that you like",
                            hintStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.only(top: 70),
                        child: const Text(
                          'Group Members',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.only(right: 28),
                        child: const Center(
                          child: SizedBox(
                            width: 340,
                            child: MySeparator(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              for (String element in newGroupMembers)
                Column(
                  children: [
                      SizedBox(
                      child: addMemberButton(element, false, Icons.close, context),
                      ), // Call your function for each iteration
                      const SizedBox(
                        width: 340,
                        child: MySeparator(),
                      ),
                    // const SizedBox(height: 20), // Add spacing after each DropdownButton
                  ],
                ),
                addMemberButton("Add Member", true, Icons.add, context),
                Container(
                  padding: const EdgeInsets.only(left: 44),
                  child: const SizedBox(
                    width: 340,
                    child: MySeparator(),
                  ),
                ),
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
                        const SizedBox(height: 160),
                        Container(
                          padding: const EdgeInsets.only(bottom: 8.8),
                          child: GestureDetector(
                          onTap: () {
                            if (groupName.isEmpty) {
                              groupName = "New Group";
                              groupsList.add(groupName);
                            } else {
                              groupsList.add(groupName);
                            }
                            // print(groupsList);
                            if (memberNames.isEmpty || wrongPassword == true || usernameExist == true || userPreferences.isEmpty == true || services.isEmpty == true) {
                            
                            } else {
                              firstRun = true;
                              runsqlcommands();
                              Future.delayed(const Duration(milliseconds: 150), () {
                                Navigator.of(context).push(NoSwipeBackPageRoute(page: const HomePage()));
                              });
                            }
                          },
                            child: RichText(
                              text: const TextSpan(
                                text: 'Finish Setup',
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
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
        const NavBar(),
        ],
      ),
    ),
  );
}
  

  
  void runsqlcommands() async {
  List<dynamic> _data = [];

  // Ensure services is initialized and not null
  services = Set.from(removeCharacters(services.toList(), "{}"));

  

  for (var entry in userPreferences.entries) {
    String name = entry.key;
    Set<String> genres = entry.value;
    // print('$name: $genres');
  }

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

  if (!isSubmitted) {
    String sql = "INSERT INTO `groups`(`name`, `members`,`user_id_fk`) VALUES ('$groupName','$memberNames','$userID')";
    await query.executeSql(sql);
  }

  // Iterate through memberNames
    for (String name in memberNames) {
        selectedUser = name;
        selectedButtons = userPreferences[name] ?? {}; // Ensure there's a fallback for null
        selectedCustomButtons = selectedButtons.toSet();

        // Use null-aware operators to avoid null exceptions
        String movie = userMoviePreferences[name] ?? "";
        String actor = userActorsPreferences[name] ?? "";

        // Gets Group id
        String groupID = "";
        sql = "SELECT group_id FROM groups WHERE user_id_fk = '$userID'";
        // print(sql);
          try {
            List<Map<String, dynamic>>? records = await getGroupID(sql);
            if (records.isNotEmpty) {
              var record = records.first;
              if (record.containsKey("group_id") && record["group_id"] != null) {
                groupID = record["group_id"].toString();
              }
            }
          } catch (e) {
            print('Error: $e');
          }

          // print("Group ID: $groupID");
        // print(userID);
        // print(groupID);
        // Construct the preferences for this member
        String memberPreferences = '';
        if (userPreferences.containsKey(selectedUser)) {
        // Use null-aware operator to get the genres for the selected user
        Set<String> genres = userPreferences[selectedUser] ?? {}; // Use an empty set as a default value if not found
        memberPreferences = genres.join(', ');
        }

        if (!isSubmitted) {
          String nameREAL = name.replaceAll(RegExp(r'\{|\}'), '');
          // Clean the nameREAL variable by removing the curly braces
          String cleanedNameREAL = nameREAL.replaceAll('{', '').replaceAll('}', '');

          // Construct the SQL INSERT statement with the cleaned nameREAL
          String sql = "INSERT INTO `members`(`name`, `preferences`, `mpaaratings`, `movie_preference`, `actor_preference`, `group_id_fk`) VALUES ('$cleanedNameREAL', '$memberPreferences', 'no', '$movie', '$actor', '$groupID')";
          print(sql);
          await query.executeSql(sql);
        }
        groupIddb = groupID;
        userIddb = userID;
      }
    }
}

Widget addMemberButton(String title, bool AddMember, IconData icon, context) {
  return GestureDetector(
    onTap: () {
      if (newGroupName != '') {

        if (AddMember) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewGroupMemberListPage(),
            ),
          );
        }
      }
    },
    child: Center(
      child: Container(
        width: 340,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.transparent, // Adjust the color to match your theme
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Use spaceBetween to align items
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
            // Expanded widget is no longer needed here since MainAxisAlignment.spaceBetween is used
            Icon(
              icon, // The plus icon
              color: Colors.white,
            ),
          ],
        ),
      ),
    ),
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
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                },
                  child: SvgPicture.asset(
                  'assets/home.svg',
                  height: 48, // Adjust the height as needed
                  color: Colors.white,
                ),
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


class MySeparator extends StatelessWidget {
  final double height;

  const MySeparator({Key? key, this.height = 1.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        return Container(
          width: boxWidth,
          height: height,
          color: Colors.white, // Use a solid color
        );
      },
    );
  }
}
