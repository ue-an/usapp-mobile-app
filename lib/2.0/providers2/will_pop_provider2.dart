import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:usapp_mobile/2.0/providers2/advdrawer_controller.dart';
import 'package:usapp_mobile/2.0/providers2/theme/theme_provider2.dart';
import 'package:usapp_mobile/2.0/screens2/swipe/drawerpage_provider2.dart';
import 'package:usapp_mobile/2.0/utils2/constants.dart';
import 'package:usapp_mobile/2.0/utils2/routes2.dart';

class WillPopProvider2 with ChangeNotifier {
  Future<bool> onWillPop(BuildContext context) async {
    bool? exitResult = await showDialog(
      context: context,
      builder: (context) => _buildExitDialog(context),
    );
    return exitResult ?? false;
  }

  Future<bool> toHomeScreen(BuildContext context) async {
    // context.read<AdvDrawerController>().advDrawerController.showDrawer();
    // context.read<DrawerPageProvider2>().changeDrawerPageSelected = 0;
    context.read<DrawerPageProvider2>().changeDrawerPageSelected = 0;
    Navigator.of(context).pushNamed(Routes2.homescreen2);
    return true;
  }

  Future<bool?> _showExitDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => _buildExitDialog(context),
    );
  }

  AlertDialog _buildExitDialog(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Please confirm',
        style: TextStyle(
            color: context.read<ThemeProvider2>().isDark
                ? kMiddleColor
                : kPrimaryColor),
      ),
      content: const Text('Do you want to exit the app?'),
      actions: <Widget>[
        TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'No',
              style: TextStyle(
                  color: context.read<ThemeProvider2>().isDark
                      ? kMiddleColor
                      : kPrimaryColor),
            )),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            'Yes',
            style: TextStyle(
                color: context.read<ThemeProvider2>().isDark
                    ? kMiddleColor
                    : kPrimaryColor),
          ),
        ),
      ],
    );
  }
}
