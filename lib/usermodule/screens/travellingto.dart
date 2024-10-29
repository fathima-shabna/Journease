import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:journease/usermodule/screens/packages.dart';
import 'package:journease/usermodule/screens/placesapi.dart';
import 'package:journease/usermodule/screens/room.dart';
import 'package:journease/usermodule/screens/startingfrom2.dart';


class TravellingTo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 
       Scaffold(
        
        body: PlaceSearchWidget2(),
      );
    
  }
}

class PlaceSearchWidget2 extends StatelessWidget {
  final PlaceService1 placeService1 = PlaceService1();
  final TextEditingController controller1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back_ios_new_rounded,size: 14,)),
          Expanded(
            child: TypeAheadFormField<String>(
              textFieldConfiguration: TextFieldConfiguration(
                controller: controller1,
                decoration: InputDecoration(
                  isCollapsed: true,
                  contentPadding: EdgeInsets.all(12),
                  border: OutlineInputBorder(),
                  hintText: 'Search for a city, district, state, or country',
                ),
              ),
              suggestionsCallback: (pattern) async {
                return await placeService1.getSuggestions(pattern);
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion),
                );
              },
              onSuggestionSelected: (suggestion1) {
                controller1.text = suggestion1;

                // Handle suggestion selection
                print('Selected: $suggestion1');
                Navigator.pop(context, suggestion1);
                
              },
            ),
          ),
        ],
      ),
    );
  }
}
