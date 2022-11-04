import 'dart:convert';

import 'package:clean_air/my_home_page.dart';
import 'package:clean_air/permission_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather/weather.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

import 'main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xffffffff),
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [
                  Color(0xFF6671E5),
                  Color(0xFF4852D9),
                ],
              ),
            ),
          ),
          Align(
            alignment: FractionalOffset.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage('icons/cloud-sun.png'),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 15.0),
                ),
                Text(
                  Strings.appTitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 42.0,
                          color: Colors.white)),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 5.0),
                ),
                Text(
                  'Aplikacja do monitorowania \n czystości powietrza',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                      textStyle:
                          const TextStyle(fontSize: 16.0, color: Colors.white)),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 35,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                'Przywiewam dane...',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 18.0,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    checkPermisison(context);
  }
}

checkPermisison(context) async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PermissionScreen(),
        ));
  } else {
    SchedulerBinding.instance.addPersistentFrameCallback((timeStamp) {
      executeOnceAfterBuild(context);
    });
  }
}

void executeOnceAfterBuild(context) async {
  Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.lowest,
          forceAndroidLocationManager: true,
          timeLimit: const Duration(seconds: 5))
      .then((value) => {loadLocationData(value, context)})
      .onError((error, stackTrace) => {
            Geolocator.getLastKnownPosition(forceAndroidLocationManager: true)
                .then((value) => {loadLocationData(value, context)})
          });
}

loadLocationData(value, context) async {
  var lat = value.latitude;
  var lon = value.longitude;
  WeatherFactory wf = WeatherFactory('b9b26b0a2dc98163b8412c022f815653',
      language: Language.POLISH);

  Weather w = await wf.currentWeatherByLocation(lat, lon);
  // log(w.toJson().toString());

  String endpoint = 'https://api.waqi.info/feed';
  var keyword = 'geo:$lat;$lon';
  var key = '76b6e759a57e3835ecdcc3fe8ea9e26653456c63';
  String url = '$endpoint/$keyword/?token=$key';

  http.Response response = await http.get(Uri.parse(url));
  //log(response.body.toString());

  Map<String, dynamic> jsonBody = json.decode(response.body);
  AirQuality aq = AirQuality(jsonBody);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MyHomePage(weather: w, air: aq),
    ),
  );
}

class AirQuality {
  bool isGood = false;
  bool isBad = false;
  String quality = '';
  String advice = '';
  int aqi = 0;
  int pm25 = 0;
  int pm10 = 0;
  String station = '';

  AirQuality(Map<String, dynamic> jsonBody) {
    aqi = int.tryParse(jsonBody['data']['aqi'].toString()) ?? -1;
    pm25 = int.tryParse(jsonBody['data']['iaqi']['pm25']['v'].toString()) ?? -1;
    pm10 = int.tryParse(jsonBody['data']['iaqi']['pm10']['v'].toString()) ?? -1;

    station = jsonBody['data']['city']['name'].toString();

    setupLevel(aqi);
  }

  void setupLevel(int aqi) {
    if (aqi <= 100) {
      quality = 'Bardzo dobra';
      advice = 'Skorzystaj z dobrego powietrza i wyjdź na spacer';
      isGood = true;
    } else if (aqi <= 150) {
      quality = 'Nie za dobra';
      advice = 'Jeśli tylko możesz zostań w domu, załatwiaj sprawy online';
      isBad = true;
    } else {
      quality = 'Bardzo zła!';
      advice = 'Zdecydowanie zostań w domu i załatwiaj sprawy online!';
    }
  }
}
