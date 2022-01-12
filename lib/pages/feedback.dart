// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

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
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text('Give Feedback!'),
              centerTitle: true,
            ),
            body: Text("this is the feedbacks page"),
          ),
        ],
      );
}
