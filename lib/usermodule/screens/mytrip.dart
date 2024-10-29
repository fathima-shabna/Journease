import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class MyTrip extends StatefulWidget {
  const MyTrip({super.key});

  @override
  State<MyTrip> createState() => _MyTripState();
}

class _MyTripState extends State<MyTrip> {
    late String userId;
  bool isLoading = true;
  List<Map<String, dynamic>> bookings = [];

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }
    Future<void> fetchBookings() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Get the current user's ID
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        userId = currentUser.uid;

        // Fetch bookings from Firestore where userId matches the current user
        QuerySnapshot bookingSnapshot = await FirebaseFirestore.instance
            .collection('bookings')
            .where('userId', isEqualTo: userId)
            .get();

        // Process the bookings data
        setState(() {
          bookings = bookingSnapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
          isLoading = false;
        });
      }
    } catch (e) {
      // Handle errors
      print('Error fetching bookings: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 237, 184, 168),
      // backgroundColor: Color.fromARGB(255, 218, 224, 230),
      appBar: AppBar(
       
        backgroundColor: Color.fromARGB(255, 231, 234, 238),
        title: Text("My trips",style: TextStyle(fontWeight: FontWeight.w600),),
      centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()):
      ListView(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40,),
          bookings.isEmpty?
          Column(
            children: [
              Center(child: Text("No bookings yet",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),)),
              Text("Start exploring for your next trip"),
              SizedBox(height: 40),
            ],
          ): buildBookingList(),
              SizedBox(height: 60),
              SizedBox(
                height: 200,
                child: Container(
                  height: 350,
                  child: CarouselSlider(
                    options: CarouselOptions(
                  height: 600,
                  autoPlay: true,               // Enables automatic sliding
                  autoPlayInterval: Duration(seconds: 3), // Interval between slides
                  enlargeCenterPage: true,      // Enlarge the center slide
                  aspectRatio: 2.0,             // Aspect ratio of the slider
                  viewportFraction: 0.6,        // Fraction of the screen each slide takes
                ),
                    
                    items: [
                      buildCard('MOUNTAIN >', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRl9mmPDi-Wv0H85qRRj595nt4YTVXvIG3SMA&s'),
                      buildCard('ROMANTIC >', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRRbZDsOhpKF3Y0MckHN0pgWexbVpOD459vTA&s'),
                      buildCard('BEACH >', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSO1ISR5MWlYpu6HHP51IIAWISKmL2gdxkh0Q&s'),
                      buildCard('WEEKEND >', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTWMlDwwxqJ9AIqEDu_yR6OQsr-rFgPSq1IpQ&s')
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30,)
        ],
      ),
    );
  }

   Widget buildCard(String title, String imagePath) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Container(
        
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: NetworkImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.8),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


Widget buildBookingList() {
    return SizedBox(
      height: 300,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> booking = bookings[index];
          return buildBookingCard(booking);
        },
      ),
    );
  }

  // Build each booking card
  Widget buildBookingCard(Map<String, dynamic> booking) {
    Timestamp createdAtTimestamp = booking['createdAt'] ?? Timestamp.now(); // Default to current time if null
  DateTime createdAtDate = createdAtTimestamp.toDate(); // Convert to DateTime
  String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(createdAtDate);
    // String title = booking['propertyName'] ?? 'No Title'; // Example field
    String selectedPlace = booking['selectedPlace'] ?? 'No Place'; // Default image URL if none
    String selectedrooms = '${booking['rooms'].toString()} room(s)' ?? 'No rooms';
    String guests = '${booking['guests'].toString()} guest(s) and ${booking['children'].toString()} children' ?? 'No guests';   
    String checkInDate = booking['checkInDate'] ?? 'No Check-in Date';
    String checkOutDate = booking['checkOutDate'] ?? 'No Check-out Date';
    String totalAmount = booking['totalAmount'].toString() ?? 'No Amount';
    String createdAt = formattedDate ?? 'No Booking Date';

    return Card(
  margin: EdgeInsets.symmetric(vertical: 8.0), // Adjusted vertical margin
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  elevation: 4, // Subtle shadow for depth
  child: Container(
    padding: EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: Colors.white, // White background for a clean look
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Property name/title
        Text(
          selectedPlace,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),

        // Selected rooms
        _buildInfoBox('Rooms:', selectedrooms),
        _buildInfoBox('Guests:', guests),

        SizedBox(height: 2),

        // Check-in and check-out dates
        _buildInfoBox('Check-in:', checkInDate),
        _buildInfoBox('Check-out:', checkOutDate),

        SizedBox(height: 8),

        // Total amount
        Text(
          'Total Amount: $totalAmount',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 5),

        // Booking date
        Text(
          'Booking Date: $createdAt', // Use formatted date
          style: TextStyle(
            fontSize: 13,
            color: Colors.black54,
          ),
        ),
      ],
    ),
  ),
);
  }
  Widget _buildInfoBox(String label, String value) {
  return Container(
    margin: EdgeInsets.only(bottom: 5.0),
    padding: EdgeInsets.all(8.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey.shade300), // Border for info boxes
      color: Colors.grey.shade50, // Light grey background for info boxes
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.black87,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            color: Colors.black54,
          ),
        ),
      ],
    ),
  );
}

  }

