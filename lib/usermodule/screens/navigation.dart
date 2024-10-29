import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:journease/usermodule/screens/Home1.dart';
import 'package:journease/usermodule/screens/home.dart';
import 'package:journease/usermodule/screens/mytrip.dart';
import 'package:journease/usermodule/models/userdetailModel.dart'; // Import your UserDataModel

class Navigation extends StatelessWidget {
  Navigation({super.key, this.index, required this.user});

  final int? index; // Make sure this is of type int?
  final UserDataModel user; // User data model passed from the login page

  ValueNotifier<int> current = ValueNotifier(0);
  
  // Update the screens list to include the user data
  List<Widget> screens = [];

  @override
  Widget build(BuildContext context) {
    if (index != null) {
      current.value = index!;
    }

    // Initialize screens list inside the build method to ensure the user is available
    screens = [
      Home(user: user), // Pass user data to Home
      MyTrip(),
    ];

    return Scaffold(
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: current,
        builder: (context, value, child) {
          return BottomNavigationBar(
            backgroundColor: Colors.white54,
            onTap: (value) {
              current.value = value;
            },
            selectedItemColor: const Color.fromARGB(255, 6, 43, 72),
            unselectedItemColor: Colors.grey,
            unselectedLabelStyle: TextStyle(color: Colors.grey),
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 20),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.travel_explore_outlined, size: 19),
                label: "My trips",
              ),
            ],
            currentIndex: current.value,
          );
        },
      ),
      body: ValueListenableBuilder(
        valueListenable: current,
        builder: (context, value, child) {
          return screens[current.value];
        },
      ),
    );
  }
}
