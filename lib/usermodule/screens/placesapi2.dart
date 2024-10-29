import 'dart:convert';
import 'package:http/http.dart' as http;

class PlaceService2 {
  final String apiKey = 'c3f91f758fa94d53a5e30262689a7609'; // Replace with your API key

  Future<List<String>> getSuggestions(String query) async {
    final url = 'https://api.opencagedata.com/geocode/v1/json?q=$query&key=$apiKey';
    final response = await http.get(Uri.parse(url));

    // final response = await http.get(Uri.parse(
    //       'http://api.geonames.org/searchJSON?name_startsWith=$input&maxRows=10&username=YOUR_USERNAME'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<String> suggestions = [];
      
      for (var result in data['results']) {
        suggestions.add(result['formatted']);
      }

      return suggestions;
    } else {
      // throw Exception('Failed to load suggestions');
      return [];
    }
  }
}
