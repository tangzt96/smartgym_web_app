// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'dart:js' as js;
import 'package:flutter_web/constants.dart' as Constants;

class FeedbacksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/images/gym_logo.png"), // <-- BACKGROUND IMAGE
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Image.asset(
              "assets/images/feedback_bg.png",
              fit: BoxFit.fitWidth,
              alignment: Alignment.bottomLeft,
            ),
          ),
          Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: Text('Give Feedback!'),
                centerTitle: true,
              ),
              body: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            padding: EdgeInsets.all(8),
                            child: Image.asset(
                              "assets/images/feedback.png",
                              width: 0.8 * MediaQuery.of(context).size.width,
                            ))
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Your feedback matters to us!",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text("Click the link below:",
                        style: TextStyle(fontSize: 20, color: Colors.black54)),
                    SizedBox(height: 10),
                    Link(
                        uri: Uri.parse(Constants.FEEDBACK_URL),
                        builder: (_, followLink) {
                          return GestureDetector(
                            onTap: followLink,
                            child: TextButton.icon(
                              label: Text('Provide Feedback',
                                  style: TextStyle(fontSize: 20)),
                              icon: Icon(Icons.link),
                              onPressed: () {
                                js.context.callMethod('open', [
                                  Constants.FEEDBACK_URL
                                ]); //<= find explanation below
                              },
                            ),
                          );
                        }),
                  ])),
        ],
      );
}
