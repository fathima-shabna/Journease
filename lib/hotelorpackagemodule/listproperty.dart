import 'package:flutter/material.dart';
import 'package:journease/hotelorpackagemodule/firebase/propertylistingfb.dart';
import 'package:journease/hotelorpackagemodule/models/propertyModel.dart';
import 'package:journease/hotelorpackagemodule/firebase/listprprty.dart';
import 'package:journease/hotelorpackagemodule/propertydetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:journease/hotelorpackagemodule/propertyview.dart';

class PropertyListPage extends StatefulWidget {
  final String hostId; // hostId passed to this page

  const PropertyListPage({super.key, required this.hostId}); // Mark hostId as required

  @override
  State<PropertyListPage> createState() => _PropertyListPageState();
}

class _PropertyListPageState extends State<PropertyListPage> {
  final GetToList getToList = GetToList();

  // Navigate to the property form page to add a new property
  Future<void> listNewProperty(BuildContext context) async {
    final propertyId = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PropertyListingPage(userId: widget.hostId), // Pass hostId here
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 218, 224, 230),
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 222, 121, 90),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => listNewProperty(context), // Button to list a new property
              child: Text(
                'List a Property',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<PropertyModel>>(
        stream: getToList.getPropertyListings(widget.hostId), // Pass the hostId to fetch host-specific properties
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final properties = snapshot.data!;

          return ListView.builder(
            itemCount: properties.length,
            itemBuilder: (context, index) {
              final property = properties[index];

              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  tileColor: Colors.white,
                  onTap: () {
                    // Ensure that property.id is not empty
                    if (property.propertyId.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PropertyDetailPage(userId: widget.hostId, property: property), // Pass hostId here
                        ),
                      );
                    } else {
                      print("Property ID is empty");
                    }
                  },
                  title: Text(
                    'Property name: ${property.propertyName}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('City: ${property.city}', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text('Type of Rooms: ${property.rooms.length}', style: TextStyle(fontWeight: FontWeight.w600)),
                      SizedBox(height: 4.0),
                      Text(
                        property.approvalStatus == ApprovalStatus.pending
                            ? 'Pending'
                            : property.approvalStatus == ApprovalStatus.approved
                                ? 'Approved'
                                : 'Rejected',
                        style: TextStyle(
                          color: property.approvalStatus == ApprovalStatus.pending
                              ? Colors.orange // Color for pending status
                              : property.approvalStatus == ApprovalStatus.approved
                                  ? Colors.green
                                  : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await getToList.deleteProperty(property.propertyName, widget.hostId); // Pass hostId to delete function
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${property.propertyName} deleted')),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
