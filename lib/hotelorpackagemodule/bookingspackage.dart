import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PackageBookingsPage extends StatefulWidget {
  final String hostId;
  const PackageBookingsPage({super.key, required this.hostId});

  @override
  _PackageBookingsPageState createState() => _PackageBookingsPageState();
}

class _PackageBookingsPageState extends State<PackageBookingsPage> {
  final String hostId = FirebaseAuth.instance.currentUser?.uid ?? '';
  List<Map<String, dynamic>> bookings = [];

  @override
  void initState() {
    super.initState();
    _fetchPackageBookings();
  }

  Future<void> _fetchPackageBookings() async {
    try {
      // Fetch all package bookings for the logged-in host
      QuerySnapshot bookingSnapshot = await FirebaseFirestore.instance
          .collection('packagebookings')
          .where('hostId', isEqualTo: hostId)
          .get();

      List<Map<String, dynamic>> fetchedBookings = [];
      for (var doc in bookingSnapshot.docs) {
        Map<String, dynamic> bookingData = doc.data() as Map<String, dynamic>;
        String packageId = bookingData['packageId'];

        // Fetch corresponding package details
        DocumentSnapshot packageSnapshot = await FirebaseFirestore.instance
            .collection('packages')
            .doc(packageId)
            .get();

        if (packageSnapshot.exists) {
          var packageData = packageSnapshot.data() as Map<String, dynamic>;

          // Combine data
          bookingData['packageTitle'] = packageData['title'] ?? 'No Title';
          bookingData['nights'] = packageData['nights'] ?? 0;
          bookingData['days'] = packageData['days'] ?? 0;
          bookingData['destination'] = packageData['destination'] ?? 'No Destination';
          bookingData['travellerDetails'] = bookingData['travellerDetails'] ?? []; // Assuming this is a list in packageBookings
          // bookingData['contactInfo'] = bookingData['contactInfo'] ?? ''; // Assuming this is a field in packageBookings

          fetchedBookings.add(bookingData);
        }
      }

      setState(() {
        bookings = fetchedBookings;
      });
    } catch (e) {
      print("Error fetching package bookings: $e");
    }
  }

  Future<void> _deleteBooking(String bookingId) async {
    try {
      await FirebaseFirestore.instance.collection('packagebookings').doc(bookingId).delete();
      setState(() {
        bookings.removeWhere((booking) => booking['id'] == bookingId);
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Booking deleted successfully")));
    } catch (e) {
      print("Error deleting booking: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Package Bookings'),
        backgroundColor: Colors.teal,
      ),
      body: bookings.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking['packageTitle'] ?? 'No Title',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text('Destination: ${booking['destination']}'),
                        SizedBox(height: 8),
                        Text('Nights: ${booking['nights']}, Days: ${booking['days']}'),
                        SizedBox(height: 8),
                        Text('Contact Info: ${booking['contactInfo']}'),
                        SizedBox(height: 8),
                        Text('Travellers:'),
                        if (booking['travellerDetails'] != null && booking['travellerDetails'].isNotEmpty) 
                          ...booking['travellerDetails'].map<Widget>((traveller) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text('- ${traveller['fullName'] ?? 'Unknown'} (${traveller['age'] ?? 'N/A'} years old, Gender: ${traveller['gender'] ?? 'N/A'})'),
                            );
                          }).toList()
                        else
                          Text('No travelers found.'),
                          SizedBox(height: 8),
                        // ElevatedButton(
                        //   onPressed: () => _deleteBooking(booking['id']),
                        //   child: Text('Delete Booking'),
                        //   style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        // ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
