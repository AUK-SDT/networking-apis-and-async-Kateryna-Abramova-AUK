import 'dart:convert';
import 'package:http/http.dart' as http;
import 'joke_model.dart';

class JokeService {
  static const String _url = 'https://icanhazdadjoke.com/';

  Future<DadJoke> fetchJoke() async {
    final response = await http.get(
      Uri.parse(_url),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return DadJoke.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to connect to the joke server.');
    }
  }
}
