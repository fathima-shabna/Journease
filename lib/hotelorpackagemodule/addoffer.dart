import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddOfferPage extends StatefulWidget {
  final String hostId; // Host ID to manage offers

  const AddOfferPage({Key? key, required this.hostId}) : super(key: key);

  @override
  _AddOfferPageState createState() => _AddOfferPageState();
}

class _AddOfferPageState extends State<AddOfferPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  
  List<Offer> addedOffers = []; // Store added offers
  String? selectedOfferType; // Variable to hold selected offer type
  String? offerDescription; // Variable to hold offer description
  bool showOfferFields = false; // Toggle for showing offer fields

  // List of offer types
  final List<String> offerTypes = [
    'Hotels',
    'Resorts',
    'Apartments',
    'Packages',
  ];

  @override
  void initState() {
    super.initState();
    _fetchOffers(); // Fetch existing offers on page load
  }

  Future<void> _fetchOffers() async {
  try {
    print("Fetching offers for hostId: ${widget.hostId}");
    QuerySnapshot offerSnapshot = await FirebaseFirestore.instance
        .collection('offers')
        .where('hostId', isEqualTo: widget.hostId)
        .get();

    if (offerSnapshot.docs.isEmpty) {
      print("No offers found for this hostId.");
    }

    addedOffers = offerSnapshot.docs.map((doc) {
      return Offer(
        id: doc.id,
        imageUrl: doc['imageUrl'],
        offerType: doc['offerType'],
        description: doc['description'], // Get description from Firestore
      );
    }).toList();
    setState(() {}); // Update UI
  } catch (e) {
    print("Error fetching offers: $e");
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error fetching offers: $e')));
  }
}


  Future<void> _pickImage(String offerType) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      String fileUrl = await _uploadFile(imageFile);
      await _saveOfferImage(fileUrl, offerType); // Save image URL to Firestore
      await _fetchOffers(); // Fetch updated list after adding new offer
    }
  }

  Future<String> _uploadFile(File file) async {
    String fileName = file.path.split('/').last;
    Reference ref = FirebaseStorage.instance.ref().child('offers/$fileName');
    await ref.putFile(file);
    return await ref.getDownloadURL(); // Get file URL
  }

  Future<void> _saveOfferImage(String imageUrl, String offerType) async {
    // Save the offer image URL and selected offer type to Firestore
    await FirebaseFirestore.instance.collection('offers').add({
      'hostId': widget.hostId,
      'imageUrl': imageUrl,
      'offerType': offerType, // Save the selected offer type
      'description': offerDescription ?? '', // Save the offer description
    });
  }

  Future<void> _deleteOffer(Offer offer) async {
    // Delete the image from Firestore
    QuerySnapshot offerSnapshot = await FirebaseFirestore.instance
        .collection('offers')
        .where('hostId', isEqualTo: widget.hostId)
        .where('imageUrl', isEqualTo: offer.imageUrl)
        .get();

    if (offerSnapshot.docs.isNotEmpty) {
      // Delete the Firestore document
      await offerSnapshot.docs.first.reference.delete();
    }

    // Delete the image from Firebase Storage
    Reference ref = FirebaseStorage.instance.refFromURL(offer.imageUrl);
    await ref.delete();

    // Remove the offer from the list
    setState(() {
      addedOffers.remove(offer);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Offer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showOfferFields = !showOfferFields; // Toggle offer fields
                });
              },
              child: Text(showOfferFields ? 'Cancel' : 'Add Offer'),
            ),
            if (showOfferFields) ...[
              SizedBox(height: 20),
              Text('Select Offer Type:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedOfferType,
                items: offerTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedOfferType = value; // Update selected offer type
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Choose offer type',
                ),
                validator: (value) => value == null ? 'Please select an offer type' : null,
              ),
              SizedBox(height: 20),
              TextField(
                onChanged: (value) {
                  offerDescription = value; // Capture the description input
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Add Description',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (selectedOfferType != null) {
                    _pickImage(selectedOfferType!); // Pick image for the selected offer type
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select an offer type first')));
                  }
                },
                child: Text('Add Image for Offer'),
              ),
            ],
            SizedBox(height: 20),
            Text('Added Offers:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(), // Disable scrolling for the inner list
              itemCount: addedOffers.length,
              itemBuilder: (context, index) {
                final offer = addedOffers[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    leading: Image.network(offer.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(offer.offerType),
                    subtitle: Text(offer.description), // Display the offer description
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteOffer(offer), // Delete the offer
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Offer {
  final String id;
  final String imageUrl;
  final String offerType;
  final String description; // New field for description

  Offer({this.id = '', required this.imageUrl, required this.offerType, required this.description});
}
