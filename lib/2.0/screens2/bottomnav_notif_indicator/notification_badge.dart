import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:usapp_mobile/2.0/models/notification.dart';
import 'package:usapp_mobile/2.0/screens2/pushnotification/notification_provider.dart';

class NotificationBadge extends StatelessWidget {
  Stream<List<UsappNotification>> streamUsappNotifications;
  String myStudentNumber;
  NotificationBadge({
    Key? key,
    required this.streamUsappNotifications,
    required this.myStudentNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UsappNotification>>(
        stream: streamUsappNotifications,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return context.watch<NotificationProvider>().myNotifNow.isNotEmpty
                ? GFBadge(
                    // child: Text(notifCount.toString()),
                    child: Text(context
                            .read<NotificationProvider>()
                            .myNotifNow
                            .length
                            .toString()
                        // ''
                        ),
                    shape: GFBadgeShape.circle,
                    color: Colors.amber,
                  )
                : Container();
          } else {
            return Container();
          }
        });
  }
}
