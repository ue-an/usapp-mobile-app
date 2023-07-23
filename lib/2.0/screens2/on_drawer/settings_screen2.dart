import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usapp_mobile/2.0/providers2/auth_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/theme/theme_provider2.dart';
import 'package:usapp_mobile/2.0/utils2/constants.dart';
import 'package:usapp_mobile/2.0/utils2/routes2.dart';

class SettingsScreen2 extends StatefulWidget {
  const SettingsScreen2({Key? key}) : super(key: key);

  @override
  _SettingsScreen2State createState() => _SettingsScreen2State();
}

class _SettingsScreen2State extends State<SettingsScreen2> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  var isSelected = [true, false];

  bool isDrawerOpen = false;
  //using list tile switch
  late bool _value;

  @override
  Widget build(BuildContext context) {
    _value = context.read<ThemeProvider2>().isDark;
    // Wraps the overall screen
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          elevation: 7,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Theme',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                    side: const BorderSide(
                      color: kMiddleColor,
                      width: 2.0,
                    ),
                  ),
                  child: ListTileSwitch(
                    value: _value,
                    // leading: Icon(Icons.access_alarms),
                    onChanged: (value) {
                      setState(() {
                        _value = value;
                      });
                      context.read<ThemeProvider2>().isDark
                          ? context.read<ThemeProvider2>().isDark = false
                          : context.read<ThemeProvider2>().isDark = true;
                      // _value = value;
                      context.read<ThemeProvider2>().isDark
                          ? ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                              content: Text('Dark mode turned on'),
                              duration: Duration(milliseconds: 900),
                            ))
                          : ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                              content: Text('Dark mode turned off'),
                              duration: Duration(milliseconds: 900),
                            ));
                    },
                    visualDensity: VisualDensity.comfortable,
                    switchType: SwitchType.material,
                    switchActiveColor: kMiddleColor,
                    title: const Text('Dark Mode'),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                // const Text(
                //   'App Data',
                //   style: TextStyle(
                //       fontWeight: FontWeight.bold, color: Colors.white),
                // ),
                // GestureDetector(
                //   onTap: () async {
                //     showDialog(
                //         context: context,
                //         barrierDismissible: false,
                //         builder: (BuildContext context) {
                //           return AlertDialog(
                //             shape: const RoundedRectangleBorder(
                //                 borderRadius:
                //                     BorderRadius.all(Radius.circular(20.0))),
                //             content: Padding(
                //               padding: const EdgeInsets.all(8.0),
                //               child: Column(
                //                 mainAxisSize: MainAxisSize.min,
                //                 children: <Widget>[
                //                   Padding(
                //                     padding: const EdgeInsets.all(8.0),
                //                     child: ListBody(
                //                       children: <Widget>[
                //                         Row(
                //                           children: const [
                //                             Icon(
                //                               FontAwesomeIcons
                //                                   .exclamationCircle,
                //                               color: kPrimaryColor,
                //                             ),
                //                             SizedBox(
                //                               width: 12,
                //                             ),
                //                             Text('Clear all data?'),
                //                           ],
                //                         ),
                //                         const SizedBox(
                //                           height: 21,
                //                         ),
                //                         Row(
                //                           children: const [
                //                             Expanded(
                //                               child: Text(
                //                                 'Are you sure you want to clear all data of UsApp?',
                //                                 textAlign: TextAlign.center,
                //                               ),
                //                             ),
                //                           ],
                //                         ),
                //                       ],
                //                     ),
                //                   ),
                //                   Padding(
                //                     padding: const EdgeInsets.all(8.0),
                //                     child: Row(
                //                       mainAxisAlignment:
                //                           MainAxisAlignment.spaceEvenly,
                //                       children: <Widget>[
                //                         Padding(
                //                           padding: const EdgeInsets.all(8.0),
                //                           child: RaisedButton(
                //                             color: kPrimaryColor,
                //                             shape: const RoundedRectangleBorder(
                //                                 borderRadius: BorderRadius.all(
                //                                     Radius.circular(2.0))),
                //                             child: const Text(
                //                               "No",
                //                               style: TextStyle(
                //                                 color: Colors.white,
                //                               ),
                //                             ),
                //                             onPressed: () {
                //                               Navigator.of(context).pop();
                //                             },
                //                           ),
                //                         ),
                //                         Padding(
                //                           padding: const EdgeInsets.all(8.0),
                //                           child: RaisedButton(
                //                             color: kPrimaryColor,
                //                             shape: const RoundedRectangleBorder(
                //                                 borderRadius: BorderRadius.all(
                //                                     Radius.circular(2.0))),
                //                             child: const Text(
                //                               "Yes",
                //                               style: TextStyle(
                //                                 color: Colors.white,
                //                               ),
                //                             ),
                //                             onPressed: () async {
                //                               SharedPreferences localPrefs =
                //                                   await SharedPreferences
                //                                       .getInstance();
                //                               await localPrefs.clear();
                //                               // ScaffoldMessenger.of(context)
                //                               //     .showSnackBar(const SnackBar(
                //                               //   content: Text(
                //                               //       'No function at the moment'),
                //                               //   duration:
                //                               //       Duration(milliseconds: 900),
                //                               // ));

                //                               showDialog(
                //                                 barrierDismissible: false,
                //                                 context: context,
                //                                 builder: (context) {
                //                                   return const Center(
                //                                     child:
                //                                         CircularProgressIndicator(),
                //                                   );
                //                                 },
                //                               );

                //                               Future.delayed(
                //                                   Duration(milliseconds: 1000),
                //                                   () async {
                //                                 await context
                //                                     .read<AuthProvider2>()
                //                                     .signOutAccount();
                //                                 Navigator.of(context).pop();
                //                               });
                //                               Future.delayed(
                //                                   Duration(milliseconds: 1050),
                //                                   () async {
                //                                 Navigator.of(context)
                //                                     .pushReplacementNamed(
                //                                         Routes2.splashscreen2);
                //                               });
                //                             },
                //                           ),
                //                         ),
                //                       ],
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //           );
                //         });
                //   },
                //   child: Card(
                //     child: GFListTile(
                //       title: const Text(
                //         'Clear all data',
                //         style: TextStyle(
                //           fontSize: 16,
                //         ),
                //       ),
                //       subTitle: Text(
                //         'Clear all the data in the app including user credentials',
                //         style: TextStyle(
                //             color: context.watch<ThemeProvider2>().isDark
                //                 ? Colors.white.withOpacity(0.5)
                //                 : Colors.grey),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ));
  }
}
