import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool showTimer = true;
  List<String> _locations = ['10', '15', '20', '25']; // Option 2
  String? _selectedLocation = "10"; // Option 2

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 200), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      setState(() {
        showTimer = prefs.getBool("show_timer") ?? true;

        _selectedLocation = prefs.getString("timer_time") ?? "10";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Lottie.asset(
              'assets/images/background.json',
              fit: BoxFit.fill,
              alignment: Alignment.center,
              repeat: true,
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(top: 48.0),
              child: Column(
                children: [
                  SwitchListTile(
                    value: showTimer,
                    onChanged: (bool value) async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setBool("show_timer", value);
                      setState(() {
                        showTimer = value;
                      });
                    },
                    activeColor: Colors.red,
                    inactiveTrackColor: Colors.grey,
                    title: Text(
                      "Show Timer",
                      style: GoogleFonts.lato(
                        textStyle: Theme.of(context).textTheme.headline4,
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Select timer timer",
                          style: GoogleFonts.lato(
                            textStyle: Theme.of(context).textTheme.headline4,
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        DropdownButton(
                          hint: Text(''),
                          // Not necessary for Option 1
                          value: _selectedLocation,
                          onChanged: (newValue) {
                            setState(() async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setString(
                                  "timer_time", newValue.toString());
                              setState(() {
                                _selectedLocation = newValue.toString();
                              });
                            });
                          },
                          dropdownColor: Colors.black,
                          items: _locations.map((location) {
                            return DropdownMenuItem(
                              child: new Text(
                                location,
                                style: GoogleFonts.lato(
                                  textStyle:
                                      Theme.of(context).textTheme.headline4,
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              value: location,
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
