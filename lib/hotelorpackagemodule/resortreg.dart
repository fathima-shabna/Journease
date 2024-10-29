import 'package:flutter/material.dart';

class ResortHotelRegistrationPage extends StatefulWidget {
  @override
  _ResortHotelRegistrationPageState createState() => _ResortHotelRegistrationPageState();
}

class _ResortHotelRegistrationPageState extends State<ResortHotelRegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController zipController = TextEditingController();
  final TextEditingController licenseNumberController = TextEditingController();
  final TextEditingController ratingController = TextEditingController();
  final TextEditingController roomCountController = TextEditingController();
  final TextEditingController amenitiesController = TextEditingController();
  final TextEditingController bankAccountController = TextEditingController();
  final TextEditingController taxNumberController = TextEditingController();

  // Function to submit registration
  void submitRegistration() {
    if (_formKey.currentState!.validate()) {
      // Process the form submission, usually involves sending the data to a server
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Submitting registration')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resort/Hotel Registration'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Information
              Text('Basic Information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Resort/Hotel Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the resort/hotel name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: ownerNameController,
                decoration: InputDecoration(labelText: 'Owner\'s Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the owner\'s name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: contactNumberController,
                decoration: InputDecoration(labelText: 'Contact Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the contact number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Address Details
              Text('Address Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: cityController,
                decoration: InputDecoration(labelText: 'City'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the city';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: stateController,
                decoration: InputDecoration(labelText: 'State'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the state';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: zipController,
                decoration: InputDecoration(labelText: 'ZIP Code'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the ZIP code';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Business Details
              Text('Business Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              TextFormField(
                controller: licenseNumberController,
                decoration: InputDecoration(labelText: 'License Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the license number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: ratingController,
                decoration: InputDecoration(labelText: 'Star Rating'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the star rating';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: roomCountController,
                decoration: InputDecoration(labelText: 'Number of Rooms'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of rooms';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: amenitiesController,
                decoration: InputDecoration(labelText: 'Amenities (comma separated)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please list the amenities';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Payment Information
              Text('Payment Information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              TextFormField(
                controller: bankAccountController,
                decoration: InputDecoration(labelText: 'Bank Account Number'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the bank account number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: taxNumberController,
                decoration: InputDecoration(labelText: 'Tax Registration Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the tax registration number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: submitRegistration,
                  child: Text('Submit for Review'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
