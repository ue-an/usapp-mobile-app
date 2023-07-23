import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:usapp_mobile/2.0/screens2/swipe/swipe_provider2.dart';

class Page1 extends StatefulWidget {
  Page1({
    Key? key,
  }) : super(key: key);

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    // return GestureDetector(
    //   onPanUpdate: (details) {
    //     if (details.delta.dx > 0) {
    //       setState(() {
    //         // xOffset =
    //         context.read<SwipeProvider2>().changeXoffset = 350;
    //         // yOffset =
    //         context.read<SwipeProvider2>().changeYoffset = 100;
    //         // scaleFactor =
    //         context.read<SwipeProvider2>().changeScaleFactor = .8;
    //         //isDrawerOpen
    //         context.read<SwipeProvider2>().changeIsDrawerOpen = true;
    //       });

    //       print('swiped right');
    //       print(context.read<SwipeProvider2>().isDrawerOpen);
    //     }

    //     // Swiping in left direction.
    //     if (details.delta.dx < 0) {
    //       setState(() {
    //         // xOffset =
    //         context.read<SwipeProvider2>().changeXoffset = 0;
    //         // yOffset =
    //         context.read<SwipeProvider2>().changeYoffset = 0;
    //         // scaleFactor =
    //         context.read<SwipeProvider2>().changeScaleFactor = 1;
    //         // isDrawerOpen =
    //         context.read<SwipeProvider2>().changeIsDrawerOpen = false;
    //       });
    //       print('swiped left');
    //       print(context.read<SwipeProvider2>().isDrawerOpen);
    //     }
    //   },
    //   child:
    return AnimatedContainer(
      transform: Matrix4.translationValues(
          context.read<SwipeProvider2>().xOffset,
          context.read<SwipeProvider2>().yOffset,
          0)
        ..scale(context.read<SwipeProvider2>().scaleFactor)
        ..rotateY(context.read<SwipeProvider2>().isDrawerOpen ? -0.5 : 0),
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        // color: Colors.grey[200],
        // borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0.0),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 21,
            color: Colors.black.withOpacity(0.6),
          ),
        ],
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              // Topmost changing icon
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    context.watch<SwipeProvider2>().isDrawerOpen
                        // widget.isDrawerOpen
                        ? IconButton(
                            icon: const Icon(Icons.arrow_back_ios),
                            onPressed: () {
                              setState(() {
                                // xOffset =
                                context.read<SwipeProvider2>().changeXoffset =
                                    0;
                                // yOffset =
                                context.read<SwipeProvider2>().changeYoffset =
                                    0;
                                // scaleFactor =
                                context
                                    .read<SwipeProvider2>()
                                    .changeScaleFactor = 1;
                                // isDrawerOpen =
                                context
                                    .read<SwipeProvider2>()
                                    .changeIsDrawerOpen = false;
                              });
                            },
                          )
                        : IconButton(
                            icon: const Icon(Icons.menu),
                            onPressed: () {
                              setState(() {
                                // xOffset =
                                context.read<SwipeProvider2>().changeXoffset =
                                    350;
                                // yOffset =
                                context.read<SwipeProvider2>().changeYoffset =
                                    100;
                                // scaleFactor =
                                context
                                    .read<SwipeProvider2>()
                                    .changeScaleFactor = .8;
                                // isDrawerOpen =
                                context
                                    .read<SwipeProvider2>()
                                    .changeIsDrawerOpen = true;
                              });
                            }),
                  ],
                ),
              ),
              // Searchbar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(),
                  Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width / 5,
                            vertical: 12),
                        child: Text('Type here to search'),
                      )),
                  Icon(Icons.search),
                  // Icon(Icons.settings)
                ],
              ),
            ],
          ),
        ),
      ),
      // ),
    );
  }
}
