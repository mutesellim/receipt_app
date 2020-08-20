import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cook_book/home_page.dart';
import 'package:path_provider/path_provider.dart';

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;

    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$counter');
  }
}

class ReceiptAddingPage extends StatefulWidget {
  final CounterStorage storage;

  ReceiptAddingPage({Key key, @required this.storage}) : super(key: key);

  @override
  _ReceiptAddingPageState createState() => _ReceiptAddingPageState();
}

class _ReceiptAddingPageState extends State<ReceiptAddingPage> {
  var _formKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  final Firestore _firestore = Firestore.instance;
  Map<String, dynamic> _myReceipts = Map();
  String _receiptTitle, _receiptDescription, _videoURL, _pictureURL;
  int _counter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.storage.readCounter().then((int value) {
      setState(() {
        _counter = value;
      });
    });
  }

  Future<File> _incrementCounter() {
    setState(() {
      _counter++;
    });

    // Write the variable as a string to the file.
    return widget.storage.writeCounter(_counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Receipt Adding Page"),
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (text) {
                    if (text.length < 2) {
                      return "En az 3 Karakter Giriniz";
                    }
                  },
                  onSaved: (text) {
                    _receiptTitle = text;
                  },
                  decoration: InputDecoration(
                      hintText: "Tarif Başlığını Giriniz",
                      labelText: "Başlık",
                      border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onSaved: (text) {
                    _videoURL = text;
                  },
                  decoration: InputDecoration(
                      hintText: "Video için URL Giriniz",
                      labelText: "URL",
                      border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onSaved: (text) {
                    _receiptDescription = text;
                  },
                  maxLines: 5,
                  decoration: InputDecoration(
                      hintText: "Tarif İçeriğini Giriniz",
                      labelText: "İçerik",
                      border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onSaved: (text) {
                    _pictureURL = text;
                  },
                  decoration: InputDecoration(
                      hintText: "Resim URL giriniz",
                      labelText: "PictureURL",
                      border: OutlineInputBorder()),
                ),
              ),
              ButtonBar(
                children: [
                  RaisedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    child: Text("Vazgeç"),
                  ),
                  RaisedButton(
                    onPressed: () {
                      final snackBar = SnackBar(content: Text("Tarif Eklendi"));
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        _myReceipts["receiptTitle"] = _receiptTitle;
                        _myReceipts["receiptDescription"] = _receiptDescription;
                        _myReceipts["videoURL"] = _videoURL;
                        _myReceipts["pictureURL"] = _pictureURL;

                        _firestore
                            .document(
                                "receipts/allreceipts/receiptID/$_counter")
                            .setData(_myReceipts);
                        _incrementCounter();
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text("Tarif Eklendi"),
                          duration: Duration(seconds: 1),
                        ));
                        _formKey.currentState.reset();
                      }
                    },
                    child: Text("Kaydet"),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
