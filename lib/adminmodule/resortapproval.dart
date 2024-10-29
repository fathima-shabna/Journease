import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:journease/hotelorpackagemodule/models/propertyModel.dart';

class HostApprovalPage extends StatefulWidget {
  @override
  _HostApprovalPageState createState() => _HostApprovalPageState();
}

class _HostApprovalPageState extends State<HostApprovalPage> {
  List<PropertyModel> pendingProperties = [];
  bool isLoading = true;
  String hostId='';

  @override
  void initState() {
    super.initState();
    _fetchPendingProperties();
  }

 Future<void> _fetchPendingProperties() async {
  try {
    QuerySnapshot<Map<String, dynamic>> propertiesSnapshot = await FirebaseFirestore.instance
        .collectionGroup('properties')
        .where('approvalStatus', isEqualTo: 'pending')
        .get();

    setState(() {
      pendingProperties = propertiesSnapshot.docs
          .map((doc) => PropertyModel.fromMap(doc.data()))  // Assuming fromMap works for the doc data
          .toList();
      isLoading = false;
    });
  } catch (e) {
    print("Error fetching pending properties: $e");
    setState(() {
      isLoading = false;
    });
  }
}
  Future<void> _approveProperty(String userId, String propertyId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('properties')
          .doc(propertyId)
          .update({
        'approvalStatus': 'approved',
      });
      // Refresh the list
      _fetchPendingProperties();
    } catch (e) {
      print("Error approving property: $e");
    }
  }

  Future<void> _rejectProperty(String userId, String propertyId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('properties')
          .doc(propertyId)
          .delete();
      // Refresh the list
      _fetchPendingProperties();
    } catch (e) {
      print("Error rejecting property: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Host Approval"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : pendingProperties.isEmpty
              ? Center(child: Text('No pending properties.'))
              : ListView.builder(
                  itemCount: pendingProperties.length,
                  itemBuilder: (context, index) {
                    final property = pendingProperties[index];
                    return PropertyCard(
                      property: property,
                      onApprove: (userId, propertyId) =>
                          _approveProperty(userId, property.propertyId),
                      onReject: (userId, propertyId) =>
                          _rejectProperty(userId, property.propertyId),
                    );
                  },
                ),
    );
  }
}

class PropertyCard extends StatelessWidget {
  final PropertyModel property;
  final Function(String userId, String propertyId) onApprove;
  final Function(String userId, String propertyId) onReject;

  const PropertyCard({
    Key? key,
    required this.property,
    required this.onApprove,
    required this.onReject,
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
            Text("Property Name: ${property.propertyName}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Description: ${property.description}"),
            Text("License: ${property.license}"),
            Text("Address: ${property.address}, ${property.city}, ${property.country}"),
            Text("Check-in: ${property.checkInTime}"),
            Text("Check-out: ${property.checkOutTime}"),
            Text("Amenities: ${property.amenities}"),
            Text("Attractions: ${property.attractions}"),
            Text("Category: ${property.category}"),
            SizedBox(height: 10),
            Text("Available Rooms:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              // Display property images in a horizontal scrollable list
  if (property.images != null && property.images.isNotEmpty)
    SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: property.images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              property.images[index],  // URL of the image
              height: 150,
              width: 150,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    )
  else
    Text("No images available."),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: property.rooms.length,
              itemBuilder: (context, roomIndex) {
                final room = property.rooms[roomIndex];
                return RoomCard(room: room);
              },
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => onApprove(property.hostId, property.propertyId), // Pass userId
                  child: Text("Approve"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => onReject(property.hostId, property.propertyId), // Pass userId
                  child: Text("Reject"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RoomCard extends StatelessWidget {
  final RoomModel room;

  const RoomCard({Key? key, required this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(room.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text("Size: ${room.size}"),
            Text("View: ${room.view}"),
            Text("Bed Type: ${room.bedType}"),
            Text("Room Type: ${room.roomType}"),
            Text("Details: ${room.details}"),
            Text("Price: \$${room.price}"),
            Text("Description: ${room.description}"),
            if (room.imageUrl != null)
              Image.network(room.imageUrl!, height: 100, fit: BoxFit.cover),
          ],
        ),
      ),
    );
  }
}
