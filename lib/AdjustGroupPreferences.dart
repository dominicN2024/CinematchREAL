// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, avoid_print, file_names, unused_import, prefer_interpolation_to_compose_strings, avoid_unnecessary_containers, unused_local_variable

import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cinematch/SelectServicesPage.dart';
import 'package:cinematch/HomePage.dart';
import 'package:cinematch/globals.dart';
import 'package:cinematch/GroupsListPage.dart';

void main() {
  runApp(
    const MaterialApp(
      home: AdjustGroupPreferences(),
    ),
  );
}

class AdjustGroupPreferences extends StatefulWidget {
  const AdjustGroupPreferences({Key? key}) : super(key: key);

  @override
  _AdjustGroupPreferencesState createState() => _AdjustGroupPreferencesState();
}

class _AdjustGroupPreferencesState extends State<AdjustGroupPreferences> {
  Set<String> selectedButtons = {};
  Set<String> selectedCustomButtons = {};
  String moviesTextFieldValue = '';
  String actorsTextFieldValue = '';
  String selectedUser = '';
  Map<String, Set<String>> userSelectedButtons = {};
  TextEditingController movieController = TextEditingController();
  TextEditingController actorController = TextEditingController();

  Future<void> _editGroupName() async {
    String newName = await showDialog(
      context: context,
      builder: (BuildContext context) {
        String editedName = groupName;
        return AlertDialog(
          title: const Text('Edit Group'),
          content: TextFormField(
            initialValue: groupName,
            onChanged: (value) {
              editedName = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(editedName);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (newName != groupName) {
      setState(() {
        groupName = newName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const int characterLimit = 20;

    String limitedText = groupName.length > characterLimit
        ? '${groupName.substring(0, characterLimit)}...'
        : groupName;

return Scaffold(
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
                  'Edit Groups',
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
                                        limitedText,
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
                                    selectName();
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
                              'Add Member +',
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
                        buildCustomButton('Comedies', 18),
                        buildCustomButton('Dramas', 18),
                        buildCustomButton('Documentaries', 18),
                        buildCustomButton('Crime', 18),
                        buildCustomButton('Action & Adventure', 18),
                        buildCustomButton('Animated', 18),
                        buildCustomButton('Mystery', 18),
                        buildCustomButton('Anime', 18),
                        buildCustomButton('Horror', 18),
                        buildCustomButton('International', 18),
                        buildCustomButton('Reality', 18),
                        buildCustomButton('Romance', 18),
                        buildCustomButton('Family', 18),
                        buildCustomButton('British', 18),
                        buildCustomButton('Docuseries', 18),
                        buildCustomButton('Sci-Fi & Fantasy', 18),
                        buildCustomButton('Kids', 18),
                        buildCustomButton('Classic', 18),
                        buildCustomButton('Sports', 18),
                        buildCustomButton('TV Shows', 18),
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
                        buildCustomButton('TV-Y', 18),
                        buildCustomButton('TV-Y7', 18),
                        buildCustomButton('G', 18),
                        buildCustomButton('TV-G', 18),
                        buildCustomButton('TV-PG', 18),
                        buildCustomButton('PG-13', 18),
                        buildCustomButton('TV-14', 18),
                        buildCustomButton('R', 18),
                        buildCustomButton('TV-MA', 18),
                        buildCustomButton('NC-17', 18),
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
                          offset: const Offset(56, 4.9), // Adjust x and y values for the desired position
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const HomePage(),
                                    ),
                                  );
                                },
                                  child: RichText(
                                    text: const TextSpan(
                                      text: 'Save',
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
  ),
  );
}

  Widget buildCustomButton(String text, double fontSize) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          if (selectedCustomButtons.contains(text)) {
            selectedCustomButtons.remove(text);
          } else {
            selectedCustomButtons.add(text);
          }
          print(selectedUser);
          print(selectedCustomButtons);
        });
        // Store preferences for the selected user
        if (selectedUser.isNotEmpty) {
          userPreferences[selectedUser] = selectedCustomButtons;
        }
        print("asd" + userActorsPreferences.toString());
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

  void selectName() {
    String newMemberName = '';
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
                      selectName();
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
                            GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => HomePage(),
                  //   ),
                  // );
                },
                child: SvgPicture.asset(
                  'assets/profile.svg',
                  height: 48, // Adjust the height as needed
                  color: Colors.white,
                ),
              ),
              // Add more SVG assets as needed
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GroupsListPage(),
                    ),
                  );
                },
                child: SvgPicture.asset(
                  'assets/group.svg',
                  height: 48, // Adjust the height as needed
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
    );
  }
}