// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'package:flutter/material.dart';
import 'package:flutter_web/models/person.dart';

List<Person> persons = [
  Person(
      name: "Tan Chin Hiong",
      profileImage: 'assets/images/smartgym-tan-chin-hiong.png',
      title: "Team Lead, System Architect"),
  Person(
      name: "Joaquin Sanchez",
      profileImage: 'assets/images/smartgym-joaquin-sanchez.png',
      title: "Systems and Sensors Engineer"),
  Person(
      name: "Siti Syafi'ah Binte Khairy",
      profileImage: 'assets/images/smartgym-syafiah-khairy.png',
      title: "Mechanical Design Engineer"),
  Person(
      name: "Caleb Lee",
      profileImage: 'assets/images/smartgym-caleb-lee.png',
      title: "Software Engineer "),
  Person(
      name: "Kelvin Ang",
      profileImage: 'assets/images/smartgym-kelvin-ang.png',
      title: "Software Engineer"),
];

Widget personDetailCard(Person) {
  return Padding(
    padding: EdgeInsets.all(8),
    child: Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.black12, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                        image: AssetImage(Person.profileImage),
                        fit: BoxFit.cover,
                      )),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(Person.name,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                  Text(Person.title,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ))
                ],
              )
            ],
          )),
    ),
  );
}

class AboutPage extends StatelessWidget {
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
              title: Text('About SmartGym'),
              centerTitle: true,
            ),
            body: Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Text(
                      "What is SmartGym?",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    const Text(
                        "SmartGym is a holistic fitness data platform that provides users with fitness insights measured through a series of connected sensors built into gym equipment. These sensors are currently installed on three types of gym equipment: 1) weight stack machines, 2) treadmills and 3) weighing machines. SmartGym equipment is currently deployed in three community gyms across Singapore – Our Tampines Hub, Jurong East and Heartbeat @ Bedok.",
                        style: TextStyle(fontSize: 15, height: 1.5)),
                    SizedBox(height: 10),
                    const Text(
                      "Weight Stack Machines",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    const Text(
                      "The SmartGym sensors are installed within the covers of the weight stack exteriors, are visible to users and help detect the weights lifted to accurately compute the number of repetitions done.",
                      style: TextStyle(fontSize: 15, height: 1.5),
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/images/smartgym-shoulder-press.png",
                        width: 0.8 * MediaQuery.of(context).size.width,
                        // height:  * MediaQuery.of(context).size.width,
                      ),
                    ),
                    SizedBox(height: 10),
                    const Text(
                      "SmartGym weighing scale",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    const Text(
                      "The SmartGym team has also made enhancements to weighing scales. First-time users will be asked to input their date of birth and height into our system, while repeat users simply have to log in. The weighing scale will measure the user’s weight and collect other body metrics such as body fat percentage and muscle mass. This data can be accessed via the Kiosk Console at ActiveSG gyms for now, but will be made available through the ActiveSG app in future.",
                      style: TextStyle(fontSize: 15, height: 1.5),
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/images/smartgym-weighing-scale.png",
                        width: 0.8 * MediaQuery.of(context).size.width,
                        // height:  * MediaQuery.of(context).size.width,
                      ),
                    ),
                    SizedBox(height: 10),
                    const Text(
                      "How Will SmartGym Benefit Users?",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    const Text(
                      "Where SmartGym separates itself from regular gym equipment is its ability to accurately monitor and store users’ data. In a typical gym, fitness equipment can only display workout information while it is being used and the information does not get stored thereafter. In contrast, SmartGym stores workout information that can be viewed at any time at any of the three SmartGym kiosks.",
                      style: TextStyle(fontSize: 15, height: 1.5),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/images/smartgym-console.png",
                        width: 0.8 * MediaQuery.of(context).size.width,
                        // height:  * MediaQuery.of(context).size.width,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(height: 10),
                    const Text(
                      "Team Members",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Column(
                        children: persons.map((p) {
                      return personDetailCard(p);
                    }).toList()),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
}
