import 'package:flutter/material.dart';
import 'package:flutter_web/pages/qr_content_page.dart';
import 'Navigation_drawer_widget.dart';

void main() async {
  runApp(myApp());
}

class myApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        //debugShowCheckedModeBanner: false,
        title: 'SmartGym Web',
        theme: ThemeData(primarySwatch: Colors.orange, fontFamily: 'Lato'),
        home: Scaffold(body: MainPage()));
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40.0), // here the desired height
          child: AppBar(
            backgroundColor: Color(0xEEFF9243),
            title: Text("SmartGym Web"),
          ),
        ),
        drawer: NavigationDrawerWidget(),
        body: QrPage2(), //sets QR page as mainpage
      );
}

//flutter run -d chrome --web-port=1234 to run on fixed port