import 'dart:convert';
import 'package:http/http.dart' as http;
import 'joke_model.dart';

class JokeService {
  static const String _url = 'https://icanhazdadjoke.com/';

  Future<DadJoke> fetchJoke() async {
    //  API requires the 'Accept' header to return JSON
    final response = await http.get(
      Uri.parse(_url),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return DadJoke.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Failed to get a laugh today (Error ${response.statusCode})',
      );
    }
  }
}
