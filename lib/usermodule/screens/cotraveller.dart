import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:journease/usermodule/screens/savedcotraveller.dart';





class AddCoTravellerScreen extends StatefulWidget {
  @override
  _AddCoTravellerScreenState createState() => _AddCoTravellerScreenState();
}

class _AddCoTravellerScreenState extends State<AddCoTravellerScreen> {
  String? gender;
  String? nationality;
  String? mealPreference;
  String? berthPreference;
  String? relationship;
  DateTime? selectedDate;
  DateTime? selectedDate1;
  String? selectedCountry;
  List<String> countries = ['India', 'USA', 'Canada', 'Australia', 'UK', 'Germany'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 218, 224, 230),
      appBar: AppBar(
        leading: IconButton(onPressed: (){
         
  Navigator.pop(context);

        }, icon: Icon(Icons.arrow_back_ios_rounded,size: 18,)),
        title: Text('Add Co-Traveller',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                color: Colors.yellow[100],
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Please Check if First & Last name, gender, and date of birth match Govt. ID such as Aadhaar or Passport',
                        style: TextStyle(color: Colors.black,),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                
                decoration: InputDecoration(
                  isCollapsed: true,
                  contentPadding: EdgeInsets.all(12),
                  labelStyle: TextStyle(fontSize: 12),
                  labelText: 'FIRST NAME *',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  isCollapsed: true,
                  contentPadding: EdgeInsets.all(12),
                  labelStyle: TextStyle(fontSize: 12),
                  labelText: 'LAST NAME *',
                  border: OutlineInputBorder(),
                ),
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
                  SizedBox(width: 10),
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
              : ''),
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
    )
                  ),
                ],
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  isCollapsed: true,
                  contentPadding: EdgeInsets.all(12),
                  labelStyle: TextStyle(fontSize: 12),
                  labelText: 'NATIONALITY',
                  border: OutlineInputBorder(),
                ),
                value: nationality,
                items: ['Indian', 'Other']
                    .map((nationality) => DropdownMenuItem(
                          value: nationality,
                          child: Text(nationality),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => nationality = value),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  isCollapsed: true,
                  contentPadding: EdgeInsets.all(12),
                  labelStyle: TextStyle(fontSize: 12),
                  labelText: 'MEAL PREFERENCE',
                  border: OutlineInputBorder(),
                ),
                value: mealPreference,
                items: ['Vegetarian', 'Non-Vegetarian', 'Vegan']
                    .map((preference) => DropdownMenuItem(
                          value: preference,
                          child: Text(preference),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => mealPreference = value),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  isCollapsed: true,
                  contentPadding: EdgeInsets.all(12),
                  labelStyle: TextStyle(fontSize: 12),
                  labelText: 'TRAIN BERTH PREFERENCE',
                  border: OutlineInputBorder(),
                ),
                value: berthPreference,
                items: ['Upper', 'Middle', 'Lower']
                    .map((preference) => DropdownMenuItem(
                          value: preference,
                          child: Text(preference),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => berthPreference = value),
              ),
              SizedBox(height: 10),
              Container(
                // height: 200,
                width: double.infinity,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(6),border: Border.all(color: Colors.black45)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      _buildSectionTitle("Traveller's relationship with you"),
                      SizedBox(height: 16,),
                      _buildRelationshipOptions(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Divider(),

              SizedBox(height: 5),
            _buildSectionTitle("Passport Details"),
            SizedBox(height: 16,),
            TextFormField(
                decoration: InputDecoration(
                  isCollapsed: true,
                  contentPadding: EdgeInsets.all(12),
                  labelStyle: TextStyle(fontSize: 12),
                  labelText: 'PASSPORT NUMBER',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10,),

            // TextFormField(
            //     decoration: InputDecoration(
            //       isCollapsed: true,
            //       contentPadding: EdgeInsets.all(12),
            //       labelStyle: TextStyle(fontSize: 12),
            //       labelText: 'EXPIRY DATE',
            //       border: OutlineInputBorder(),
            //     ),
            //   ),
              _buildExpiryDateField(),
              SizedBox(height: 10,),
              // TextFormField(
              //   decoration: InputDecoration(
              //     isCollapsed: true,
              //     contentPadding: EdgeInsets.all(12),
              //     labelStyle: TextStyle(fontSize: 12),
              //     labelText: 'ISSUING COUNTRY',
              //     border: OutlineInputBorder(),
              //   ),
              // ),

              _buildCountryDropdown(),

              SizedBox(height: 16),
            _buildSectionTitle("Contact Details"),
            SizedBox(height: 16,),
            TextFormField(
                decoration: InputDecoration(
                  isCollapsed: true,
                  contentPadding: EdgeInsets.all(12),
                  labelStyle: TextStyle(fontSize: 12),
                  labelText: 'EMAIL ID *',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16,),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: ("+91"),
                      decoration: InputDecoration(
                        isCollapsed: true,
                        contentPadding: EdgeInsets.all(12),
                        labelStyle: TextStyle(fontSize: 12),
                        labelText: 'CODE',
                        border: OutlineInputBorder(),
                      ),
                    ),
                ),
                  SizedBox(width: 8),
                Expanded(
                  flex: 5,
                  child: TextFormField(
                    
                      decoration: InputDecoration(
                        isCollapsed: true,
                        contentPadding: EdgeInsets.all(12),
                        labelStyle: TextStyle(fontSize: 12),
                        
                        labelText: 'MOBILE NUMBER *',
                        border: OutlineInputBorder(),
                      ),
                    ),
                ),
              ],
            ),

              
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 222, 121, 90),),
                  onPressed: () {
                    
                    // Save co-traveller
                  },
                  child: Text('SAVE CO-TRAVELLER',style: TextStyle(color: Colors.white),),
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
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
          
          selected: relationship == option ,
          onSelected: (selected) {
            // Handle selection
            setState(() {
             relationship = selected ? option : null;
            });
          },
        );
      }).toList(),
    );
  }

   Widget _buildCountryDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
         isCollapsed: true,
         contentPadding: EdgeInsets.all(13),
         labelStyle: TextStyle(fontSize: 12),
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

   Widget _buildExpiryDateField() {
    return TextField(
      decoration: InputDecoration(
        isCollapsed: true,
         contentPadding: EdgeInsets.all(12),
         labelStyle: TextStyle(fontSize: 12),
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
}
