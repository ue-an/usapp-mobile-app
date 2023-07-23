import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _launchURL() async {
      const url = 'http://110.93.74.78/StudentEnrollment';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    final w = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('About URS'),
      ),
      // body: const Center(
      //   child: Text('URS'),
      // ),
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: [
            SizedBox(
              height: w / 20,
            ),
            GFAccordion(
              titleBorder: Border.all(color: Colors.blue, width: 2),
              title: 'URS Mission',
              content:
                  'The leading University in human resource development, knowledge and technology generation and environmental stewardship',
            ),
            GFAccordion(
              titleBorder: Border.all(color: Colors.blue, width: 2),
              title: 'URS Vision',
              content:
                  'The University of Rizal System is committed to nurture and produce upright and competent graduates and empowered community through relevant and sustainable higher professional and technical instruction, research, extension and production services.',
            ),
            GFAccordion(
              titleBorder: Border.all(color: Colors.blue, width: 2),
              title: 'URS Core Values',
              content:
                  'R - Responsiveness\nI - Integrity\nS - Services\nE Excellence\nS - Social Responsibility',
            ),
            GFAccordion(
              titleBorder: Border.all(color: Colors.blue, width: 2),
              title: 'Student Portal',
              // content:
              //     'R - Responsiveness\nI - Integrity\nS - Services\nE Excellence\nS - Social Responsibility',
              contentChild: ElevatedButton(
                onPressed: () {
                  _launchURL();
                },
                child: Text('Go to Portal'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
