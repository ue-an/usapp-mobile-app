import 'package:usapp_mobile/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        // child: Container(
        //   decoration: const BoxDecoration(
        //     gradient: LinearGradient(
        //       begin: Alignment.topRight,
        //       end: Alignment.bottomLeft,
        //       colors: [
        //         // Colors.cyan,
        //         Colors.blueAccent,
        //         Colors.cyanAccent,
        //       ],
        //     ),
        //   ),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                  side: const BorderSide(
                    color: Colors.blue,
                    width: 4.0,
                  ),
                ),
                borderOnForeground: true,
                elevation: 9,
                child: ListTile(
                  title: GFListTile(
                    title: Row(
                      children: [
                        const Text(
                          'Go to Main Chat',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const Expanded(
                          child: SizedBox(
                            width: 0,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.mainchats);
                          },
                          icon: const Icon(Icons.navigate_next),
                          iconSize: 40,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Routes.threads);
              },
              // child: GFCard(
              //   elevation: 9,
              //   boxFit: BoxFit.cover,
              //   title: GFListTile(
              //     title: const Text(
              //       'How difficult is the title defense?',
              //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              //     ),
              //     subTitle: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       children: const [
              //         Padding(
              //           padding: EdgeInsets.only(top: 20.0),
              //           child: Text('created by: Ian Aguinaldo'),
              //         ),
              //         SizedBox(
              //           width: 80.0,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                    side: const BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                  borderOnForeground: true,
                  elevation: 9,
                  child: ListTile(
                    title: GFListTile(
                      title: Row(
                        children: const [
                          Expanded(
                            child: Text(
                              'How difficult is the title defense?',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      subTitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Expanded(
                            child: Text(
                              'created by: Ian Aguinaldo',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 80.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                for (var i = 0; i < 6; i++)
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.threads);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                          side: const BorderSide(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                        ),
                        borderOnForeground: true,
                        elevation: 9,
                        child: ListTile(
                          title: GFListTile(
                            title: Row(
                              children: [
                                Text(
                                  'Thread ' + i.toString(),
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            subTitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Text(
                                    'created by: Student ' + i.toString(),
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 80.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        // ),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return SingleChildScrollView(
                child: Container(
                  height: h / 1.3,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Container(
                          margin: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: TextFormField(
                            //reference format
                            controller: TextEditingController()..text = "",

                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,

                            // controller: _collegeCtrl,
                            decoration: InputDecoration(
                              // labelText: '',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24.0),
                                borderSide: const BorderSide(
                                  width: 2,
                                  // color: Colors.blue,
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24.0),
                                borderSide: const BorderSide(
                                  width: 2,
                                  // color: Colors.blue,
                                  color: Colors.white,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                              ),
                              prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.only(right: 20, left: 20),
                                child: TextFormField(
                                  style: const TextStyle(color: Colors.white),
                                  //reference format

                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,

                                  // controller: _courseCtrl,
                                  decoration: InputDecoration(
                                    labelText: 'Thread Title',
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(24.0),
                                      borderSide: const BorderSide(
                                        width: 2,
                                        color: Colors.blue,
                                        // color: Colors.white,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(24.0),
                                      borderSide: const BorderSide(
                                        width: 2,
                                        color: Colors.blue,
                                        // color: Colors.white,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 24.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(
          Icons.add,
          size: 25,
        ),
      ),
    );
  }
}
