import 'package:flutter/material.dart';
import 'package:flutter_web/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:hive/hive.dart';
import 'package:flutter_web/Navigation_drawer_widget.dart';
import 'package:flutter_web/constants.dart' as CONSTANT;

List<String> _options = <String>[];

class TestPage extends StatefulWidget {
  const TestPage({
    Key? key,
  }) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late IO.Socket socket;
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late String machine_id;

  @override
  void initState() {
    super.initState();
    connectToServer();
    getActiveIDs();
    machine_id = "Kiosk|JE";
    print("----test----");
    print(CONSTANT.para);

    //sendMessage("hello from tablet!");
  }

  Future getActiveIDs() async {
    var box = await Hive.openBox('activelistbox');
    if (box.isEmpty) {
      box.put('user', _options);
    } else {
      var values = box.get('user');
      _options = new List<String>.from(values);
      // box.put('user', ['312321', '4521123']);
    }
  }

  //start of server
  void connectToServer() {
    try {
      // Configure socket transports must be sepecified
      socket = IO.io(BACKEND_SOCKET, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      // Connect to websocket
      socket.connect();

      // Handle socket events
      socket.on('connect', (_) => print('connect: ${socket.id}'));
      socket.on('location', handleLocationListen);
      socket.on('typing', handleTyping);
      socket.on('message', handleMessage);
      socket.on('disconnect', (_) => print('disconnect'));
      socket.on('fromServer', (_) => print(_));
    } catch (e) {
      print(e.toString());
    }
  }

  // Send Location to Server
  sendLocation(Map<String, dynamic> data) {
    socket.emit("location", data);
  }

  // Listen to Location updates of connected usersfrom server
  handleLocationListen(dynamic data) async {
    print(data);
  }

  // Send update of user's typing status
  sendTyping(bool typing) {
    socket.emit("typing", {
      "id": socket.id,
      "typing": typing,
    });
  }

  // Listen to update of typing status from connected users
  void handleTyping(dynamic data) {
    print(data);
  }

  // Send a Message to the server
  sendMessage(String message) {
    socket.emit(
      "message",
      {
        //"id": socket.id,
        "id": socket.id,
        "active_id": _options[0],
        "machine": machine_id, // Message to be sent
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  // Listen to all message events from connected users
  void handleMessage(dynamic data) {
    print(data);
  }
  //end of server

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0), // here the desired height
        child: AppBar(
          backgroundColor: Color(0xEEFF9243),
          title: Text("SmartGym Web"),
        ),
      ),
      drawer: NavigationDrawerWidget(),
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Target machine: " + CONSTANT.para),
          ElevatedButton(
              child: Text("Login"),
              onPressed: () {
                print(_options[0]);
                sendMessage("Login!");
              }),
          SizedBox(height: 10),
          ElevatedButton(
            child: Text("Exit"),
            onPressed: () {
              socket.disconnect();
            },
          ),
        ],
      )),
    );
  }
}
