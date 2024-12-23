import 'package:flutter/material.dart';
import 'package:flutter_api/weather_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Aplikasi Cuaca",
      home: WeatherScreen(),
    );
  }
}
