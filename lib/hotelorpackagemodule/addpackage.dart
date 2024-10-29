import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:journease/hotelorpackagemodule/ListPackage.dart';
import 'package:journease/hotelorpackagemodule/models/packageModel.dart';

class AddPackagePage extends StatefulWidget {
  final String hostId;

  const AddPackagePage({super.key, required this.hostId});

  @override
  _AddPackagePageState createState() => _AddPackagePageState();
}

class _AddPackagePageState extends State<AddPackagePage> {
  final TextEditingController nightsController = TextEditingController();
  final TextEditingController daysController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final List<TextEditingController> daySummaryControllers = [];
  final TextEditingController arrivalController = TextEditingController();
  final TextEditingController departureController = TextEditingController();
  final TextEditingController transportFromController = TextEditingController();
  final TextEditingController transportToController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController pricePerPersonController = TextEditingController();
  final TextEditingController offerPriceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController pricePerPerson1Controller = TextEditingController();
  final TextEditingController offerPrice1Controller = TextEditingController();

  List<String> airportCities = [
    'Delhi',
    'Mumbai',
    'Bangalore',
    'Chennai',
    'Kolkata',
    'Hyderabad',
    'Ahmedabad',
    'Pune',
    'Jaipur',
    'Goa',
    'Lucknow',
    'Guwahati',
    'Thiruvananthapuram',
    'Indore',
    'Nagpur',
  ];
  List<Map<String, dynamic>> flightDetailsList = [];
  void _addFlightDetails() {
    setState(() {
      flightDetailsList.add({
        'selectedAirport': '',
        'endingAirport' : '',
        'arrivalController': TextEditingController(),
        'departureController': TextEditingController(),
      });
    });
  }

  // Function to remove a specific flight detail
  void _removeFlightDetails(int index) {
    setState(() {
      flightDetailsList.removeAt(index);
    });
  }

  DateTime? startDate = DateTime.now(); // Variable to store the start date
   XFile? _image; // Variable to store the selected image
  final ImagePicker _picker = ImagePicker();
    // Function to pick an image
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image; // Store the selected image
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
    }
  }

  // Function to upload the image to Firebase Storage
  Future<String?> _uploadImage() async {
    if (_image == null) return null; // Return null if no image is selected

    try {
      String filePath = 'packages/${widget.hostId}/${_image!.name}';
      UploadTask uploadTask = FirebaseStorage.instance.ref(filePath).putFile(File(_image!.path));
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL(); // Get the image URL
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error uploading image: $e')));
      return null;
    }
  }

  // Add day summary controllers
  void addDaySummaryField() {
    if (startDate != null) {
      setState(() {
        daySummaryControllers.add(TextEditingController());
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select a start date first.'),
      ));
    }
  }

  // Remove day summary controllers
  void removeDaySummaryField(int index) {
    setState(() {
      daySummaryControllers.removeAt(index);
    });
  }

Future<void> savePackage() async {
  try {
    String hostId = FirebaseAuth.instance.currentUser!.uid;
    String? imageUrl = await _uploadImage();

    List<String> daySummaries = daySummaryControllers.map((controller) => controller.text).toList();
    List<Map<String, dynamic>> flightDetails = flightDetailsList.map((detail) {
      return {
        'selectedAirport': detail['selectedAirport'],
        'endingAirport': detail['selectedAirport'], // You need to define this in flightDetailsList
        'arrivalDetails': detail['arrivalController'].text,
        'departureDetails': detail['departureController'].text,
      };
    }).toList();

    // Create a new PackageModel instance with a temporary packageId
    PackageModel newPackage = PackageModel(
      packageId: '', // Initially empty
      hostId: hostId,
      nights: int.parse(nightsController.text),
      days: int.parse(daysController.text),
      title: titleController.text,
      destination: destinationController.text,
      description: descriptionController.text,
      daySummaries: daySummaries,
      // arrivalFlight: arrivalFlightController.text.isNotEmpty ? arrivalFlightController.text : null,
      // departureFlight: departureFlightController.text.isNotEmpty ? departureFlightController.text : null,
      transportFrom: transportFromController.text,
      transportTo: transportToController.text,
      pricePerPerson: double.parse(pricePerPersonController.text),
      offerPrice: double.parse(offerPriceController.text),
      pricePerPerson1: double.parse(pricePerPerson1Controller.text),
      offerPrice1: double.parse(offerPrice1Controller.text),
      createdAt: DateTime.now(),
      imageUrl: imageUrl, 
      startDate: DateTime.parse(startDateController.text),
      flightDetails: flightDetails
    );

    // Store the package in Firestore and retrieve the generated document ID
    DocumentReference docRef = await FirebaseFirestore.instance.collection('packages').add(newPackage.toMap());

    // Update the packageId with the generated document ID
    newPackage = newPackage.copyWith(packageId: docRef.id); // Use a copyWith method to create a new instance with updated packageId

    // Optionally, you can also update the Firestore document to include the packageId
    await docRef.update(newPackage.toMap());

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Package added successfully!')));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PackageListPage(hostId: hostId),));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error adding package: $e')));
  }
}


  // Function to select the start date
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != startDate) {
      setState(() {
        startDate = pickedDate;
        startDateController.text = DateFormat('yyyy-MM-dd').format(startDate!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Travel Package'),
        backgroundColor: Color.fromARGB(255, 222, 121, 90),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildTextField('Number of Nights', nightsController, TextInputType.number),
              buildTextField('Number of Days', daysController, TextInputType.number),
              buildTextField('Package Title', titleController, TextInputType.text),
              buildTextField('Destination', destinationController, TextInputType.text),
              buildTextField('Description', descriptionController, TextInputType.text),

              // Select Start Date
              GestureDetector(
                onTap: () => _selectStartDate(context),
                child: AbsorbPointer(
                  child: buildTextField('Start Date', startDateController, TextInputType.text),
                ),
              ),
               // Button to add new flight details fields
              ElevatedButton(
                onPressed: _addFlightDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 222, 121, 90),
                ),
                child: Text(
                  'Add Flight Details',
                  style: TextStyle(color: Colors.white),
                ),
              ),

              SizedBox(height: 10),

              // Display the list of flight details dynamically
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: flightDetailsList.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Flight Details ${index + 1}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),

                      // Dropdown for selecting airport city
                      DropdownButtonFormField<String>(
                        value: flightDetailsList[index]['selectedAirport'].isNotEmpty
                            ? flightDetailsList[index]['selectedAirport']
                            : null,
                        hint: Text('Select Airport'),
                        items: airportCities.map((city) {
                          return DropdownMenuItem(
                            value: city,
                            child: Text(city),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            flightDetailsList[index]['selectedAirport'] = newValue!;
                          });
                        },
                        style: TextStyle(fontSize: 13,color: Colors.black),
                        decoration: InputDecoration(          
          labelText: 'Starting from',
          labelStyle: TextStyle(fontSize: 12),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color.fromARGB(255, 222, 121, 90), width: 2),
          ),
        ),
                      ),

                      // Display the selected airport value
                      if (flightDetailsList[index]['selectedAirport'] != '')
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: TextField(
                  controller: TextEditingController(
                  text: flightDetailsList[index]['selectedAirport'],
                  ),
                  readOnly: true, // Make this field read-only
                 style: TextStyle(fontSize: 13),
                decoration: InputDecoration(          
          labelText: 'Ending destination',
          labelStyle: TextStyle(fontSize: 12),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color.fromARGB(255, 222, 121, 90), width: 2),
          ),
        ),
  ),
                        ),

                      SizedBox(height: 10),

                      // Text fields for flight details
                      buildTextField(
                        'Arrival Flight Details',
                        flightDetailsList[index]['arrivalController'],
                        TextInputType.text,
                      ),
                      buildTextField(
                        'Departure Flight Details',
                        flightDetailsList[index]['departureController'],
                        TextInputType.text,
                      ),

                      // Button to remove this flight detail section
                      TextButton(
                        onPressed: () => _removeFlightDetails(index),
                        child: Text(
                          'Remove Flight Details',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),

                      Divider(thickness: 1),
                    ],
                  );
                },
              ),


              // Day-wise summary fields with separate fields for day number and date
              Text(
                'Day-wise Summary',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15,),
              ...daySummaryControllers.asMap().entries.map((entry) {
                int index = entry.key;
                DateTime currentDay = startDate!.add(Duration(days: index)); // Increment the date for each day
                String formattedDate = DateFormat('yyyy-MM-dd').format(currentDay);

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Day Number
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: TextField(
                          enabled: false,
                          controller: TextEditingController(text: '${index+1}'),
                          style: TextStyle(fontSize: 12),
                          decoration: InputDecoration(
                            labelText: 'Day ${index + 1}',
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Date Field (Auto-incremented date)
                    Expanded(
                      flex: 2,
                      child: TextField(
                        enabled: false,
                        controller: TextEditingController(text: formattedDate),
                        style: TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                          labelText: 'Date',
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5,),
                    // Day Summary Field
                    Expanded(
                      flex: 3,
                      child: buildTextField('Summary', entry.value, TextInputType.text),
                    ),
                    // Remove button
                    IconButton(
                      icon: Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () => removeDaySummaryField(index),
                    ),
                  ],
                );
              }).toList(),
              ElevatedButton(
                onPressed: addDaySummaryField,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 222, 121, 90),
                ),
                child: Text('Add Day', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 20),

              // Flight and transportation fields (always visible)
              // Text('Flight Details (Optional)', style: TextStyle(fontWeight: FontWeight.bold)),
              // SizedBox(height: 10),
              // buildTextField('Arrival Flight Details', arrivalFlightController, TextInputType.text),
              // buildTextField('Departure Flight Details', departureFlightController, TextInputType.text),
              // SizedBox(height: 20),

              Text('Transportation Details', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              buildTextField('Transportation from Starting Point', transportFromController, TextInputType.text),
              buildTextField('Transportation to End Point', transportToController, TextInputType.text),

              // Price and offer price fields
              SizedBox(height: 20),
              Text('Price per person (With flight)', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              buildTextField('Price per Person', pricePerPersonController, TextInputType.number),
              buildTextField('Offer Price', offerPriceController, TextInputType.number),
              SizedBox(height: 20),
              Text('Price per person (Without flight)', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              buildTextField('Price per Person', pricePerPerson1Controller, TextInputType.number),
              buildTextField('Offer Price', offerPrice1Controller, TextInputType.number),
              SizedBox(height: 20),
              Text('Select Package Image', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 222, 121, 90),
                ),
                child: Text('Pick Image', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 10),
              if (_image != null)
                Image.file(File(_image!.path), height: 150, width: 150, fit: BoxFit.cover),

              SizedBox(height: 30),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: savePackage,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Color.fromARGB(255, 222, 121, 90),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Save Package',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, TextInputType inputType) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: 13),
        keyboardType: inputType,
        decoration: InputDecoration(          
          labelText: label,
          labelStyle: TextStyle(fontSize: 12),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color.fromARGB(255, 222, 121, 90), width: 2),
          ),
        ),
      ),
    );
  }
}
