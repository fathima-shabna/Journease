import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:journease/usermodule/screens/hotelpayment.dart';
import 'package:uuid/uuid.dart';

class ReviewBookingPage extends StatefulWidget {
  final String propertyId;
  final String propertyName;
  final String propertyCity;
  final String selectedRoomPrice;
  final String selectedPlace;
  final String checkInDate;
  final String checkOutDate;
  final int rooms;
  final int guests;
  final int children;
  final String roomtitle;

  const ReviewBookingPage({
    Key? key,
    required this.propertyId,
    required this.selectedPlace,
    required this.checkInDate,
    required this.checkOutDate,
    required this.rooms,
    required this.guests,
    required this.children,
    required this.selectedRoomPrice, required this.roomtitle, required this.propertyName, required this.propertyCity,
  }) : super(key: key);

  @override
  _ReviewBookingPageState createState() => _ReviewBookingPageState();
}

class _ReviewBookingPageState extends State<ReviewBookingPage> {
  // Controllers for form fields
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController alternateNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool bookingForSelf = true;
  String? selectedGender;
  String? bookingId;
  String? fetchedHostId;

  @override
  void initState() {
    super.initState();
    // Generate a booking ID using uuid
    bookingId = Uuid().v4();
    getHostIdByPropertyId();
  }

  @override
  Widget build(BuildContext context) {
    // Convert check-in and check-out dates to DateTime objects
    DateTime checkIn = DateTime.parse(widget.checkInDate);
    DateTime checkOut = DateTime.parse(widget.checkOutDate);

    // Calculate the number of nights
    int totalNights = checkOut.difference(checkIn).inDays;

    // Price calculation
    double basePrice = double.parse(widget.selectedRoomPrice); // Price per room per night
    totalNights = totalNights > 0 ? totalNights : 1; // Ensure at least 1 night
    double hotelTaxes = 1160; // Fixed taxes for simplicity
    double totalAmount = (widget.rooms * basePrice * totalNights) + hotelTaxes;
    double priceBeforeTax = widget.rooms * basePrice * totalNights;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 218, 224, 230),
      appBar: AppBar(
        title: Text(
          'Review Booking',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 14),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1.0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Add form key for validation
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Price Breakup Section
              _buildPriceBreakup(totalAmount, priceBeforeTax, hotelTaxes, totalNights),
              SizedBox(height: 16),

              // Booking Information Section
              _buildBookingInfoSection(),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(totalAmount),
    );
  }

  Widget _buildPriceBreakup(double totalAmount, double priceBeforeTax, double hotelTaxes, int totalNights) {
    return Card(
      elevation: 4,
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Price Breakup", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${widget.rooms} Room(s) x ${totalNights} night\nBase Price"),
                Text(priceBeforeTax.toStringAsFixed(2)),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text("Hotel Taxes"),
                    Icon(Icons.info_outline, size: 16),
                  ],
                ),
                Text(hotelTaxes.toStringAsFixed(2)),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Amount to be paid", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("₹${totalAmount.toStringAsFixed(2)}", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingInfoSection() {
    return Card(
      elevation: 4,
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Contact Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 15),
            _bookingDetails(),
          ],
        ),
      ),
    );
  }

  Widget _bookingDetails() {
    return Column(
      children: [
        _buildNameFields(),
        SizedBox(height: 8),
        _buildGenderDropdown(),
        _buildContactField(),
      ],
    );
  }

  Widget _buildNameFields() {
    return TextFormField(
      controller: fullNameController,
      decoration: InputDecoration(
        labelText: "Full Name",
        labelStyle: TextStyle(fontSize: 12),
        isCollapsed: true,
        contentPadding: EdgeInsets.all(12),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your full name';
        }
        return null;
      },
    );
  }

  Widget _buildContactField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        TextFormField(
          controller: contactNumberController,
          decoration: InputDecoration(
            labelText: "Contact Number",
            labelStyle: TextStyle(fontSize: 12),
            isCollapsed: true,
            contentPadding: EdgeInsets.all(12),
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your contact number';
            }
            return null;
          },
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: alternateNumberController,
          decoration: InputDecoration(
            labelText: "Alternate Number",
            labelStyle: TextStyle(fontSize: 12),
            isCollapsed: true,
            contentPadding: EdgeInsets.all(12),
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your contact number';
            }
            return null;
          },
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: "Email ID",
            labelStyle: TextStyle(fontSize: 12),
            isCollapsed: true,
            contentPadding: EdgeInsets.all(12),
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email ID';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedGender,
      decoration: InputDecoration(
        labelText: 'Gender',
        labelStyle: TextStyle(fontSize: 12),
        isCollapsed: true,
        contentPadding: EdgeInsets.all(12),
        border: OutlineInputBorder(),
      ),
      onChanged: (String? newValue) {
        setState(() {
          selectedGender = newValue;
        });
      },
      items: <String>['Mr.', 'Mrs.', 'Miss'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select a gender';
        }
        return null;
      },
    );
  }

  Widget _buildBottomBar(double totalAmount) {
    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("₹${totalAmount.toStringAsFixed(2)}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text("Incl. of taxes & fees", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, overflow: TextOverflow.ellipsis)),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 222, 121, 90)),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                
              // _saveBookingDetails(totalAmount);
              Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentPage(totalAmount: totalAmount,onPaymentSuccess: _saveBookingDetails,hostId: fetchedHostId!,),));
              }
            },
            child: Text("CONTINUE", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      ),
    );
  }

Future<void> getHostIdByPropertyId() async {
  try {
    QuerySnapshot propertiesSnapshot = await FirebaseFirestore.instance
        .collectionGroup('properties')
        .where('propertyId', isEqualTo: widget.propertyId)
        .get();

   
// Check if any documents were found
if (propertiesSnapshot.docs.isNotEmpty) {
  // Get the first document that matches the query
  DocumentSnapshot propertyDoc = propertiesSnapshot.docs.first;

  // Extract the hostId from the document
  String hostId = propertyDoc['hostId'];
  if (hostId!=null) {
    setState(() {
      fetchedHostId = hostId;
    });
  }

  print('Host ID: $hostId');
} else {
  print('No property found with the given propertyId.');
}
  } catch (e) {
    print('Error fetching hostId: $e');
  }
}




// Save booking details to Firestore
Future<void> _saveBookingDetails(double totalAmount) async {
  try {
    // Fetch the hostId before saving the booking details
    await getHostIdByPropertyId(); 

    // Ensure hostId is fetched successfully
    if (fetchedHostId == null) {
      print('Host ID not found, cannot proceed with booking.');
      return;
    }
  final user = FirebaseAuth.instance.currentUser;
  // String? hostId1 =fetchedHostId;
  if (user != null && fetchedHostId != null) {
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingId)
        .set({
      'propertyId': widget.propertyId,
      'hostId': fetchedHostId,
      'userId' : user.uid,
      'selectedPlace': "${widget.propertyName}, ${widget.propertyCity}",
      'checkInDate': widget.checkInDate,
      'checkOutDate': widget.checkOutDate,
      'rooms': widget.rooms,
      'guests': widget.guests,
      'children': widget.children,
      'fullName': fullNameController.text,
      'contactNumber': contactNumberController.text,
      'alternateNumber': alternateNumberController.text,
      'email': emailController.text,
      'gender': selectedGender,
      'totalAmount': totalAmount,
      'bookingId': bookingId, // Save the bookingId in Firestore
      'createdAt': Timestamp.now(),
    });

    // Decrement available rooms after saving booking details
    _decrementAvailableRooms(widget.propertyId, widget.rooms);
  }
}catch(e){
  print("error $e");
}

}
Future<void> _decrementAvailableRooms(String propertyId, int roomsBooked) async {
  // String? hostId = getHostIdByPropertyId();
  if (fetchedHostId != null) {
    // Get the specific property document reference
    final propertyRef = FirebaseFirestore.instance
        .collection('users')
        .doc(fetchedHostId)
        .collection('properties')
        .doc(propertyId);

    // Fetch the property data to locate the specific room
    DocumentSnapshot propertySnapshot = await propertyRef.get();
    if (propertySnapshot.exists) {
      // Assuming rooms are stored as a list of maps in the property document
      List<dynamic> roomList = propertySnapshot['rooms'];

      // Find the room that matches the selected room (use appropriate condition)
      for (var room in roomList) {
        // Replace this condition with the actual logic to select the correct room
        if (room['title'] == widget.roomtitle) {
          // Decrement the available rooms for the selected room
          int availableRooms = room['availableRooms'];
          availableRooms = availableRooms - roomsBooked;

          // Ensure that the availableRooms count does not go below zero
          if (availableRooms < 0) {
            availableRooms = 0;
          }

          // Update the room with the new availableRooms value
          room['availableRooms'] = availableRooms;

          // Update the property document with the modified rooms list
          await propertyRef.update({
            'rooms': roomList,
          });

          break; // Exit the loop once the room is found and updated
        }
      }
    }
  }
}
}