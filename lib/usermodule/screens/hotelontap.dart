import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:journease/usermodule/screens/selectroom.dart';

class HotelDetailPage extends StatefulWidget {
  final String propertyId;
  final String propertyName;
  final String propertyCity;
  final String selectedPlace;
  final String checkInDate;
  final String checkOutDate;
  final int rooms;
  final int guests;
  final int children;

  const HotelDetailPage({
    Key? key,
    required this.propertyId,
    required this.selectedPlace,
    required this.checkInDate,
    required this.checkOutDate,
    required this.rooms,
    required this.guests,
    required this.children, 
    required this.propertyName, 
    required this.propertyCity,
  }) : super(key: key);

  @override
  _HotelDetailPageState createState() => _HotelDetailPageState();
}

class _HotelDetailPageState extends State<HotelDetailPage> {
  Map<String, dynamic>? propertyData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPropertyDetails();
  }

  Future<void> fetchPropertyDetails() async {
    try {
      // Fetch the specific property using propertyId from Firestore
      DocumentSnapshot<Map<String, dynamic>> propertySnapshot = await FirebaseFirestore.instance
          .collectionGroup('properties')
          .where('propertyId', isEqualTo: widget.propertyId)
          .get()
          .then((snapshot) => snapshot.docs.first);

      if (propertySnapshot.exists) {
        setState(() {
          propertyData = propertySnapshot.data();
          isLoading = false;
        });
      } else {
        print("Property does not exist.");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching property details: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 218, 224, 230),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : propertyData == null
              ? const Center(child: Text('Property not found'))
              : Column(
                  children: [
                    // Image carousel with property photos
                    Image.network(
                      propertyData?['images'][0] ?? 'default_image_url', // Replace with actual image URL from Firestore
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    // Hotel Information
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16.0),
                        children: [
                          Text(
                            propertyData?['propertyName'] ?? 'Property Name',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Icon(Icons.location_pin, color: Colors.red),
                              Expanded(
                                child: Text(
                                  propertyData?['address']+", "+propertyData!['city']+", "+propertyData!['country'] ?? 'Property Address',
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Check-in: ${propertyData?['checkInTime'] ?? "N/A"} • Check-out: ${propertyData?['checkOutTime'] ?? "N/A"}',
                                style: const TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.calendar_today, size: 16, color: Colors.black),
                                  label: Text(
                                    '${widget.checkInDate} - ${widget.checkOutDate}',
                                    style: const TextStyle(color: Colors.black,fontSize: 16),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.person, size: 16, color: Colors.black),
                                  label: Text(
                                    '${widget.guests} Guests /${widget.children} children/ ${widget.rooms} Room',
                                    style: const TextStyle(color: Colors.black,fontSize: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Divider(height: 20),
                          // About This Property Section
                          Card(
                            color: Colors.white,
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'About This Property',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      decorationStyle: TextDecorationStyle.double,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    propertyData?['description'] ?? 'Property Description',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Card(
                            color: Colors.white,
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Amenities',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      decorationStyle: TextDecorationStyle.double,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    propertyData?['amenities'] ?? 'Amenities list',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Card(
                            color: Colors.white,
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Property Highlights',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      decorationStyle: TextDecorationStyle.double,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    propertyData?['attractions'] ?? 'Property Highlights',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Card(
                          //   color: Colors.white,
                          //   elevation: 2,
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(8.0),
                          //     child: Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         const Text(
                          //           'Property Rules & Information',
                          //           style: TextStyle(
                          //             fontWeight: FontWeight.bold,
                          //             decoration: TextDecoration.underline,
                          //             decorationStyle: TextDecorationStyle.double,
                          //           ),
                          //         ),
                          //         const SizedBox(height: 10),
                          //         Text(
                          //           propertyData?['rules'] ?? 'Property Rules',
                          //           style: const TextStyle(color: Colors.grey),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          // const SizedBox(height: 5),
                        ],
                      ),
                    ),
                    // Price and Check Availability Button
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Column(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     Text(
                          //       '₹ ${propertyData?['price'] ?? '25,000'}',
                          //       style: const TextStyle(
                          //         fontWeight: FontWeight.bold,
                          //         fontSize: 20,
                          //         color: Colors.black,
                          //       ),
                          //     ),
                          //     const SizedBox(width: 10),
                          //     const Text('+ ₹ 4500 taxes & service fees', style: TextStyle(color: Colors.grey)),
                          //   ],
                          // ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>  HotelSelectionScreen(
                                      propertyId: widget.propertyId,
                                      propertyName: widget.propertyName,
                                      propertyCity: widget.propertyCity,
                                      selectedPlace: widget.selectedPlace,
                                      checkInDate: widget.checkInDate,
                                      checkOutDate: widget.checkOutDate,
                                      rooms: widget.rooms,
                                      guests: widget.guests,
                                      children: widget.children,),
                                  ),
                                );
                              },
                              child: const Text('SELECT ROOMS', style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: const Color.fromARGB(255, 222, 121, 90),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
