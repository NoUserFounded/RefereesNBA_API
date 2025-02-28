import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String?> fetchFirstImage(String query) async {
  final String apiKey = 'AIzaSyBbnhTnQxTK7UrId1XJAjnYzDPIYws7mRk';
  final String cx = '52b54d65c0e1d4ac5';
  final String endpoint = 'https://www.googleapis.com/customsearch/v1';

  final response = await http.get(
    Uri.parse('$endpoint?q=NBA-Referee-$query&cx=$cx&searchType=image&num=1&key=$apiKey'),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data['items'] != null && data['items'].isNotEmpty) {
      return data['items'][0]['link'];
    }
  }
  return null;
}