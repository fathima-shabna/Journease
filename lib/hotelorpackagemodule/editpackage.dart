import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:journease/hotelorpackagemodule/models/packageModel.dart';

class EditPackagePage extends StatefulWidget {
  final String hostId;
  final PackageModel package;

  const EditPackagePage({Key? key, required this.package, required this.hostId}) : super(key: key);

  @override
  _EditPackagePageState createState() => _EditPackagePageState();
}

class _EditPackagePageState extends State<EditPackagePage> {
  late TextEditingController nightsController;
  late TextEditingController daysController;
  late TextEditingController titleController;
  late TextEditingController destinationController;
  late TextEditingController startDateController;
  late TextEditingController pricePerPersonController;
  late TextEditingController offerPriceController;
  late TextEditingController descriptionController;
  late TextEditingController pricePerPerson1Controller;
  late TextEditingController offerPrice1Controller;

  List<TextEditingController> daySummaryControllers = [];
  List<Map<String, dynamic>> flightDetailsList = [];
  List<String> airportCities = [
    'Delhi', 'Mumbai', 'Bangalore', 'Chennai', 'Kolkata',
    'Hyderabad', 'Ahmedabad', 'Pune', 'Jaipur', 'Goa',
    'Lucknow', 'Guwahati', 'Thiruvananthapuram', 'Indore', 'Nagpur',
  ];

  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  DateTime? startDate;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with the package data
    nightsController = TextEditingController(text: widget.package.nights.toString());
    daysController = TextEditingController(text: widget.package.days.toString());
    titleController = TextEditingController(text: widget.package.title);
    destinationController = TextEditingController(text: widget.package.destination);
    startDateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(widget.package.startDate));
    pricePerPersonController = TextEditingController(text: widget.package.pricePerPerson.toString());
    offerPriceController = TextEditingController(text: widget.package.offerPrice.toString());
    descriptionController = TextEditingController(text: widget.package.description);
    pricePerPerson1Controller = TextEditingController(text: widget.package.pricePerPerson1.toString());
    offerPrice1Controller = TextEditingController(text: widget.package.offerPrice1.toString());

    // Initialize day summaries
    widget.package.daySummaries.forEach((summary) {
      daySummaryControllers.add(TextEditingController(text: summary));
    });

    // Initialize flight details
    flightDetailsList = widget.package.flightDetails.map((detail) {
      return {
        'selectedAirport': detail['selectedAirport'],
        'endingAirport': detail['endingAirport'],
        'arrivalController': TextEditingController(text: detail['arrivalDetails']),
        'departureController': TextEditingController(text: detail['departureDetails']),
      };
    }).toList();

    startDate = widget.package.startDate;
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
    }
  }

  Future<String?> _uploadImage(String? currentImageUrl) async {
    if (_image == null) return currentImageUrl;

    try {
      String filePath = 'packages/${widget.package.hostId}/${_image!.name}';
      UploadTask uploadTask = FirebaseStorage.instance.ref(filePath).putFile(File(_image!.path));
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error uploading image: $e')));
      return currentImageUrl;
    }
  }

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

  Future<void> savePackage() async {
    try {
      String? imageUrl = await _uploadImage(widget.package.imageUrl);

      List<String> daySummaries = daySummaryControllers.map((controller) => controller.text).toList();
      List<Map<String, dynamic>> flightDetails = flightDetailsList.map((detail) {
        return {
          'selectedAirport': detail['selectedAirport'],
          'endingAirport': detail['endingAirport'],
          'arrivalDetails': detail['arrivalController'].text,
          'departureDetails': detail['departureController'].text,
        };
      }).toList();

      PackageModel updatedPackage = PackageModel(
        packageId: widget.package.packageId,
        hostId: widget.package.hostId,
        nights: int.parse(nightsController.text),
        days: int.parse(daysController.text),
        title: titleController.text,
        destination: destinationController.text,
        description: descriptionController.text,
        daySummaries: daySummaries,
        pricePerPerson: double.parse(pricePerPersonController.text),
        offerPrice: double.parse(offerPriceController.text),
        pricePerPerson1: double.parse(pricePerPerson1Controller.text),
        offerPrice1: double.parse(offerPrice1Controller.text),
        createdAt: widget.package.createdAt,
        imageUrl: imageUrl,
        startDate: DateTime.parse(startDateController.text),
        flightDetails: flightDetails,
        transportFrom: widget.package.transportFrom,
        transportTo: widget.package.transportTo
      );

      await FirebaseFirestore.instance
          .collection('packages')
          .doc(widget.package.packageId)
          .update(updatedPackage.toMap());

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Package updated successfully!')));
      Navigator.pop(context); // Return to previous screen after update
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating package: $e')));
    }
  }

  Widget buildTextField(String label, TextEditingController controller, TextInputType inputType) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
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

  void _addDaySummary() {
    setState(() {
      daySummaryControllers.add(TextEditingController());
    });
  }
    void _deleteDaySummary(int index) {
    setState(() {
      daySummaryControllers.removeAt(index);
    });
  }

  void _addFlightDetail() {
    setState(() {
      flightDetailsList.add({
        'selectedAirport': null,
        'endingAirport': null,
        'arrivalController': TextEditingController(),
        'departureController': TextEditingController(),
      });
    });
  }
 void _deleteFlightDetail(int index) {
    setState(() {
      // Dispose of the text controllers to prevent memory leaks
      flightDetailsList[index]['arrivalController'].dispose();
      flightDetailsList[index]['departureController'].dispose();
      flightDetailsList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Package'),
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

              GestureDetector(
                onTap: () => _selectStartDate(context),
                child: AbsorbPointer(
                  child: buildTextField('Start Date', startDateController, TextInputType.text),
                ),
              ),

              ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 222, 121, 90)),
                child: Text('Change Package Image', style: TextStyle(color: Colors.white)),
              ),

              if (widget.package.imageUrl != null && _image == null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Image.network(
                    widget.package.imageUrl!,
                    height: 150,
                  ),
                ),
              if (_image != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Image.file(
                    File(_image!.path),
                    height: 150,
                  ),
                ),

              // Day summaries
             // Day summaries
Padding(
  padding: const EdgeInsets.symmetric(vertical: 10.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Day Summaries', style: TextStyle(fontWeight: FontWeight.bold)),
      for (int i = 0; i < daySummaryControllers.length; i++)
        Row(
          children: [
            Expanded(
              child: buildTextField(
                'Day ${i + 1} Summary (${DateFormat('yyyy-MM-dd').format(startDate!.add(Duration(days: i)))})',
                daySummaryControllers[i],
                TextInputType.text,
              ),
            ),
            IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteDaySummary(i),
                          ),
          ],
        ),
        SizedBox(height: 15,),
      Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 222, 121, 90)),
          onPressed: _addDaySummary,
          child: Text('Add Day Summary',style: TextStyle(color: Colors.white),),
        ),
      ),
    ],
  ),
),


              // Flight details
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Flight Details', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 15,),
              ...flightDetailsList.asMap().entries.map((entry) {
                int index = entry.key; // Get the index
                Map<String, dynamic> detail = entry.value; // Get the detail using the index
                return Column(
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Starting Airport',
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
                      items: airportCities.map((String airport) {
                        return DropdownMenuItem<String>(
                          value: airport,
                          child: Text(airport),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          detail['selectedAirport'] = value;
                        });
                      },
                      value: detail['selectedAirport'],
                    ),
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
  ),),
                    buildTextField('Arrival Details', detail['arrivalController'], TextInputType.text),
                    buildTextField('Departure Details', detail['departureController'], TextInputType.text),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteFlightDetail(index), // Delete button
                    ),
                  ],
                );
              }).toList(),
              
              ElevatedButton(
                onPressed: _addFlightDetail,
                child: Text('Add Flight Detail'),
              ),
            ],
          ),
              ),

              buildTextField('Price Per Person', pricePerPersonController, TextInputType.number),
              buildTextField('Offer Price', offerPriceController, TextInputType.number),
              buildTextField('Price Per Person (with flight)', pricePerPerson1Controller, TextInputType.number),
              buildTextField('Offer Price (with flight)', offerPrice1Controller, TextInputType.number),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: savePackage,
                child: Text('Save Changes', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 222, 121, 90)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
