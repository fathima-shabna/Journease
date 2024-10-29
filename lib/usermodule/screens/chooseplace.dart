import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:journease/usermodule/screens/hotelsearch.dart';
import 'package:journease/usermodule/screens/packages.dart';
import 'package:journease/usermodule/screens/placesapi.dart';




class ChooosePlace extends StatelessWidget {
  
  final PlaceService1 placeService = PlaceService1();
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.arrow_back_ios_new_rounded,size: 14,)),
            Expanded(
              child: TypeAheadFormField<String>(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: controller,
                  decoration: InputDecoration(
                    isCollapsed: true,
                    contentPadding: EdgeInsets.all(12),
                    border: OutlineInputBorder(),
                    hintText: 'Search here',
                  ),
                ),
                suggestionsCallback: (pattern) async {
                  return await placeService.getSuggestions(pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  controller.text = suggestion;
      
                  // Handle suggestion selection
                  print('Selected: $suggestion');
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HotelSearch(selectedvalue: suggestion,rooms: 0,adults: 0,children: 0,),));
                 
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
