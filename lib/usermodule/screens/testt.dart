

// import 'package:flutter/material.dart';



// class CoTravellerScreen extends StatefulWidget {


//   @override
//   State<CoTravellerScreen> createState() => _CoTravellerScreenState();
// }

// class _CoTravellerScreenState extends State<CoTravellerScreen> {
//   String? relationship;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Add Co-Traveller"),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             // Add back button functionality
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             _buildSectionTitle("Traveller's relationship with you"),
//             _buildRelationshipOptions(),
//             SizedBox(height: 16),
//             _buildSectionTitle("Passport Details"),
//             _buildPassportDetailsForm(),
//             SizedBox(height: 16),
//             _buildSectionTitle("Contact Details"),
//             _buildContactDetailsForm(),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Save co-traveller functionality
//               },
//               child: Text('SAVE CO-TRAVELLER'),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: Size(double.infinity, 50),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Text(
//       title,
//       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//     );
//   }

//   Widget _buildRelationshipOptions() {
//     final options = [
//       'Spouse', 'Child', 'Sibling', 'Parent',
//       'Parent In Law', 'Grand Parent', 'Relative',
//       'Friend', 'Colleague', 'Other'
//     ];

//     return Wrap(
//       spacing: 8.0,
//       runSpacing: 8.0,
//       children: options.map((option) {
//         return ChoiceChip(
//           label: Text(option),
          
//           selected: relationship == option ,
//           onSelected: (selected) {
//             // Handle selection
//             setState(() {
//              relationship = selected ? option : null;
//             });
//           },
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildPassportDetailsForm() {
//     return Column(
//       children: [
//         _buildTextField('Passport Number'),
//         SizedBox(height: 8),
//         _buildTextField('Expiry Date', isDropdown: true),
//         SizedBox(height: 8),
//         _buildTextField('Issuing Country', isDropdown: true),
//       ],
//     );
//   }

//   Widget _buildContactDetailsForm() {
//     return Column(
//       children: [
//         _buildTextField('Email ID'),
//         SizedBox(height: 8),
//         Row(
//           children: [
//             Expanded(
//               flex: 2,
//               child: _buildTextField('Code', initialValue: '+91'),
//             ),
//             SizedBox(width: 8),
//             Expanded(
//               flex: 5,
//               child: _buildTextField('Mobile Number'),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildTextField(String label, {bool isDropdown = false, String? initialValue}) {
//     return TextField(
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(),
//       ),
//       readOnly: isDropdown,
//       controller: initialValue != null ? TextEditingController(text: initialValue) : null,
//       onTap: isDropdown ? () {
//         // Handle dropdown tap
//       } : null,
//     );
//   }
// }


import 'package:flutter/material.dart';

class CoTravellerScreen extends StatefulWidget {
  @override
  State<CoTravellerScreen> createState() => _CoTravellerScreenState();
}

class _CoTravellerScreenState extends State<CoTravellerScreen> {
  String? relationship;
  DateTime? selectedDate;
  String? selectedCountry;
  List<String> countries = ['India', 'USA', 'Canada', 'Australia', 'UK', 'Germany'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Co-Traveller"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Add back button functionality
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSectionTitle("Traveller's relationship with you"),
            _buildRelationshipOptions(),
            SizedBox(height: 16),
            _buildSectionTitle("Passport Details"),
            _buildPassportDetailsForm(),
            SizedBox(height: 16),
            _buildSectionTitle("Contact Details"),
            _buildContactDetailsForm(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save co-traveller functionality
              },
              child: Text('SAVE CO-TRAVELLER'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildRelationshipOptions() {
    final options = [
      'Spouse', 'Child', 'Sibling', 'Parent',
      'Parent In Law', 'Grand Parent', 'Relative',
      'Friend', 'Colleague', 'Other'
    ];

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: options.map((option) {
        return ChoiceChip(
          label: Text(option),
          selected: relationship == option,
          onSelected: (selected) {
            setState(() {
              relationship = selected ? option : null;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildPassportDetailsForm() {
    return Column(
      children: [
        _buildTextField('Passport Number'),
        SizedBox(height: 8),
        _buildExpiryDateField(),
        SizedBox(height: 8),
        _buildCountryDropdown(),
      ],
    );
  }

  Widget _buildContactDetailsForm() {
    return Column(
      children: [
        _buildTextField('Email ID'),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildTextField('Code', initialValue: '+91'),
            ),
            SizedBox(width: 8),
            Expanded(
              flex: 5,
              child: _buildTextField('Mobile Number'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(String label, {bool isDropdown = false, String? initialValue}) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      readOnly: isDropdown,
      controller: initialValue != null ? TextEditingController(text: initialValue) : null,
      onTap: isDropdown ? () {
        // Handle dropdown tap
      } : null,
    );
  }

  Widget _buildExpiryDateField() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Expiry Date',
        border: OutlineInputBorder(),
      ),
      readOnly: true,
      controller: TextEditingController(
          text: selectedDate != null
              ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
              : ''),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null && pickedDate != selectedDate) {
          setState(() {
            selectedDate = pickedDate;
          });
        }
      },
    );
  }

  Widget _buildCountryDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Issuing Country',
        border: OutlineInputBorder(),
      ),
      value: selectedCountry,
      items: countries.map((String country) {
        return DropdownMenuItem<String>(
          value: country,
          child: Text(country),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedCountry = newValue;
        });
      },
    );
  }
}
