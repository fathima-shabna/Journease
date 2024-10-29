import 'package:flutter/material.dart';



class BookNow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Page',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Section
              Text(
                'All-Inclusive 3N Holiday - Flights, Sightseeing & Transfers',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text('Customizable', style: TextStyle(color: Colors.blue)),
                  Spacer(),
                  Text('3N Goa', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              Divider(),
              // Date Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Oct 10, 2024\nThursday'),
                  Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.grey[300],
                    child: Text('4D/3N'),
                  ),
                  Text('Oct 13, 2024\nSunday'),
                ],
              ),
              SizedBox(height: 8),
              Text('6 Travellers: 4 Adults 2 Children / From Cochin'),
              Divider(),
              // Traveller Details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('1/4 Traveller Details'),
                  Text('Incomplete', style: TextStyle(color: Colors.red)),
                ],
              ),
              SizedBox(height: 8),
              Text('6 Travellers'),
              ListTile(
                title: Text('Booking For'),
                subtitle: Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text('Myself'),
                        leading: Radio(value: 1, groupValue: 1, onChanged: (v) {}),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text('Someone else'),
                        leading: Radio(value: 2, groupValue: 1, onChanged: (v) {}),
                      ),
                    ),
                  ],
                ),
              ),
              // Travellers List
              for (int i = 1; i <= 6; i++)
                ListTile(
                  title: Text('Traveller $i'),
                  trailing: Icon(Icons.add, color: Colors.blue),
                ),
              // Special Requests
              ListTile(
                title: Text('Special Requests'),
                trailing: Icon(Icons.add, color: Colors.blue),
              ),
              Divider(),
              // Contact Information
              Text('Contact Information', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Booking details & communication will be sent to'),
              TextField(
                decoration: InputDecoration(labelText: 'Email ID', hintText: 'Eg. John.doe@email.com'),
              ),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Mobile Code'),
                      items: ['India (+91)', 'USA (+1)'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (_) {},
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(labelText: 'Mobile', hintText: 'Eg. 7738316489'),
                    ),
                  ),
                ],
              ),
              TextField(
                decoration: InputDecoration(labelText: 'City', hintText: 'Eg. Bangalore'),
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'GST State'),
                items: ['Maharashtra', 'Karnataka'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (_) {},
              ),
              TextField(
                decoration: InputDecoration(labelText: 'GST Address', hintText: 'Eg. House Number, Street Name,...'),
              ),
              Divider(),
              // Travel + Medical Insurance
              ListTile(
                title: Text('Travel + Medical Insurance'),
                subtitle: Text('Secure your trip and travel worry free'),
              ),
              ListTile(
                leading: Checkbox(value: true, onChanged: (_) {}),
                title: Text('Reliance - \$200k Travel Insurance'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('99% Claims Settled'),
                    GestureDetector(
                      onTap: () {
                        // Navigate to T&Cs
                      },
                      child: Text(
                        'View T&Cs',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                trailing: Text('₹82 per person'),
              ),
              Divider(),
              // Confirm
              CheckboxListTile(
                value: true,
                onChanged: (_) {},
                title: Text('I confirm that I have read and accept Cancellation Policy, User Agreement, etc.'),
              ),
              Divider(),
              // Price and Continue Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '₹1,56,570\nGrand Total - 6 Travellers',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle continue action
                    },
                    child: Text('CONTINUE'),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
