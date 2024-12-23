import 'package:flutter/material.dart';
import 'package:flutter_api/api_service.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final ApiService apiService = ApiService();
  final TextEditingController cityController = TextEditingController();
  Map<String, dynamic>? weatherData;
  bool isLoading = false;
  String errorMessage = '';

  final List<String> popularCities = [
    'Muncar', 'Rogojampi', 'Singotrunan', 'Glenmore', 'Srono', 'Sukowidi', 'Kabat', 'Labanasem'
  ];


  Map<String, Map<String, dynamic>> cityWeatherData = {};


  void fetchWeather(String city) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final data = await apiService.fetchWeather(city);
      setState(() {
        weatherData = data;
        cityWeatherData[city] = data;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  IconData getWeatherIcon(String description) {
    if (description.contains("cloud")) {
      return Icons.cloud;
    } else if (description.contains("rain")) {
      return Icons.grain;
    } else if (description.contains("clear")) {
      return Icons.wb_sunny;
    } else if (description.contains("snow")) {
      return Icons.ac_unit;
    } else {
      return Icons.wb_cloudy;
    }
  }


  String getTemperatureForCity(String city) {
    if (cityWeatherData.containsKey(city)) {
      var temp = cityWeatherData[city]?['main']['temp'];
      if (temp != null) {
        return "${(temp - 273.15).toStringAsFixed(1)}°C";
      }
    }
    return "28.3°C";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Aplikasi Cuaca")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            TextField(
              controller: cityController,
              decoration: InputDecoration(
                labelText: "Masukkan nama kota",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => fetchWeather(cityController.text.trim()),
                ),
              ),
            ),
            SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: popularCities.length,
                itemBuilder: (context, index) {
                  String city = popularCities[index];
                  Map<String, dynamic>? cityWeather = cityWeatherData[city];

                  return ListTile(
                    leading: cityWeather != null
                        ? Icon(
                      getWeatherIcon(cityWeather['weather'][0]['description']),
                      size: 40,
                    )
                        : Icon(Icons.cloud, size: 40), // Default icon
                    title: Text(city),
                    subtitle: Row(
                      children: [
                        // Display temperature or placeholder
                        Text(
                          getTemperatureForCity(city),
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 10),
                        // Display weather description if data is available
                        cityWeather != null
                            ? Text(
                          cityWeather['weather'][0]['description'],
                          style: TextStyle(fontSize: 16),
                        )
                            : Container(),
                      ],
                    ),
                    onTap: () => fetchWeather(city),
                  );
                },
              ),
            ),
            // Loading and error states
            if (isLoading)
              CircularProgressIndicator()
            else if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              )
            else if (weatherData != null)
                Column(
                  children: [
                    Icon(
                      getWeatherIcon(weatherData!['weather'][0]['description']),
                      size: 100,
                    ),
                    Text(
                      "${(weatherData!['main']['temp'] - 273.15).toStringAsFixed(1)}°C",
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      weatherData!['weather'][0]['description'],
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}
