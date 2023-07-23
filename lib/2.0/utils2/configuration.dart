import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Color primaryGreen = Color(0xff416d6d);
List<BoxShadow> shadowList = [
  BoxShadow(color: Colors.grey[300]!, blurRadius: 30, offset: Offset(0, 10))
];

List<Map> categories = [
  {'name': 'Cats', 'iconPath': 'images/cat.png'},
  {'name': 'Dogs', 'iconPath': 'images/dog.png'},
  {'name': 'Bunnies', 'iconPath': 'images/rabbit.png'},
  {'name': 'Parrots', 'iconPath': 'images/parrot.png'},
  {'name': 'Horses', 'iconPath': 'images/horse.png'}
];

// List<Map> drawerItems = [
  // {'icon': const Icon(FontAwesomeIcons.home), 'title': 'Home'},
  // {'icon': Icon(Icons.account_balance), 'title': 'About URS'},
  // {'icon': Icon(Icons.mail), 'title': 'Invite'},
  // {'icon': Icon(FontAwesomeIcons.info), 'title': 'Developers'},
  // {'icon': Icon(Icons.settings), 'title': 'Seetings'},
  //====
  // {'icon': FontAwesomeIcons.accusoft, 'title': 'Profile'},
  // {'icon': Icons.group, 'title': 'Members'},
// ];
