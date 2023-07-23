import 'package:flutter/material.dart';
import 'package:usapp_mobile/2.0/utils2/constants.dart';

class NotificationBadge extends StatelessWidget {
  final int totalNotification;
  final double height;
  final double width;
  final double fontSize;

  const NotificationBadge({
    Key? key,
    required this.totalNotification,
    required this.height,
    required this.width,
    required this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: kMiddleColor,
        shape: BoxShape.circle,
      ),
      height: height,
      width: width,
      child: Center(
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(50),
          ),
          child: Image.asset(
            'assets/images/UsAppLogoWelcome.png',
            height: 20,
            width: 30,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
