import 'package:clean_air/splash_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AirScreen extends StatefulWidget {
  const AirScreen({super.key, required this.air});

  final AirQuality air;

  @override
  State<AirScreen> createState() => _AirScreenState();
}

class _AirScreenState extends State<AirScreen> {
  final PanelController _pc = PanelController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xffffffff),
              gradient: getGradientByMood(widget.air),
            ),
          ),
          Align(
            alignment: FractionalOffset.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Jakość powietrza',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontSize: 14,
                      height: 1.2,
                      color: getBackgroundTextColor(widget.air),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 2)),
                Text(
                  widget.air.quality,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontSize: 22,
                      height: 1.2,
                      color: getBackgroundTextColor(widget.air),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 24)),
                CircleAvatar(
                  radius: 91,
                  backgroundColor: Colors.white,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          (widget.air.aqi / 200 * 100).floor().toString(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                              fontSize: 64,
                              height: 1.2,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'CAQI',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _pc.open();
                              },
                            style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                fontSize: 16,
                                height: 1.2,
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 28)),
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'PM 2,5',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                  fontSize: 14,
                                  height: 1.2,
                                  color: getBackgroundTextColor(widget.air),
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 2),
                            ),
                            Text(
                              '${widget.air.pm25}%',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                  fontSize: 22,
                                  height: 1.2,
                                  color: getBackgroundTextColor(widget.air),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      VerticalDivider(
                        width: 24,
                        thickness: 1,
                        color: getBackgroundTextColor(widget.air),
                      ),
                      SizedBox(
                        width: 130,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'PM 10',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                  fontSize: 14,
                                  height: 1.2,
                                  color: getBackgroundTextColor(widget.air),
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 2),
                            ),
                            Text(
                              '${widget.air.pm10}%',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                  fontSize: 22,
                                  height: 1.2,
                                  color: getBackgroundTextColor(widget.air),
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
                const Padding(padding: EdgeInsets.only(top: 20)),
                Text(
                  'Stacja pomiarowa',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontSize: 12,
                      height: 1.2,
                      color: getBackgroundTextColor(widget.air),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 8)),
                Text(
                  widget.air.station,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontSize: 14,
                      height: 1.2,
                      color: getBackgroundTextColor(widget.air),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 76),
                ),
              ],
            ),
          ),
          Positioned(
            left: 8,
            right: 0,
            bottom: (76) * 2,
            top: 0,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Stack(
                children: [
                  ClipRect(
                    child: Align(
                      alignment: Alignment.topLeft,
                      heightFactor: 1,
                      child: getDangerValueBottom(widget.air),
                    ),
                  ),
                  ClipRect(
                    child: Align(
                      alignment: Alignment.topLeft,
                      heightFactor: 1 - widget.air.aqi / 200.floor(),
                      child: getDangerValueTop(widget.air),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 62, left: 10, right: 10, bottom: 14),
                    child: Divider(
                      height: 10,
                      color: getBackgroundTextColor(widget.air),
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 24),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6.0),
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(10),
                        height: 38,
                        child: IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: getAdviceImage(widget.air),
                                alignment: Alignment.centerLeft,
                              ),
                              const Padding(padding: EdgeInsets.only(left: 8)),
                              Text(
                                widget.air.advice,
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SlidingUpPanel(
            minHeight: 0,
            maxHeight: 300,
            controller: _pc,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
            panel: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(padding: EdgeInsets.only(top: 32)),
                      Text(
                        'Indeks CAQI',
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                            fontSize: 14,
                            height: 1.2,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 8)),
                      Text(
                        'Indeks CAQI (ang. Common Air Quality Index) pozwala przedstawić sytuację w Europiie w porównywalny i łatwy do zrozumienia sposób. Wartość indeksu jest prezentowana w postaci jednej liczby. Skala ma rozpietość od 0 do wartości powyżej 100 i powyżej bardzo zanieczyszone. Im wyższa wartość wskażnika, tym większe ryzyko złego wpływu na zdrowie i sampoczucie.',
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                            fontSize: 12,
                            height: 1.2,
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 14)),
                      Text(
                        'Pył zawieszony PM2,5 i PM10',
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                            fontSize: 14,
                            height: 1.2,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 8)),
                      Text(
                        'Pyły zawieszone to mieszanina bardzo małych cząstek. PM10 to wszystkie pyły mniejsze niz 10μm, natomiast w przypadku  PM2,5 nie większe niż 2,5μm. Zanieczyszczenia pyłowe mają zdolność do adsorpcji swojej powierzchni innych, bardzo szkodliwych związków chemicznych: dioksyn, furanów, metali ciężkich, czy benzo(a)pirenu - najbardziej toksycznego skłądnika smogu.',
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                            fontSize: 12,
                            height: 1.2,
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    top: 0,
                    right: -10,
                    child: Container(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 16)),
                        onPressed: () {
                          _pc.close();
                        },
                        child: const Icon(
                          Icons.close,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                    ))
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

  getGradientByMood(AirQuality air) {
    if (air.isGood) {
      return const LinearGradient(
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
        colors: [
          Color(0xFF4ACF8C),
          Color(0xFF75EDA6),
        ],
      );
    } else if (air.isBad) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFBDA61),
          Color(0xFFF76B1C),
        ],
      );
    } else {
      return const LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [
          Color(0xFFF4003A),
          Color(0xFFFF8888),
        ],
      );
    }
  }

  getBackgroundTextColor(AirQuality air) {
    if (air.isBad || air.isGood) {
      return Colors.black;
    } else {
      return Colors.white;
    }
  }

  getDangerValueBottom(AirQuality air) {
    if (air.isGood) {
      return Image.asset(
        'icons/danger-value-negative.png',
        scale: 0.9,
      );
    } else {
      return Image.asset(
        'icons/danger-value.png',
        scale: 0.9,
      );
    }
  }

  getDangerValueTop(AirQuality air) {
    if (air.isGood) {
      return Image.asset(
        'icons/danger-value-negative.png',
        scale: 0.9,
        color: const Color(0xFF4ACF8C),
      );
    } else if (air.isBad) {
      return Image.asset(
        'icons/danger-value-negative.png',
        scale: 0.9,
        color: const Color(0xFFFBDA61),
      );
    } else {
      return Image.asset(
        'icons/danger-value.png',
        scale: 0.9,
        color: const Color(0xFFF4003A),
      );
    }
  }

  getAdviceImage(AirQuality air) {
    if (air.isGood) {
      return const AssetImage('icons/happy.png');
    } else if (air.isBad) {
      return const AssetImage('icons/ok.png');
    } else {
      return const AssetImage('icons/sad.png');
    }
  }
}
