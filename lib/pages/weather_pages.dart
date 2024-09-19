import 'dart:ui';

import 'package:app_cuaca/models/weather_models.dart';
import 'package:app_cuaca/services/weather_services.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //apikey
  final _WeatherService = weatherService('73a302c967ca6b38e84aeb376dd86503');
  Weather? _weather;
  String CityName = 'Depok';

  //fetch weather
  _fetchWeather() async {
    //get the current city

    //get weather for city
    try {
      final weather = await _WeatherService.getWeather(CityName);
      setState(() {
        _weather = weather;
      });
    }

    //any errors
    catch (e) {
      print(e);
    }
  }

  changeCity() {
    // setState(() {
    //   CityName = 'Jakarta';
    // });

    _fetchWeather();
  }

  //weather animations
  String getWeatherAnimation (String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json'; //default to sunny
    
    switch (mainCondition.toLowerCase()){
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json'; //default to sunny

    }
  }

  // init state
  @override
  void initState() {
    super.initState();

    //fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //city name
            Text(_weather?.CityName ?? "loading city.."),

            //animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            //temperatur
            Text('${_weather?.temperature.round()}°C'),

            
            //weather condition
            Text(_weather?.mainCondition ?? ""),

            Container(
              width: 240 ,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    CityName = value;
                  });
                },
              ),
            ),
            ElevatedButton(onPressed: changeCity, child: Text('Update'))
          ],
        ),
      ),
    );
  }
}
