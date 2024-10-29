import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:journease/usermodule/screens/navigation.dart';
import 'package:journease/usermodule/screens/room.dart';
import 'package:journease/usermodule/screens/searchpackage.dart';
import 'package:journease/usermodule/screens/startingfrom2.dart';
import 'package:journease/usermodule/screens/travellingto.dart';

class Packages extends StatefulWidget {
  final String selectedvalue;
  final String selectedvalue2;
  final int rooms;
  final int adults;
  final int children;
  final String userId;

  Packages({
    super.key,
    required this.selectedvalue,
    required this.selectedvalue2,
    required this.rooms,
    required this.adults,
    required this.children, required this.userId,
  });

  @override
  State<Packages> createState() => _PackagesState();
}

class _PackagesState extends State<Packages> {
  String startingFrom = '';
  String travellingTo = '';
  DateTime? selectedDate;
  late int rooms;
  late int adults;
  late int children;

  @override
  void initState() {
    super.initState();
    // Initialize the values with the values passed from the constructor
    startingFrom = widget.selectedvalue;
    travellingTo = widget.selectedvalue2;
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
              "Holiday packages",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 5),
            Text(
              "India and International",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black54),
            ),
          ],
        ),
        titleSpacing: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            ListTile(
              onTap: () {
                // Navigate to the starting from screen
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp1(),)).then((value) {
                  if (value != null) {
                    setState(() {
                      startingFrom = value; // Update the value directly
                    });
                  }
                });
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              tileColor: Colors.black12,
              leading: Icon(Icons.location_on_outlined),
              title: Text("STARTING FROM", style: TextStyle(fontSize: 12)),
              subtitle: Text(startingFrom, style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black)),
            ),
            SizedBox(height: 10),
            ListTile(
              onTap: () {
                // Navigate to the travelling to screen
                Navigator.push(context, MaterialPageRoute(builder: (context) => TravellingTo(),)).then((value) {
                  if (value != null) {
                    setState(() {
                      travellingTo = value; // Update the value directly
                    });
                  }
                });
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              tileColor: Colors.black12,
              leading: Icon(Icons.location_on_outlined),
              title: Text("TRAVELLING TO", style: TextStyle(fontSize: 12)),
              subtitle: Text(travellingTo, style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black)),
            ),
            SizedBox(height: 10),
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
                      if (select != null) {
                        setState(() {
                          selectedDate = select; // Save the selected date
                        });
                      }
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    tileColor: Colors.black12,
                    leading: Icon(Icons.calendar_month_outlined),
                    title: Text("STARTING DATE", style: TextStyle(fontSize: 12)),
                    subtitle: Text(
                      selectedDate?.toLocal().toString().substring(0, 10) ?? DateTime.now().toString().substring(0, 10),
                      style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ListTile(
                    onTap: () async{
                      final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => Rooms(rooms: rooms,
                      adults: adults,
                      children: children,),));
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
                      "${rooms} room/s, ${adults} adults, ${children} children",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
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
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Package2(selectedvalue: startingFrom,selectedvalue2: travellingTo,rooms: rooms,adults: adults,children: children,userId: widget.userId,startingDate: selectedDate!,),));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
