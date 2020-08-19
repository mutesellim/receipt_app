import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  var formKey = GlobalKey<FormState>();
  final Firestore firestore = Firestore.instance;
  Map<String, dynamic> myReceipts = Map();
  String receiptTitle, receiptDescription, videoURL, pictureURL;
  int counter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.storage.readCounter().then((int value) {
      setState(() {
        counter = value;
      });
    });
  }

  Future<File> _incrementCounter() {
    setState(() {
      counter++;
    });

    // Write the variable as a string to the file.
    return widget.storage.writeCounter(counter);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Receipt Adding Page"),
      ),
      body: Container(
        child: Form(
          key: formKey,
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
                    receiptTitle = text;
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
                    videoURL = text;
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
                    receiptDescription = text;
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
                    pictureURL = text;
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
                      Navigator.pop(context);
                    },
                    child: Text("Vazgeç"),
                  ),
                  RaisedButton(
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        formKey.currentState.save();
                        myReceipts["receiptTitle"] = receiptTitle;
                        myReceipts["receiptDescription"] = receiptDescription;
                        myReceipts["videoURL"] = videoURL;
                        myReceipts["pictureURL"] = pictureURL;

                        firestore
                            .document(
                                "receipts/allreceipts/receiptID/$counter")
                            .setData(myReceipts);
                        _incrementCounter();
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
