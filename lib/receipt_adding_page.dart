import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReceiptAddingPage extends StatefulWidget {
  @override
  _ReceiptAddingPageState createState() => _ReceiptAddingPageState();
}

class _ReceiptAddingPageState extends State<ReceiptAddingPage> {
  var _formKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  final Firestore _firestore = Firestore.instance;
  Map<String, dynamic> _myCounter = Map();
  Map<String, dynamic> _myReceipts = Map();
  String _receiptTitle, _receiptDescription, _videoURL, _pictureURL;
  int _counter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCounter().then((value) => _counter = value);
  }

  Future<int> getCounter() async {
    int counter;
    await _firestore.document("receipts/allreceipts/").get().then((value) {
      counter = value.data["receiptCount"];
    });
    return counter;
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
                      Navigator.pop(context);
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
                        _myCounter["receiptCount"] = _counter;

                        _firestore
                            .document(
                                "receipts/allreceipts/receiptID/$_counter")
                            .setData(_myReceipts);

                        _firestore
                            .document("receipts/allreceipts/")
                            .setData(_myCounter);
                        _incrementCounter();

                        Future.delayed(const Duration(seconds: 2),
                            () => _formKey.currentState.reset());
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text("Tarif Eklendi"),
                          duration: Duration(seconds: 2),
                        ));
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

  void _incrementCounter() {
    _counter++;
  }
}
