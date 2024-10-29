import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:journease/usermodule/screens/chooseplace.dart';
import 'package:journease/usermodule/screens/hotels.dart';
import 'package:journease/usermodule/screens/rooms1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'hotelontap.dart'; // Import the hotel booking home page

class HotelSearch extends StatefulWidget {
  final String selectedvalue;
  final int rooms;
  final int adults;
  final int children;

  HotelSearch({
    super.key,
    required this.selectedvalue,
    required this.rooms,
    required this.adults,
    required this.children,
  });

  @override
  State<HotelSearch> createState() => _HotelSearchState();
}

class _HotelSearchState extends State<HotelSearch> {
  DateTime? selected;
  DateTime? selected1;
  late String selectedPlace;
  late int rooms;
  late int adults;
  late int children;
  
  // Initialize with default values
  late String checkInDate = DateTime.now().toIso8601String().substring(0, 10);
  late String checkOutDate = DateTime.now().toIso8601String().substring(0, 10);

  @override
  void initState() {
    super.initState();
    selectedPlace = widget.selectedvalue.isNotEmpty ? widget.selectedvalue : 'Choose a place';
    rooms = widget.rooms;
    adults = widget.adults;
    children = widget.children;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new, size: 14),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hotels and Resorts",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        titleSpacing: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // CHOOSE PLACE
            ListTile(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChooosePlace(),
                  ),
                );

                if (result != null && result is String) {
                  setState(() {
                    selectedPlace = result;
                  });
                }
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              tileColor: Colors.black12,
              leading: Icon(Icons.search),
              title: Text("CHOOSE A PLACE", style: TextStyle(fontSize: 12)),
              subtitle: Text(
                selectedPlace,
                style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
              ),
            ),
            SizedBox(height: 10),
            // CHECK IN & CHECK OUT DATES
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    onTap: () async {
                      DateTime? select = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2048, 12, 31),
                      );
                      selected = select;
                      checkInDate = selected != null ? selected!.toIso8601String().substring(0, 10) : DateTime.now().toIso8601String().substring(0, 10);
                      setState(() {});
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    tileColor: Colors.black12,
                    leading: Icon(Icons.calendar_month_outlined),
                    title: Text("CHECK IN DATE", style: TextStyle(fontSize: 12)),
                    subtitle: Text(
                      checkInDate,
                      style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ListTile(
                    onTap: () async {
                      DateTime? select1 = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2048, 12, 31),
                      );
                      selected1 = select1;
                      checkOutDate = selected1 != null ? selected1!.toIso8601String().substring(0, 10) : DateTime.now().toIso8601String().substring(0, 10);
                      setState(() {});
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    tileColor: Colors.black12,
                    leading: Icon(Icons.calendar_month_outlined),
                    title: Text("CHECK OUT DATE", style: TextStyle(fontSize: 12)),
                    subtitle: Text(
                      checkOutDate,
                      style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            // ROOM & GUESTS
            ListTile(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Rooms1(
                      rooms: rooms,
                      adults: adults,
                      children: children,
                    ),
                  ),
                );

                if (result != null && result is Map) {
                  setState(() {
                    rooms = result['rooms'];
                    adults = result['adults'];
                    children = result['children'];
                  });
                }
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              tileColor: Colors.black12,
              leading: Icon(Icons.person_2_outlined),
              title: Text("ROOM & GUESTS", style: TextStyle(fontSize: 12)),
              subtitle: Text(
                "$rooms room/s, $adults adults, $children children",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            // SEARCH BUTTON
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 222, 121, 90),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton( 
                child: Text(
                  "SEARCH",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                ),
                onPressed: () async {
                  // Validation logic
                  if (rooms == 0) {
                    showErrorDialog(context, "Please select at least one room.");
                    return;
                  }

                  if (adults + children == 0) {
                    showErrorDialog(context, "Please select at least one guest.");
                    return;
                  }

                  if (checkInDate.isEmpty || checkOutDate.isEmpty) {
                    showErrorDialog(context, "Please select valid check-in and check-out dates.");
                    return;
                  }

                  await saveSearchDetails();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HotelBookingHomePage(
                        selectedPlace: selectedPlace,
                        checkInDate: checkInDate,
                        checkOutDate: checkOutDate,
                        rooms: rooms,
                        guests: adults,
                        children: children,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to show error dialog
  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Validation Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> saveSearchDetails() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentReference userDoc = FirebaseFirestore.instance.collection('appusers').doc(user.uid);
        await userDoc.collection('searches').add({
          'selectedPlace': selectedPlace,
          'rooms': rooms,
          'adults': adults,
          'children': children,
          'checkInDate': checkInDate,
          'checkOutDate': checkOutDate,
          'timestamp': FieldValue.serverTimestamp(),
        });
        print("Search details saved successfully!");
      } else {
        print("No user logged in.");
      }
    } catch (e) {
      print("Error saving search details: $e");
    }
  }
}
