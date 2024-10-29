import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GeneralDetails extends StatefulWidget {
  GeneralDetails({super.key});

  @override
  State<GeneralDetails> createState() => _GeneralDetailsState();
}

class _GeneralDetailsState extends State<GeneralDetails> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  DateTime? selectedDate1;
  DateTime? selectedDate;
  String? gender;
  String? nationality;
  String? maritalstatus;
  String? selectedCountry;

  List<String> countries = ['India', 'USA', 'Canada', 'Australia', 'UK', 'Germany'];

  // Controllers for the text fields
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController passportNumberController = TextEditingController();
  final TextEditingController panCardNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch user data when the widget is initialized
  }

  // Method to fetch user data from Firestore
  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user?.uid ?? '';
    
    if (userId.isNotEmpty) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('appusers').doc(userId).get();

      if (userDoc.exists) {
        // Update state with the fetched data
        setState(() {
          // Fetching name, phoneNumber, and email from Firestore
          fullNameController.text = userDoc['name'] ?? ''; // Fetch name from Firestore
          mobileNumberController.text = userDoc['phoneNumber'] ?? ''; // Fetch phone number from Firestore
          emailController.text = userDoc['email'] ?? ''; // Fetch email from Firestore

          selectedDate1 = (userDoc['date_of_birth'] as Timestamp?)?.toDate();
          gender = userDoc['gender'] ?? '';
          maritalstatus = userDoc['marital_status'] ?? '';
          nationality = userDoc['nationality'] ?? '';
          cityController.text = userDoc['city'] ?? '';
          stateController.text = userDoc['state'] ?? '';
          passportNumberController.text = userDoc['passport_number'] ?? '';
          selectedDate = (userDoc['expiry_date'] as Timestamp?)?.toDate();
          selectedCountry = userDoc['issuing_country'] ?? '';
          panCardNumberController.text = userDoc['pan_card_number'] ?? '';
        });
      } else {
        // Handle case where user document does not exist
        print("User document does not exist.");
      }
    }
  }

  // Method to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Method to save user data to Firestore
  Future<void> _saveUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user?.uid ?? '';

    try {
      await FirebaseFirestore.instance.collection('appusers').doc(userId).set({
        'name': fullNameController.text,
        'date_of_birth': selectedDate1 ?? FieldValue.serverTimestamp(),
        'gender': gender,
        'marital_status': maritalstatus,
        'nationality': nationality,
        'city': cityController.text,
        'state': stateController.text,
        'email': emailController.text,
        'phoneNumber': mobileNumberController.text,
        'passport_number': passportNumberController.text,
        'expiry_date': selectedDate ?? FieldValue.serverTimestamp(),
        'issuing_country': selectedCountry,
        'pan_card_number': panCardNumberController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User data saved successfully!')),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save user data.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 218, 224, 230),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_rounded, size: 18),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              // Center(
              //   child: Stack(
              //     clipBehavior: Clip.none,
              //     children: [
              //       Container(
              //         decoration: BoxDecoration(
              //           shape: BoxShape.circle,
              //           border: Border.all(color: Colors.black),
              //         ),
              //         child: CircleAvatar(
              //           radius: 40,
              //           backgroundImage: _image != null ? FileImage(_image!) : null,
              //           child: _image == null
              //               ? Icon(Icons.add_a_photo, size: 40)
              //               : null,
              //         ),
              //       ),
              //       Positioned(
              //         bottom: -19,
              //         left: 22,
              //         child: Container(
              //           width: 35,
              //           height: 34,
              //           decoration: BoxDecoration(
              //             color: Colors.blue,
              //             shape: BoxShape.circle,
              //             border: Border.all(color: Colors.white, width: 2),
              //           ),
              //           child: IconButton(
              //             icon: Icon(Icons.camera_alt, color: Colors.white, size: 16),
              //             onPressed: _pickImage,
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              // SizedBox(height: 50),
              _buildSectionTitle("General Details"),
              SizedBox(height: 10),
              TextFormField(
                readOnly: true,
                controller: fullNameController,
                decoration: InputDecoration(
                  isCollapsed: true,
                  contentPadding: EdgeInsets.all(12),
                  labelStyle: TextStyle(fontSize: 12),
                  labelText: 'FULL NAME *',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        isCollapsed: true,
                        contentPadding: EdgeInsets.all(12),
                        labelStyle: TextStyle(fontSize: 12),
                        labelText: 'DATE OF BIRTH',
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                      controller: TextEditingController(
                        text: selectedDate1 != null
                            ? "${selectedDate1!.day}/${selectedDate1!.month}/${selectedDate1!.year}"
                            : '',
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null && pickedDate != selectedDate1) {
                          setState(() {
                            selectedDate1 = pickedDate;
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        isCollapsed: true,
                        contentPadding: EdgeInsets.all(12),
                        labelStyle: TextStyle(fontSize: 12),
                        labelText: 'GENDER *',
                        border: OutlineInputBorder(),
                      ),
                      value: gender,
                      items: ['Male', 'Female', 'Other']
                          .map((gender) => DropdownMenuItem(
                                value: gender,
                                child: Text(gender),
                              ))
                          .toList(),
                      onChanged: (value) => setState(() => gender = value),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        isCollapsed: true,
                        contentPadding: EdgeInsets.all(12),
                        labelStyle: TextStyle(fontSize: 12),
                        labelText: 'MARITAL STATUS',
                        border: OutlineInputBorder(),
                      ),
                      value: maritalstatus,
                      items: ['Married', 'Not married']
                          .map((maritalstatus) => DropdownMenuItem(
                                value: maritalstatus,
                                child: Text(maritalstatus),
                              ))
                          .toList(),
                      onChanged: (value) => setState(() => maritalstatus = value),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        isCollapsed: true,
                        contentPadding: EdgeInsets.all(12),
                        labelStyle: TextStyle(fontSize: 12),
                        labelText: 'NATIONALITY',
                        border: OutlineInputBorder(),
                      ),
                      value: nationality,
                      items: countries
                          .map((country) => DropdownMenuItem(
                                value: country,
                                child: Text(country),
                              ))
                          .toList(),
                      onChanged: (value) => setState(() => nationality = value),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: cityController,
                decoration: InputDecoration(
                  isCollapsed: true,
                  contentPadding: EdgeInsets.all(12),
                  labelStyle: TextStyle(fontSize: 12),
                  labelText: 'CITY',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: stateController,
                decoration: InputDecoration(
                  isCollapsed: true,
                  contentPadding: EdgeInsets.all(12),
                  labelStyle: TextStyle(fontSize: 12),
                  labelText: 'STATE',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                readOnly: true,
                controller: emailController,
                decoration: InputDecoration(
                  isCollapsed: true,
                  contentPadding: EdgeInsets.all(12),
                  labelStyle: TextStyle(fontSize: 12),
                  labelText: 'EMAIL',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                readOnly: true,
                controller: mobileNumberController,
                decoration: InputDecoration(
                  isCollapsed: true,
                  contentPadding: EdgeInsets.all(12),
                  labelStyle: TextStyle(fontSize: 12),
                  labelText: 'MOBILE NUMBER',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: passportNumberController,
                decoration: InputDecoration(
                  isCollapsed: true,
                  contentPadding: EdgeInsets.all(12),
                  labelStyle: TextStyle(fontSize: 12),
                  labelText: 'PASSPORT NUMBER',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: panCardNumberController,
                decoration: InputDecoration(
                  isCollapsed: true,
                  contentPadding: EdgeInsets.all(12),
                  labelStyle: TextStyle(fontSize: 12),
                  labelText: 'PAN CARD NUMBER',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 222, 121, 90),),
                  onPressed: _saveUserData,
                  child: Text('Save',style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }
}
