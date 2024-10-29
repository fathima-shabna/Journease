import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:journease/usermodule/screens/tripdetails.dart';

class WithorWithout extends StatefulWidget {
  final String selectedvalue;
  final String selectedvalue2;
  final int rooms;
  final int adults;
  final int children;
  final DateTime startingDate;
  final String packageId; 
  final String userId;
  
  const WithorWithout({Key? key, required this.packageId, required this.userId, required this.selectedvalue, required this.selectedvalue2, required this.rooms, required this.adults, required this.children, required this.startingDate}) : super(key: key);

  @override
  _WithorWithoutState createState() => _WithorWithoutState();
}

class _WithorWithoutState extends State<WithorWithout> {
  double? withFlightPrice;
  double? withoutFlightPrice;

  @override
  void initState() {
    super.initState();
    _fetchPackageData();  // Fetch the package data when the widget initializes
  }

  Future<void> _fetchPackageData() async {
    try {
      // Fetch the package document using the package ID
      DocumentSnapshot packageSnapshot = await FirebaseFirestore.instance
          .collection('packages')
          .doc(widget.packageId)
          .get();

      if (packageSnapshot.exists) {
        setState(() {
          // Access the withFlightPrice and withoutFlightPrice fields from the document
          withFlightPrice = packageSnapshot['pricePerPerson'];
          withoutFlightPrice = packageSnapshot['pricePerPerson1'];
        });
      } else {
        print("Package not found");
      }
    } catch (e) {
      print("Error fetching package data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              onTap: () {
                if (withFlightPrice.toString() != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TripDetailsScreen(withflight1: true, 
                      selectedvalue: widget.selectedvalue, 
                      selectedvalue2: widget.selectedvalue2, 
                      packageId: widget.packageId, 
                      userId: widget.userId, 
                      startingDate: widget.startingDate, 
                      rooms: widget.rooms, 
                      adults: widget.adults, 
                      children: widget.children, 
                      price: withFlightPrice!.toStringAsFixed(2),
                      price2: withoutFlightPrice!.toStringAsFixed(2),
                      ),
                    ),
                  );
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.black45),
              ),
              leading: Text(
                "With flight",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),
              ),
              title: Text(
                "₹ ${withFlightPrice?.toStringAsFixed(2) ?? 'Loading...'}",
                textAlign: TextAlign.end,
              ),
              subtitle: Text("per person", style: TextStyle(fontSize: 12), textAlign: TextAlign.end),
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14),
            ),
            SizedBox(height: 10),
            ListTile(
              onTap: () {
                if (withoutFlightPrice.toString() != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TripDetailsScreen(withflight1: false, 
                      selectedvalue: widget.selectedvalue, 
                      selectedvalue2: widget.selectedvalue2, 
                      packageId: widget.packageId, 
                      userId: widget.userId, 
                      startingDate: widget.startingDate, 
                      rooms: widget.rooms, 
                      adults: widget.adults, 
                      price: withFlightPrice!.toStringAsFixed(2),
                      price2: withoutFlightPrice!.toStringAsFixed(2),
                      children: widget.children, 
                      // price: withoutFlightPrice!
                      ),
                    ),
                  );
                  print(widget.selectedvalue);
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.black45),
              ),
              leading: Text(
                "Without flight",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),
              ),
              title: Text(
                "₹ ${withoutFlightPrice?.toStringAsFixed(2) ?? 'Loading...'}",
                textAlign: TextAlign.end,
              ),
              subtitle: Text("per person", style: TextStyle(fontSize: 12), textAlign: TextAlign.end),
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14),
            ),
          ],
        ),
      ),
    );
  }
}
