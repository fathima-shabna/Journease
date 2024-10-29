import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // for date formatting and comparison

class BookingListScreen extends StatefulWidget {
  final String hostId; // The logged-in host's ID

  const BookingListScreen({Key? key, required this.hostId}) : super(key: key);

  @override
  _BookingListScreenState createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  List<Map<String, dynamic>> bookingsList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    try {
      // Fetch bookings for the logged-in host
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('hostId', isEqualTo: widget.hostId)
          .get();

      setState(() {
        bookingsList = snapshot.docs.map((doc) {
          var data = doc.data();
          data['docId'] = doc.id; // Store document ID for deletion
          return data;
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching bookings: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteBooking(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('bookings').doc(docId).delete();
      setState(() {
        bookingsList.removeWhere((booking) => booking['docId'] == docId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Booking deleted successfully")),
      );
    } catch (e) {
      print("Error deleting booking: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to delete booking")),
      );
    }
  }

  bool canDeleteBooking(String checkOutDate) {
    // Parse the check-out date and compare with the current date
    final DateTime currentDate = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final DateTime parsedCheckOutDate = formatter.parse(checkOutDate);

    final DateTime deleteAllowedDate = parsedCheckOutDate.add(const Duration(days: 1));
    // Return true if the current date is after the check-out date
    return currentDate.isAfter(deleteAllowedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookings"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : bookingsList.isEmpty
              ? const Center(child: Text('No bookings available.'))
              : ListView.builder(
                  itemCount: bookingsList.length,
                  itemBuilder: (context, index) {
                    final booking = bookingsList[index];
                    return BookingCard(
                      booking: booking,
                      onDelete: () => deleteBooking(booking['docId']),
                      canDelete: canDeleteBooking(booking['checkOutDate']), // Pass deletion condition
                    );
                  },
                ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;
  final VoidCallback onDelete;
  final bool canDelete; // Condition to allow deletion

  const BookingCard({
    Key? key,
    required this.booking,
    required this.onDelete,
    required this.canDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text("Booking ID: ${booking['bookingId']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 5),
            Text("Registered Guest Name: ${booking['fullName']}"),
            Text("No. of guests: ${booking['guests']}"),
            Text("No. of children: ${booking['children']}"),
            Text("Email: ${booking['email']}"),
            Text("Contact no.: ${booking['contactNumber']}"),
            Text("Alternate no.: ${booking['alternateNumber']}"),
            Text("Place: ${booking['selectedPlace']}"),
            Text("Check-in Date: ${booking['checkInDate']}"),
            Text("Check-out Date: ${booking['checkOutDate']}"),
            Text("Total Price: ₹${booking['totalAmount']}"),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ElevatedButton(
                //   onPressed: () {
                //     // Navigate to booking details page if needed
                //   },
                //   child: const Text("View Details"),
                // ),
                IconButton(
                  icon: Icon(Icons.delete, color: canDelete ? Colors.red : Colors.grey),
                  onPressed: canDelete
                      ? () async {
                          final confirmDelete = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Confirm Delete"),
                              content: const Text("Are you sure you want to delete this booking?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: const Text("Delete"),
                                ),
                              ],
                            ),
                          );
                          if (confirmDelete == true) {
                            onDelete(); // Call the delete function
                          }
                        }
                      : null, // Disable delete if check-out date hasn't passed
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
