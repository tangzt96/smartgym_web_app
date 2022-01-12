import 'package:flutter/material.dart';
import 'package:flutter_web/main.dart';
import 'package:flutter_web/pages/about.dart';
import 'package:flutter_web/pages/events.dart';
import 'package:flutter_web/pages/feedback.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Drawer(
      child: Material(
        color: Colors.orange.shade800,
        child: ListView(padding: padding, children: <Widget>[
          const SizedBox(height: 20),
          buildMenuItem(
            text: 'QR login',
            icon: Icons.qr_code,
            onClicked: () => selectedItem(context, 0),
          ),
          const SizedBox(height: 20),
          buildMenuItem(
            text: 'About SmartGym',
            icon: Icons.info,
            onClicked: () => selectedItem(context, 1),
          ),
          const SizedBox(height: 20),
          buildMenuItem(
            text: 'Campaigns/Events',
            icon: Icons.event,
            onClicked: () => selectedItem(context, 2),
          ),
          const SizedBox(height: 20),
          buildMenuItem(
            text: 'Feedback',
            icon: Icons.feedback,
            onClicked: () => selectedItem(context, 3),
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white70),
          const SizedBox(height: 20)
        ]),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.orange.shade400;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MainPage(),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AboutPage(),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => EventsPage(),
        ));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FeedbacksPage(),
        ));
        break;
    }
  }
}
