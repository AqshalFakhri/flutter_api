import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiKey = '9e4a26aa4a58a6b85b84aeb308f40045';

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Gagal memuat data cuaca');
      }
    } catch (e) {
      throw Exception('Kesalahan: $e');
    }
  }
}
