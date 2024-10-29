import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:journease/hotelorpackagemodule/editproperty.dart';
import 'package:journease/hotelorpackagemodule/models/propertyModel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PropertyDetailPage extends StatefulWidget {
  final PropertyModel property;
  final String userId;

  PropertyDetailPage({required this.property, required this.userId});

  @override
  State<PropertyDetailPage> createState() => _PropertyDetailPageState();
}

class _PropertyDetailPageState extends State<PropertyDetailPage> {
  late PropertyModel property;

  @override
  void initState() {
    super.initState();
    property = widget.property;
    _loadPropertyDetails();
  }

  Future<void> _loadPropertyDetails() async {
    final propertyRef = FirebaseFirestore.instance
        .collection('properties')
        .doc(widget.property.propertyId);
    final propertyData = await propertyRef.get();

    if (propertyData.exists) {
      setState(() {
        property = PropertyModel.fromMap(propertyData.data()!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color mainColor = Color.fromARGB(255, 222, 121, 90);
    Color lightColor = mainColor.withOpacity(0.5);
    Color darkColor = mainColor.withOpacity(0.8);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.property.propertyName),
        backgroundColor: mainColor,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditPropertyListingPage(
                    propertyId: widget.property.propertyId,
                    userId: widget.userId,
                  ),
                ),
              ).then((updatedProperty) {
                if (updatedProperty != null) {
                  setState(() {
                    property = updatedProperty;
                  });
                }
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [lightColor, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 8,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.property.propertyName,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: darkColor,
                          ),
                        ),
                        SizedBox(height: 8),
                        _buildDetailRow(
                          FontAwesomeIcons.circleInfo,
                          'Description',
                          widget.property.description,
                          lightColor,
                        ),
                        _buildDetailRow(
                          FontAwesomeIcons.idCard,
                          'License',
                          widget.property.license,
                          Colors.orange.shade100,
                        ),
                        _buildDetailRow(
                          FontAwesomeIcons.locationDot,
                          'Address',
                          '${widget.property.address}, ${widget.property.city}, ${widget.property.country}',
                          Colors.orange.shade200,
                        ),
                        _buildDetailRow(
                          FontAwesomeIcons.clock,
                          'Check-in',
                          widget.property.checkInTime,
                          lightColor,
                        ),
                        _buildDetailRow(
                          FontAwesomeIcons.clock,
                          'Check-out',
                          widget.property.checkOutTime,
                          Colors.orange.shade100,
                        ),
                        _buildDetailRow(
                          FontAwesomeIcons.bellConcierge,
                          'Amenities',
                          widget.property.amenities,
                          Colors.orange.shade200,
                        ),
                        _buildDetailRow(
                          FontAwesomeIcons.streetView,
                          'Attractions',
                          widget.property.attractions,
                          lightColor,
                        ),
                        _buildDetailRow(
                          FontAwesomeIcons.rectangleList,
                          'Category',
                          widget.property.category,
                          Colors.orange.shade100,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Image Gallery:',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: darkColor),
                ),
                SizedBox(height: 8),
                _buildImageGallery(widget.property.images),
                SizedBox(height: 16),
                Text(
                  'Available Rooms:',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: darkColor),
                ),
                ...widget.property.rooms.map((room) {
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            room.title,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: darkColor),
                          ),
                          SizedBox(height: 4),
                          _buildDetailRow(
                            FontAwesomeIcons.rulerCombined,
                            'Size',
                            room.size,
                            lightColor,
                          ),
                          _buildDetailRow(
                            FontAwesomeIcons.eye,
                            'View',
                            room.view,
                            Colors.orange.shade100,
                          ),
                          _buildDetailRow(
                            FontAwesomeIcons.bed,
                            'Bed Type',
                            room.bedType,
                            Colors.orange.shade200,
                          ),
                          _buildDetailRow(
                            FontAwesomeIcons.bed,
                            'Room Type',
                            room.roomType,
                            lightColor,
                          ),
                          _buildDetailRow(
                            FontAwesomeIcons.dollarSign,
                            'Price',
                            '\$${room.price}',
                            Colors.orange.shade100,
                          ),
                          _buildDetailRow(
                            FontAwesomeIcons.circleInfo,
                            'Description',
                            room.description,
                            Colors.orange.shade200,
                          ),
                          _buildDetailRow(
                            FontAwesomeIcons.tags,
                            'Offer',
                            room.offer,
                            lightColor,
                          ),
                          _buildDetailRow(
                            FontAwesomeIcons.fileLines,
                            'Details',
                            room.details,
                            Colors.orange.shade100,
                          ),
                          _buildDetailRow(
                            FontAwesomeIcons.circleCheck,
                            'Free Cancellation',
                            room.freeCancellation,
                            Colors.orange.shade200,
                          ),
                          if (room.freeCancellationDate != null)
                            _buildDetailRow(
                              FontAwesomeIcons.calendarCheck,
                              'Cancellation Date',
                              room.freeCancellationDate!,
                              lightColor,
                            ),
                          _buildDetailRow(
                            FontAwesomeIcons.hotel,
                            'Number of Rooms',
                            room.numberOfRooms.toString(),
                            Colors.orange.shade100,
                          ),
                          _buildDetailRow(
                            FontAwesomeIcons.hotel,
                            'Available Rooms',
                            room.availableRooms.toString(),
                            Colors.orange.shade200,
                          ),
                          if (room.imageUrl != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: Image.network(room.imageUrl!),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      IconData icon, String title, String detail, Color bgColor) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Color.fromARGB(255, 222, 121, 90), size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color.fromARGB(255, 222, 121, 90)),
                ),
                Text(
                  detail,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery(List<String> images) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Container(
            width: 150,
            margin: EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(images[index]),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
