import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key, required this.weather});

  final Weather weather;

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xffffffff),
              gradient: getGadientByMood(widget.weather),
            ),
          ),
          Align(
            alignment: FractionalOffset.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 45),
                ),
                Image(
                  image:
                      AssetImage('icons/${getIconByMood(widget.weather)}.png'),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 41.0),
                ),
                Text(
                  '${DateFormat.MMMMEEEEd('pl').format(DateTime.now())}, ${widget.weather.weatherDescription}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      fontSize: 14,
                      height: 1.2,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 12.0),
                ),
                Text(
                  '${widget.weather.temperature!.celsius?.floor().toString()}°C',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      fontSize: 64,
                      height: 1.2,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  'Odczuwalna ${widget.weather.tempFeelsLike!.celsius?.floor().toString()} °C',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      fontSize: 14,
                      height: 1.2,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 25.0),
                ),
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 130,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Ciśnienie',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                  fontSize: 14,
                                  height: 1.2,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 2),
                            ),
                            Text(
                              '${widget.weather.pressure?.floor()} hPa',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                  fontSize: 26,
                                  height: 1.2,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const VerticalDivider(
                        width: 48,
                        thickness: 1,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 130,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Wiatr',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                  fontSize: 14,
                                  height: 1.2,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 2),
                            ),
                            Text(
                              '${widget.weather.windSpeed}m/s',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                  fontSize: 26,
                                  height: 1.2,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 24),
                ),
                if (widget.weather.rainLastHour != null)
                  Text(
                    'Opady: ${widget.weather.rainLastHour} mm/1h',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        fontSize: 14,
                        height: 1.2,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                const Padding(
                  padding: EdgeInsets.only(top: 68),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool havePermissio() {
    return true;
  }

  String getIconByMood(Weather weather) {
    var main = weather.weatherMain;
    if (main == 'Clounds' || main == 'Drizzle' || main == 'Snow') {
      return 'weather-rain';
    } else if (main == 'Thunderstorm') {
      return 'weather-lightning';
    } else if (isNight(weather)) {
      return 'weather-moonny';
    } else {
      return 'weather-sunny';
    }
  }

  bool isNight(Weather weather) {
    return DateTime.now().isAfter(weather.sunset as DateTime) ||
        DateTime.now().isBefore(weather.sunrise as DateTime);
  }

  getGadientByMood(Weather weather) {
    var main = weather.weatherMain;
    if (main == 'Clounds' || main == 'Drizzle' || main == 'Snow') {
      return const LinearGradient(
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
        colors: [
          Color(0xFF6E6CD8),
          Color(0xFF40A0EF),
          Color(0xFF77E1EE),
        ],
      );
    } else if (main == 'Thunderstorm' || isNight(weather)) {
      return const LinearGradient(
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
        colors: [
          Color(0xFF5283F0),
          Color(0xFFCDEDD4),
        ],
      );
    } else {
      return const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color(0xFF313545),
          Color(0xFF121118),
        ],
      );
    }
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }
}
