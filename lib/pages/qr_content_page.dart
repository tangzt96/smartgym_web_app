// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_web/models/activesgqr.dart';
import 'package:hive/hive.dart';
import 'package:zxing2/qrcode.dart';
import 'package:image/image.dart' as img;

late String selectedId = "";
List<String> _options = <String>[];

class QrPage2 extends StatefulWidget {
  //const ({ Key? key }) : super(key: key);
  @override
  _QrPageState2 createState() => _QrPageState2();
}

class _QrPageState2 extends State<QrPage2> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingValue textEditingValue = TextEditingValue();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollingController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey _autocompleteKey = GlobalKey();
  late Future<String> _pickImages;
  late Timer timer;
  String activeIdField = 'No uploads detected';
  String activeid = "";
  bool showQr = false;

  @override
  void initState() {
    // TODO: implement initState
    // timer = Timer.periodic(
    //     Duration(hours: 2),
    //     (Timer t) => setState(() {
    //           showQr = false;
    //         }));
    super.initState();
    getActiveIDs();
    Future(_showDialog);
  }

  @override
  void dispose() {
    Hive.box('activelistbox').close();
    super.dispose();
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

  Future updateActiveIDs() async {
    var box = await Hive.openBox('activelistbox');
    var values = box.get('user');
    var templist = new List<String>.from(values);
    var combinedList = [...templist, ..._options].toSet().toList();
    box.put('user', combinedList);
    _options = combinedList;
    //print(combinedList);
  }

  //Convert ActiveSG id into JWT tokenish form
  static String _encodeActiveID(String activeid) {
    DateTime now = DateTime.now();
    ActiveSgQR activeSgData = ActiveSgQR(id: activeid, datetime: now);
    var activeIdJson = activeSgData.toJson2();
    //print(activeIdJson);
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(activeIdJson);
    String header = 'ACTIVESGV1|.';
    String footer = '.';
    String claim = header + encoded + footer;
    //String claim = header + activeIdJson;
    //print(claim);
    return claim;
  }

  Future<String> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    // var picture =
    //     await ImagePickerPlugin().pickImage(source: ImageSource.gallery);
    var picture = await _picker.pickImage(source: ImageSource.gallery);
    if (picture != null) {
      Uint8List pickedFileBytes = await picture.readAsBytes();
      var image = img.decodeImage(pickedFileBytes);
      if (image != null) {
        LuminanceSource source = RGBLuminanceSource(image.width, image.height,
            image.getBytes(format: img.Format.abgr).buffer.asInt32List());
        var bitmap = BinaryBitmap(HybridBinarizer(source));
        var reader = QRCodeReader();
        var result = reader.decode(bitmap);
        var decodeList =
            decode(result.text); //gets the active id from decode result
        activeid = decodeList[0];
        var withinTime = decodeList[1];
        // print(activeid);
        // print(withinTime);
        if (withinTime == true) {
          // print("qr code within time");
          return activeid;
        } else {
          return "expired";
        }
      }
    } else {
      print("No qr code detected");
      return "Noqr";
    }
    return "no qr detected";
  }

  static List decode(String str) {
    var tempstring = str.split(".")[1]; //gets middle portion of jwt
    tempstring = utf8.decode(
        base64.decode(base64.normalize(tempstring))); //convert to string
    var json = jsonDecode(tempstring);
    // print("----DECODE------");
    // print(json);
    var id = json["id"];
    var time = json["timestamp"]; //timestamp here is in GMT +8
    DateTime qrcodetime = DateTime.parse(time);
    DateTime now = DateTime.now();

    // print("qr code local time: $time");
    // print("processed qr code time: $qrcodetime");
    qrcodetime = qrcodetime.toLocal(); //converts to local time
    // print('processed qr code time local: $qrcodetime');
    // print("local time now: $now");
    var now_minus1 = now.subtract(Duration(minutes: 59));
    // print("1 hour before: $now_minus1");
    print("is within 1 hour?:");
    print(qrcodetime.isAfter(now_minus1));
    return [id, qrcodetime.isAfter(now_minus1)];
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("How to obtain your ActiveSG ID"),
          content: Image.asset(
            "assets/images/active_steps.png",
            width: 0.7 * MediaQuery.of(context).size.width,
            height: 1.4 * MediaQuery.of(context).size.width,
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            ElevatedButton.icon(
              icon: Icon(Icons.close),
              label: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _expiredQrDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Your QR code has expired!☹️"),
          content: Text('Please upload a recent ActiveSG QR'),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            ElevatedButton.icon(
              icon: Icon(Icons.close),
              label: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _scrollDown() {
    _scrollingController.animateTo(
      _scrollingController.position.maxScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    updateActiveIDs();
    return Stack(
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
            key: _scaffoldKey,
            body: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                controller: _scrollingController,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 20, 0, 20),
                      child: RichText(
                          text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: const <TextSpan>[
                            TextSpan(
                                text: 'Step 1.',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: 'Upload your activsg qr screenshot here!')
                          ])),
                    ),
                    ElevatedButton.icon(
                        label: Text('Upload ActiveSG QR'),
                        icon: Icon(Icons.image),
                        onPressed: () {
                          pickImage().then((value) {
                            if (value == 'expired') {
                              _expiredQrDialog();
                            } else {
                              setState(() {
                                _textEditingController.text =
                                    activeid; //sets the value once user updates.
                                activeIdField = "Your Active ID: " + value;
                              });
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.orange.shade300,
                            shape: const StadiumBorder())),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 20, 0, 20),
                      child: RichText(
                          text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: const <TextSpan>[
                            TextSpan(
                                text: 'Step 2.',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                    'Retrieve your activesg id and enter below')
                          ])),
                    ),
                    Text(activeIdField),
                    SizedBox(height: 20),
                    Text("Enter Active SG ID: "),
                    Container(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        width: 0.7 * MediaQuery.of(context).size.width,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
                                  controller: _textEditingController,
                                  focusNode: _focusNode,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter ActiveSG id e.g 431233',
                                    border: OutlineInputBorder(),
                                  ),
                                  onFieldSubmitted: (String value) {
                                    RawAutocomplete.onFieldSubmitted<String>(
                                        _autocompleteKey);
                                  }),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: RawAutocomplete<String>(
                                  key: _autocompleteKey,
                                  focusNode: _focusNode,
                                  textEditingController: _textEditingController,
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
                                    return _options.reversed
                                        .where((String option) {
                                      return option.contains(
                                          textEditingValue.text.toLowerCase());
                                    }).toList();
                                  },
                                  optionsViewBuilder:
                                      (context, onSelected, options) => Align(
                                    alignment: Alignment.topLeft,
                                    child: Material(
                                      child: SizedBox(
                                        width: 0.7 *
                                            MediaQuery.of(context).size.width,
                                        child: ListView(
                                          children: options
                                              .map((e) => ListTile(
                                                    onTap: () => onSelected(e),
                                                    title: Text(e),
                                                  ))
                                              .toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ])),
                    StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  FocusScope.of(context).requestFocus(
                                      FocusNode()); //check if it works on phone keyboard :(
                                  setState(() {
                                    if (_textEditingController
                                            .text.isNotEmpty &&
                                        _textEditingController.text.length <
                                            8) {
                                      showQr = true;
                                      print("valid QR");
                                      if (!_options.contains(
                                          _textEditingController.text)) {
                                        _options
                                            .add(_textEditingController.text);
                                        updateActiveIDs();
                                      }
                                    } else {
                                      _scaffoldKey.currentState
                                          ?.showSnackBar(const SnackBar(
                                        content: Text(
                                            'Please enter valid activeID QR'),
                                        duration: Duration(seconds: 2),
                                      ));
                                      showQr = false;
                                      print('invalid QR');
                                    }
                                  });
                                  Timer(Duration(milliseconds: 150), () {
                                    _scrollDown();
                                  });
                                },
                                child: const Text('Generate QR code'),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.orange.shade300,
                                    shape: const StadiumBorder()))
                          ],
                        ),
                        showQr
                            ? Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.fromLTRB(20, 20, 0, 20),
                                    child: RichText(
                                        text: TextSpan(
                                            style: DefaultTextStyle.of(context)
                                                .style,
                                            children: const <TextSpan>[
                                          TextSpan(
                                              text: 'Step 3.',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          TextSpan(
                                              text:
                                                  'Scan your new qr at any of our tablets!')
                                        ])),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
                                    child: QrImage(
                                      data: _encodeActiveID(
                                          _textEditingController.text),
                                      size: 0.8 *
                                          MediaQuery.of(context).size.width,
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(height: 100),
                      ]);
                    })
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
