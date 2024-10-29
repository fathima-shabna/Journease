import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:journease/usermodule/screens/hotelontap.dart';

class HotelBookingHomePage extends StatelessWidget {
  final String selectedPlace;
  final String checkInDate;
  final String checkOutDate;
  final int rooms;
  final int guests;
  final int children;

  const HotelBookingHomePage({
    super.key,
    required this.selectedPlace,
    required this.checkInDate,
    required this.checkOutDate,
    required this.rooms,
    required this.guests,
    required this.children,
  });

  Future<List<Map<String, dynamic>>> fetchAllProperties() async {
    List<Map<String, dynamic>> allProperties = [];

    try {
      // Use collectionGroup to fetch all properties across all users
      QuerySnapshot propertySnapshot = await FirebaseFirestore.instance
          .collectionGroup('properties') // Fetch properties from all users
          .where('approvalStatus', isEqualTo: 'approved')
          .get();

      // Loop through all the documents and extract the data
      for (var doc in propertySnapshot.docs) {
        Map<String, dynamic> propertyData = doc.data() as Map<String, dynamic>;
         propertyData['propertyId'] = doc.id;
        allProperties.add(propertyData);
      }
    } catch (e) {
      print('Error fetching properties: $e');
    }

    return allProperties; // Return the list of properties
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 218, 224, 230),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  selectedPlace,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.edit, color: Colors.blue, size: 18),
                ),
              ],
            ),
            Text(
              "$checkInDate - $checkOutDate, $rooms Room, $guests Guests",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(10),
          child: Container(
            color: Colors.grey[300],
            height: 2,
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchAllProperties(), // Fetch all properties
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No properties found'));
          }

          final properties = snapshot.data!;

          // Filter based on selectedPlace if it's not empty, otherwise show all properties
          List<Map<String, dynamic>> filteredProperties;
          if (selectedPlace.isNotEmpty) {
            String filterCity = selectedPlace.split(',').first.trim().toLowerCase();
            filteredProperties = properties.where((property) {
              final city = property['city']?.toString().toLowerCase() ?? '';
              return city.contains(filterCity);
            }).toList();
          } else {
            filteredProperties = properties; // Show all properties if selectedPlace is empty
          }

          if (filteredProperties.isEmpty) {
            filteredProperties = properties; // If no filtered properties, fall back to all
          }

          return ListView.builder(
            itemCount: filteredProperties.length,
            itemBuilder: (context, index) {
              final propertyData = filteredProperties[index];
              return InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HotelDetailPage(
                      propertyId: filteredProperties[index]['propertyId'],
                      propertyName: filteredProperties[index]['propertyName'],
                      propertyCity: filteredProperties[index]['city'],
                      checkInDate: checkInDate,
                      checkOutDate: checkOutDate,
                      selectedPlace: selectedPlace,
                      rooms: rooms,
                      guests: guests,
                      children: children,
                    ),
                  ),
                ),
                child: HotelCard(
                  propertyName: propertyData['propertyName'] ?? 'N/A',
                  description: propertyData['description'] ?? 'N/A',
                  address: propertyData['address'],
                  city: propertyData['city'],
                  additionalDetails: propertyData['attractions'] ?? 'N/A',
                  imageUrl: propertyData['images'] ?? ['https://example.com/default_image.png'],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Hotel Card Widget
class HotelCard extends StatelessWidget {
  final String propertyName;
  final String description;
  final String address;
  final String city;
  final String additionalDetails;
  final List<dynamic> imageUrl;

  const HotelCard({
    Key? key,
    required this.propertyName,
    required this.description,
    required this.additionalDetails,
    required this.imageUrl,
    required this.address,
    required this.city,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                imageUrl.isNotEmpty ? imageUrl[0] : 'https://example.com/default_image.png',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    propertyName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(description, style: TextStyle(color: Colors.black)),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.red[700]),
                      Text(address + ", " + city, style: TextStyle(color: Colors.black)),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(additionalDetails, style: TextStyle(color: Colors.orange)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
