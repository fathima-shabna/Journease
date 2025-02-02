import 'package:flutter/material.dart';

class Rooms1 extends StatefulWidget {
  final int rooms;
  final int adults;
  final int children;

  const Rooms1({
    super.key,
    required this.rooms,
    required this.adults,
    required this.children,
  });

  @override
  State<Rooms1> createState() => _Rooms1State();
}

class _Rooms1State extends State<Rooms1> {
  late int count;
  late int count1;
  late int count2;

  @override
  void initState() {
    super.initState();
    // Initialize the counts with the values passed from HotelSearch
    count = widget.rooms;
    count1 = widget.adults;
    count2 = widget.children;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // Pass the selected values back to the previous page when navigating back
            Navigator.pop(context, {
              'rooms': count,
              'adults': count1,
              'children': count2,
            });
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text("Select Rooms & Guests"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Number of rooms
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Text('No. of rooms:'),
                    Expanded(child: SizedBox()),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (count > 0) {
                            count--;
                          }
                        });
                      },
                      icon: Icon(Icons.remove, size: 14),
                    ),
                    Text(count.toString()),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          count++;
                        });
                      },
                      icon: Icon(Icons.add, size: 14),
                    ),
                  ],
                ),
              ),
            ),
            // Number of adults
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Text('No. of adults:'),
                    Expanded(child: SizedBox()),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (count1 > 0) {
                            count1--;
                          }
                        });
                      },
                      icon: Icon(Icons.remove, size: 14),
                    ),
                    Text(count1.toString()),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          count1++;
                        });
                      },
                      icon: Icon(Icons.add, size: 14),
                    ),
                  ],
                ),
              ),
            ),
            // Number of children
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Text('No. of children:'),
                    Expanded(child: SizedBox()),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (count2 > 0) {
                            count2--;
                          }
                        });
                      },
                      icon: Icon(Icons.remove, size: 14),
                    ),
                    Text(count2.toString()),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          count2++;
                        });
                      },
                      icon: Icon(Icons.add, size: 14),
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
}
