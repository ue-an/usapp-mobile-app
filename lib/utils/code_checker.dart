// import 'package:flutter/material.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';
// import 'package:markdown/markdown.dart' as md;

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Mentions Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(title: 'Mentions Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   ///Default text to be shown initially
//   String _text = 'This is the default text';

//   ///This is the sender's name
//   String myName = 'Annsh Singh';

//   ///List of all the names in the group - Assuming here that you get this list in chat window
//   List<String> otherNamesList = ['Annsh Singh', 'Michael Scott', 'Dwight Schrute', "Jim Halpert"];

//   TextEditingController _textController;
//   FocusNode _focusNode;

//   @override
//   void initState() {
//     super.initState();
//     _textController = TextEditingController();
//     _focusNode = FocusNode();
//   }

//   @override
//   void dispose() {
//     _textController.dispose();
//     _focusNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: MarkdownBody(
//                 data: _replaceMentions(_text).replaceAll('\n', '\\\n'),
//                 onTapLink: (
//                   String link,
//                   String href,
//                   String title,
//                 ) {
//                   print('Link clicked with $link');
//                 },
//                 builders: {
//                   "coloredBox": ColoredBoxMarkdownElementBuilder(context, otherNamesList, myName),
//                 },
//                 inlineSyntaxes: [
//                   ColoredBoxInlineSyntax(),
//                 ],
//                 styleSheet: MarkdownStyleSheet.fromTheme(
//                   Theme.of(context).copyWith(
//                     textTheme: Theme.of(context).textTheme.apply(
//                           bodyColor: Colors.black,
//                           fontSizeFactor: 1,
//                         ),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 100,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     flex: 8,
//                     child: TextFormField(
//                       controller: _textController,
//                       focusNode: _focusNode,
//                       textCapitalization: TextCapitalization.sentences,
//                       maxLines: 2,
//                       minLines: 1,
//                       decoration: InputDecoration(
//                         contentPadding: EdgeInsets.symmetric(horizontal: 16),
//                         hintText: 'Write a message...',
//                         alignLabelWithHint: true,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(
//                             Radius.circular(32),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 1,
//                     child: GestureDetector(
//                       onTap: () async {
//                         if (_textController.value.text.isNotEmpty) {
//                           setState(() {
//                             _text = _textController.value.text;
//                           });
//                         }
//                       },
//                       child: Icon(
//                         Icons.send,
//                         size: 24,
//                         color: Colors.blue,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   ///Wrapping mentioned users with brackets to identify them easily
//   String _replaceMentions(String text) {
//     otherNamesList?.map((u) => u)?.toSet()?.forEach((userName) {
//       text = text.replaceAll('@$userName', '[@$userName]');
//     });
//     return text;
//   }
// }

// class ColoredBoxInlineSyntax extends md.InlineSyntax {
//   ColoredBoxInlineSyntax({
//     String pattern = r'\[(.*?)\]',
//   }) : super(pattern);

//   @override
//   bool onMatch(md.InlineParser parser, Match match) {
//     /// This creates a new element with the tag name `coloredBox`
//     /// The `textContent` of this new tag will be the
//     /// pattern match with the @ symbol
//     ///
//     /// We can change how this looks by creating a custom
//     /// [MarkdownElementBuilder] from the `flutter_markdown` package.
//     final withoutBracket1 = match.group(0).replaceAll('[', "");
//     final withoutBracket2 = withoutBracket1.replaceAll(']', "");
//     md.Element mentionedElement = md.Element.text("coloredBox", withoutBracket2);
//     print('Mentioned user ${mentionedElement.textContent}');
//     parser.addNode(mentionedElement);
//     return true;
//   }
// }

// class ColoredBoxMarkdownElementBuilder extends MarkdownElementBuilder {
//   final BuildContext context;
//   final List<String> mentionedUsers;
//   final String myName;

//   ColoredBoxMarkdownElementBuilder(this.context, this.mentionedUsers, this.myName);

//   ///This method would help us figure out if the text element needs styling
//   ///The background color of the text would be Color(0xffDCECF9) if it is the
//   ///sender's name that is mentioned in the text, otherwise it would be transparent
//   Color _backgroundColorForElement(String text) {
//     Color color = Colors.transparent;
//     if (mentionedUsers != null) {
//       if (mentionedUsers.contains(myName) && text.contains(myName)) {
//         color = Color(0xffDCECF9);
//       } else {
//         color = Colors.transparent;
//       }
//     }
//     return color;
//   }

//   ///This method would help us figure out if the text element needs styling
//   ///The text color would be blue if the text is a user's name and is mentioned
//   ///in the text
//   Color _textColorForBackground(Color backgroundColor, String textContent) {
//     return checkIfFormattingNeeded(textContent) ? Colors.blue : Colors.black;
//   }

//   @override
//   Widget visitElementAfter(md.Element element, TextStyle preferredStyle) {
//     return Container(
//       margin: EdgeInsets.only(left: 0, right: 0, top: 2, bottom: 2),
//       decoration: element.textContent.contains(myName)
//           ? BoxDecoration(
//               borderRadius: BorderRadius.all(Radius.circular(8.0)),
//               color: _backgroundColorForElement(element.textContent),
//             )
//           : null,
//       child: Padding(
//         padding: element.textContent.contains(myName) ? EdgeInsets.all(4.0) : EdgeInsets.all(0),
//         child: Text(
//           element.textContent,
//           style: TextStyle(
//             color: _textColorForBackground(
//               _backgroundColorForElement(
//                 element.textContent.replaceAll('@', ''),
//               ),
//               element.textContent.replaceAll('@', ''),
//             ),
//             fontWeight: checkIfFormattingNeeded(
//               element.textContent.replaceAll('@', ''),
//             )
//                 ? FontWeight.w600
//                 : FontWeight.normal,
//           ),
//         ),
//       ),
//     );
//   }

//   bool checkIfFormattingNeeded(String text) {
//     var checkIfFormattingNeeded = false;
//     if (mentionedUsers != null && mentionedUsers.isNotEmpty) {
//       if (mentionedUsers.contains(text) || mentionedUsers.contains(myName)) {
//         checkIfFormattingNeeded = true;
//       } else {
//         checkIfFormattingNeeded = false;
//       }
//     }
//     return checkIfFormattingNeeded;
//   }
// }