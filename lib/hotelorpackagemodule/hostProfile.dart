import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HostProfilePage extends StatefulWidget {
  final String hostId; // The ID of the logged-in host

  HostProfilePage({required this.hostId});

  @override
  _HostProfilePageState createState() => _HostProfilePageState();
}

class _HostProfilePageState extends State<HostProfilePage> {
  final _firestore = FirebaseFirestore.instance;

  // TextEditingControllers for each field
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchHostData();
  }

  // Fetch host data when the page is first created
  Future<void> _fetchHostData() async {
    DocumentSnapshot hostSnapshot = await _firestore.collection('hosts').doc(widget.hostId).get();

    if (hostSnapshot.exists) {
      // Set the text of controllers with the fetched data
      firstNameController.text = hostSnapshot['firstName'] ?? '';
      lastNameController.text = hostSnapshot['lastName'] ?? '';
      emailController.text = hostSnapshot['email'] ?? '';
      phoneNumberController.text = hostSnapshot['phoneNumber'] ?? '';
      addressController.text = hostSnapshot['address'] ?? '';
    }
  }

  // Update host data in Firestore
  Future<void> _updateHostData() async {
    await _firestore.collection('hosts').doc(widget.hostId).update({
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'email': emailController.text,
      'phoneNumber': phoneNumberController.text,
      'address': addressController.text,
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated successfully!')));
  }

  @override
  void dispose() {
    // Dispose the controllers to free resources
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Host Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _updateHostData,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTextField(firstNameController, 'First Name'),
            SizedBox(height: 16.0),
            _buildTextField(lastNameController, 'Last Name'),
            SizedBox(height: 16.0),
            _buildTextField(emailController, 'Email'),
            SizedBox(height: 16.0),
            _buildTextField(phoneNumberController, 'Phone Number'),
            SizedBox(height: 16.0),
            _buildTextField(addressController, 'Address'),
          ],
        ),
      ),
    );
  }

  // Widget to build the text fields with card decoration
  Widget _buildTextField(TextEditingController controller, String label) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
          ),
          validator: (value) => value!.isEmpty ? 'Please enter your $label' : null,
        ),
      ),
    );
  }
}
