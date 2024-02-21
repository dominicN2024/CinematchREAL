// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, avoid_print, file_names, unused_import, prefer_interpolation_to_compose_strings, avoid_unnecessary_containers, no_leading_underscores_for_local_identifiers, unused_local_variable, prefer_final_fields, unused_field, unnecessary_null_comparison

import 'dart:collection';
import 'package:cinematch/NoSwipeBackPageRoute.dart';
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
      home: CreateGroupPage(),
    ),
  );
}

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({Key? key}) : super(key: key);

  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  int ratingsSelected = 0;
  List<dynamic> _data = [];
  Query query = Query();
  Set<String> selectedButtons = {};
  Set<String> selectedCustomButtons = {};
  String moviesTextFieldValue = '';
  String actorsTextFieldValue = '';
  String selectedUser = '';
  Map<String, Set<String>> userSelectedButtons = {};
  TextEditingController movieController = TextEditingController();
  TextEditingController actorController = TextEditingController();
  final TextEditingController _controllerText = TextEditingController();

  @override
void initState() {
  super.initState();
  // Set the initial text for the TextEditingController
  _controllerText.text = groupName == "" ? 'New Group' : groupName;
}

@override
void dispose() {
  _controllerText.dispose();
  super.dispose();
}

  Future<void> _editGroupName() async {
  // Ensure the controller is updated to reflect the current groupName before showing the dialog
  _controllerText.text = groupName.isNotEmpty ? groupName : '';

  String newName = await showDialog(
  context: context,
  builder: (BuildContext context) {
    return Dialog(
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(4, 0, 59, 1),
              Color.fromRGBO(90, 0, 90, 1),
            ],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Edit Group',
              style: TextStyle(
                fontSize: 24.0,
              ),
            ),
            TextFormField(
              controller: _controllerText,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                hintText: 'New Group', // Placeholder text
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(_controllerText.text); // Pop with current text
                  },
                  child: const Text(
                    'Add',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  },
);

  // Check if newName is not null and different from the previous groupName
  if (newName != null && newName != groupName) {
    setState(() {
      groupName = newName;
      // No need to set _controllerText.text = newName here since the dialog already updates it
    });
  }
}

Future<List<Map<String, dynamic>>> fetchData(String sqlCommand) async {
  var url = 'https://dominicn2024.smtchs.org/cinematch/retrievedata.php';
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
                          GestureDetector(
                            onTap: _editGroupName,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            Text(
                                              groupName.isEmpty ? 'New Group' : groupName,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            const Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 20),
                            child: Wrap(
                              spacing: 20,
                              children: [
                                ...memberNames.map((name) => Padding(
                                      padding: const EdgeInsets.only(bottom: 0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            selectedUser = name;
                                            selectedButtons = userPreferences[name] ?? {}; // Load preferences for the selected user
                                            selectedCustomButtons = selectedButtons.toSet();
                                            movieController.text = userMoviePreferences[name]!;
                                            actorController.text = userActorsPreferences[name]!;
                                          });
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            selectedUser == name
                                                ? const Color.fromRGBO(90, 0, 90, 1)
                                                : const Color.fromRGBO(4, 0, 59, 1),
                                          ),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              side: const BorderSide(
                                                color: Color.fromRGBO(90, 0, 90, 1),
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.circular(100),
                                            ),
                                          ),
                                          elevation: MaterialStateProperty.all<double>(
                                              4.5),
                                          shadowColor:
                                              MaterialStateProperty.all<Color>(
                                            const Color.fromRGBO(255, 255, 255, .2),
                                          ),
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.white),
                                        ),
                                        child: Text(
                                          name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )),
                                ElevatedButton(
                                  onPressed: () =>
                                      _showAddMemberDialog(context),
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all<EdgeInsets>(
                                      const EdgeInsets.all(8),
                                    ),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color.fromRGBO(4, 0, 59, 1)),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        side: const BorderSide(
                                          color: Color.fromRGBO(90, 0, 90, 1),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                    ),
                                    elevation:
                                        MaterialStateProperty.all<double>(4.5),
                                    shadowColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color.fromRGBO(255, 255, 255, .2)),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(Colors.white),
                                  ),
                                  child: const Text(
                                    'Add Member + ',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Select Preferred Genres',
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
                            'Select Preferred Ratings',
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
                                setState(() {
                                  moviesTextFieldValue = value;
                                  if (selectedUser.isNotEmpty) {
                                    userMoviePreferences[selectedUser] = moviesTextFieldValue;
                                  }
                                });
                              },
                              decoration: const InputDecoration(
                                hintText: 'Enter movies that you like',
                                hintStyle: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              enabled: selectedUser.isNotEmpty, // Disable the field if selectedUser is empty
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
                                setState(() {
                                  actorsTextFieldValue = value;
                                    if (selectedUser.isNotEmpty) {
                                      userActorsPreferences[selectedUser] = actorsTextFieldValue;
                                    }
                                });
                              },
                              decoration: const InputDecoration(
                                hintText: 'Enter actors that you like',
                                hintStyle: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              enabled: selectedUser.isNotEmpty,
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
          ],
        ),
      ),
    );
  }

  Widget buildCustomButton(String text, double fontSize, bool isRatingButton) {
    return ElevatedButton(
      onPressed: () {
        if (!selectedUser.isEmpty) {
          setState(() {
            if (selectedCustomButtons.contains(text)) {
              selectedCustomButtons.remove(text);
            } else {
              selectedCustomButtons.add(text);
            }
          });

          // Store preferences for the selected user
          if (selectedUser.isNotEmpty) {
            userPreferences[selectedUser] = selectedCustomButtons;
          }
        }
          // print("User Ratings Count: $userRatingsCount");
      },
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.all(8),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          selectedCustomButtons.contains(text)
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

  Future<void> _showAddMemberDialog(BuildContext context) async {
    String newMemberName = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 200),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromRGBO(4, 0, 59, 1),
                  Color.fromRGBO(90, 0, 90, 1),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Add Member',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, bottom: 8.0, left: 20, right: 20),
                  child: TextField(
                    onChanged: (value) {
                      newMemberName = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Enter Member Name',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Validate if a name is entered
                      if (newMemberName.isNotEmpty) {
                        // Check if the name already exists
                        if (!memberNames.contains(newMemberName)) {
                           setState(() {
                              memberNames.add(newMemberName);
                              selectedUser = newMemberName;

                              // Initialize preferences for the new user
                              userPreferences[newMemberName] = {};
                              userSelectedButtons[newMemberName] = {};
                              userSelectedButtons[newMemberName] = {};
                              userMoviePreferences[newMemberName] = "";
                              userActorsPreferences[newMemberName] = "";
                            });

                            // Load preferences for the selected user
                            setState(() {
                              selectedCustomButtons = userPreferences[newMemberName]?.toSet() ?? {};
                              selectedButtons = userSelectedButtons[newMemberName]?.toSet() ?? {};
                              movieController.text = userMoviePreferences[newMemberName] ?? '';
                              actorController.text = userActorsPreferences[newMemberName] ?? '';

                              // print(userMoviePreferences[newMemberName].toString() + " ples");
                              // movieController.text = 'please WOrk!';
                            });
                          // Close the dialog
                          Navigator.of(context).pop();
                        } else {
                          // Show an error message or handle the duplicate name scenario
                          // For example, you can display a snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Name already exists. Enter a unique name.'),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
    ).then((value) {
      if (value != null && value.isNotEmpty) {
        if (!memberNames.contains(value)) {
          // Clear selected buttons when a new member is added
          setState(() {
            selectedButtons.clear();
            selectedCustomButtons.clear();

            memberNames.add(value);
            selectedUser = value;
          });

          // Initialize preferences if they don't exist
          if (userPreferences[value] == null) {
            userPreferences[value] = {};
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Name already exists. Enter a unique name.'),
            ),
          );
        }
      }
    });
  }
  
  void runsqlcommands() async {
  List<dynamic> _data = [];

  // Ensure services is initialized and not null
  services = Set.from(removeCharacters(services.toList(), "{}"));

  
  // Assuming query is properly initialized earlier
  if (!isSubmitted) {
    String sql = "INSERT INTO `user`(`username`, `password`, `full_name`, `services`, `groups`, `created_at`) VALUES ('$username', SHA2('$password', 256), '$name', '$services', '$groupName', NOW())";
    await query.executeSql(sql); // Make sure executeSql is defined to handle this query
  }

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
  String allNames = "";
  int lastIndex = memberNames.length - 1; // Get the index of the last element
  for (int i = 0; i < memberNames.length; i++) {
    String name = memberNames.elementAt(i);
    // Append the name and add a comma only if it's not the last element
    allNames += name + (i < lastIndex ? "," : "");
  }
  // Your SQL statement should be outside the loop if you intend to insert them all at once
  String sql = "INSERT INTO `groups`(`name`, `members`, `user_id_fk`) VALUES ('$groupName', '$allNames', '$userID')";
  await query.executeSql(sql);

  sql = "INSERT INTO `groups`(`name`, `members`, `user_id_fk`) VALUES ('UNSORTED', '', '$userID')";
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
          String sql = "INSERT INTO `members`(`name`, `preferences`, `mpaaratings`, `movie_preference`, `actor_preference`, `group_id_fk`) VALUES ('$name', '$memberPreferences', 'no', '$movie', '$actor', '$groupID')";
          await query.executeSql(sql);
        }
        groupIddb = groupID;
        userIddb = userID;
      }
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

