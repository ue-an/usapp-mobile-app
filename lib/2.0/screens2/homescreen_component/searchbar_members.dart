import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:provider/src/provider.dart';
import 'package:selection_menu/selection_menu.dart';
import 'package:usapp_mobile/2.0/models/direct_message.dart';
import 'package:usapp_mobile/2.0/providers2/directmessage_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/localdata_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/search_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/studentnumber_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/thread_provider2.dart';
import 'package:usapp_mobile/2.0/screens2/directmessages_screen2.dart';
import 'package:usapp_mobile/2.0/utils2/routes2.dart';
import 'package:usapp_mobile/models/student.dart';
import 'package:usapp_mobile/models/thread.dart';
import 'package:usapp_mobile/utils/routes.dart';

class SearchBarMembers extends StatelessWidget {
  BuildContext context;
  SearchBarMembers({
    required this.context,
  });
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<StudentNumber>>(
      future: context.read<StudentNumberProvider2>().fetchData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SelectionMenu<StudentNumber>(
            itemSearchMatcher: this.itemSearchMatcher,
            // Defaults to null, meaning search is disabled.
            // ItemSearchMatcher takes a searchString and an Item (FontColor in this example)
            // Returns true if searchString can be used to describe Item, else false.
            // Defined below for the sake of brevity.

            searchLatency: Duration(seconds: 1),
            // Defaults to const Duration(milliseconds: 500).
            // This is the delay before the SelectionMenu actually starts searching.
            // Since search is called for every character change in the search field,
            // it acts as a buffering time and does not perform search for every
            // character update during this time.

            itemsList: snapshot.data!,
            itemBuilder: itemBuilder,
            onItemSelected: onItemSelected,
            showSelectedItemAsTrigger: true,
            initiallySelectedItemIndex: snapshot.data!.length - 1,
          );
        }
        if (!snapshot.hasData) {
          return Center(
            child: Text('No data'),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }

  bool itemSearchMatcher(String? searchString, StudentNumber studentNumber) {
    return (studentNumber.firstName + ' ' + studentNumber.lastName)
        .toUpperCase()
        .contains(searchString!.trim().toUpperCase());
  }

  //region From Previous Example

  Widget itemBuilder(BuildContext context, StudentNumber studentNumber,
      OnItemTapped onItemTapped) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6!;

    return Material(
      color: Theme.of(context).cardColor,
      child: InkWell(
        onTap: onItemTapped,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                fit: FlexFit.tight,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    studentNumber.firstName + ' ' + studentNumber.lastName,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.read<SearchProvider2>().changeStudSearchText = '';
                },
                child: Icon(
                  Icons.close,
                  size: 18,
                ),
              )
              // Text(
              //   ('#' + color.hex!.toRadixString(16)).toUpperCase(),
              //   style: textStyle.copyWith(
              //     color: Colors.grey.shade600,
              //     fontSize: textStyle.fontSize! * 0.75,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  onItemSelected(StudentNumber studentNumber) {
    context.read<SearchProvider2>().changeStudSearchText =
        (studentNumber.firstName + ' ' + studentNumber.lastName);
  }

  //endregion
}
