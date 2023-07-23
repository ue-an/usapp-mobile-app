import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:usapp_mobile/2.0/models/notification.dart';
import 'package:usapp_mobile/2.0/screens2/pushnotification/notification_provider.dart';

class ChatBadge extends StatelessWidget {
  Stream<List<UsappNotification>> streamUsappNotifications;
  String myStudentNumber;
  ChatBadge({
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
            List<UsappNotification> myUsappNotif = [];
            snapshot.data!.forEach((notif) {
              if (notif.notifOwner == myStudentNumber) {
                myUsappNotif.add(notif);
                // context.read<NotificationProvider>().changeHasNotif = true;
              }
            });
            myUsappNotif.forEach((notif) {
              if (notif.notifDate == DateTime.now()) {
                context.read<NotificationProvider>().changeIsNotifClicked =
                    true;
                context.read<NotificationProvider>().myNotifNow.add(notif);
              }
            });
            int notifCount = myUsappNotif.length;
            return context.watch<NotificationProvider>().homeMsgNotifCount != 0
                ? GFBadge(
                    child: Text(
                      context
                          .watch<NotificationProvider>()
                          .homeMsgNotifCount
                          .toString(),
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
