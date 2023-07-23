import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:provider/src/provider.dart';
import 'package:usapp_mobile/2.0/providers2/advdrawer_controller.dart';
import 'package:usapp_mobile/2.0/providers2/will_pop_provider2.dart';
import 'package:usapp_mobile/2.0/screens2/about_usapp_screen2.dart';
import 'package:usapp_mobile/2.0/screens2/activities_screen2.dart';
import 'package:usapp_mobile/2.0/screens2/drawer_screen2.dart';
import 'package:usapp_mobile/2.0/screens2/home_screen2.dart';
import 'package:usapp_mobile/2.0/screens2/on_drawer/developers_screen.dart';
import 'package:usapp_mobile/2.0/screens2/on_drawer/invite_screen2.dart';
import 'package:usapp_mobile/2.0/screens2/on_drawer/members_screen2.dart';
import 'package:usapp_mobile/2.0/screens2/on_drawer/profile_screen2.dart';
import 'package:usapp_mobile/2.0/screens2/on_drawer/urs_screen2.dart';
import 'package:usapp_mobile/2.0/screens2/swipe/drawerpage_provider2.dart';
import 'package:usapp_mobile/2.0/utils2/routes2.dart';

class MyPage21 extends StatefulWidget {
  @override
  _MyPage21State createState() => _MyPage21State();
}

class _MyPage21State extends State<MyPage21> {
  final _advancedDrawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    context.read<AdvDrawerController>().setAdvDrawerController =
        _advancedDrawerController;

    return AdvancedDrawer(
      // backdropColor: Colors.blueGrey,
      backdropColor: Theme.of(context).backgroundColor.withOpacity(0.3),
      controller: context.read<AdvDrawerController>().advDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        // NOTICE: Uncomment if you want to add shadow behind the page.
        // Keep in mind that it may cause animation jerks.
        // boxShadow: <BoxShadow>[
        //   BoxShadow(
        //     color: Colors.black12,
        //     blurRadius: 0.0,
        //   ),
        // ],
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: (() {
        switch (context.watch<DrawerPageProvider2>().drawerPageSelected) {
          case 0:
            return WillPopScope(
              onWillPop: () =>
                  context.read<WillPopProvider2>().onWillPop(context),
              // Navigator.of(context).pushNamed(Routes2.settings2);

              child: HomeScreen2(),
            );

          // return Reload();
          case 1:
            return WillPopScope(
              onWillPop: () =>
                  context.read<WillPopProvider2>().toHomeScreen(context),
              // context.read<WillPopProvider2>().onWillPop(context),
              child: MembersScreen2(),
            );
          case 2:
            return WillPopScope(
              onWillPop: () =>
                  context.read<WillPopProvider2>().toHomeScreen(context),
              // child: InviteScreen2(),
              child: AboutUsappScreen2(),
            );
          case 3:
            return WillPopScope(
              onWillPop: () =>
                  context.read<WillPopProvider2>().toHomeScreen(context),
              child: URSScreen2(),
            );
          case 4:
            return WillPopScope(
              onWillPop: () =>
                  context.read<WillPopProvider2>().toHomeScreen(context),
              child: DevelopersScreen2(),
            );
          case 5:
            return WillPopScope(
              onWillPop: () =>
                  context.read<WillPopProvider2>().toHomeScreen(context),
              child: ProfileScreen2(),
            );

          case 6:
            return WillPopScope(
              onWillPop: () =>
                  context.read<WillPopProvider2>().toHomeScreen(context),
              child: ActivitiesScreen2(),
            );

          // return UploadIMGtoFirebase();

          default:
            return Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  color: Colors.red,
                ),
              ],
            );
        }
      }()),
      drawer: DrawerScreen2(),
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    context.read<AdvDrawerController>().advDrawerController.showDrawer();
  }
}
