import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:journease/usermodule/screens/withorwithoutflight.dart';

class Package2 extends StatelessWidget {
  final String selectedvalue;
  final String selectedvalue2;
  final int rooms;
  final int adults;
  final int children;
  final DateTime startingDate;
  final String userId;

  const Package2({
    Key? key,
    required this.selectedvalue,
    required this.selectedvalue2,
    required this.rooms,
    required this.adults,
    required this.userId,
    required this.children,
    required this.startingDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String firstValue = selectedvalue.split(',').first.trim();
    String secondValue = selectedvalue2.split(',').first.trim();
    String formattedDate = DateFormat('yyyy-MM-dd').format(startingDate);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 218, 224, 230),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 15),
        ),
        title: Text(
          "$firstValue to $secondValue",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Color.fromARGB(255, 222, 121, 90),
        elevation: 0,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _fetchPackages(startingDate, secondValue),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No packages found'));
          }

          var packageDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: packageDocs.length,
            itemBuilder: (context, index) {
              var packageData = packageDocs[index].data() as Map<String, dynamic>;
               var packageId = packageDocs[index].id;
              double totalPrice = packageData['pricePerPerson']*(adults+children);

              return Padding(
                padding: EdgeInsets.all(8),
                child: InkWell(
                  onTap: () => showModalBottomSheet(
                    context: context,
                    builder: (context) => WithorWithout(
                    packageId: packageId,
                    userId: userId,
                    selectedvalue: firstValue,
                    selectedvalue2: secondValue,
                    startingDate: startingDate,
                    adults: adults,
                    children: children,
                    rooms: rooms,
                    ),
                    backgroundColor: Colors.white70,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.black12),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(packageData['imageUrl'] ?? ''),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                packageData['title'] ?? '',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Divider(),
                              SizedBox(height: 4),
                              // Text(packageData['description'] ?? ''),
                              if (packageData['description'] != null)
  Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: (packageData['description'] as String)
        .split('.')
        .where((sentence) => sentence.trim().isNotEmpty) // Filter out empty sentences
        .map((sentence) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\u2022', // Unicode for bullet character
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 8), // Add space between bullet and sentence
                  Expanded(
                    child: Text(
                      sentence.trim(),
                      style: TextStyle(
                        fontSize: 14,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ))
        .toList(),
  ),


                              SizedBox(height: 8),
                              Text('Price: ₹${packageData['pricePerPerson'] ?? 0} /Person',
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text('Total Price: ₹${totalPrice.toStringAsFixed(2) ?? 0}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 222, 121, 90),
        onPressed: () {},
        child: Icon(Icons.question_answer, color: Colors.white),
      ),
    );
  }

  Future<QuerySnapshot> _fetchPackages(DateTime date, String destination) {
    return FirebaseFirestore.instance
        .collection('packages')
        .where('startDate', isEqualTo: date)
        .where('destination', isEqualTo: destination)
        .get();
  }
}
