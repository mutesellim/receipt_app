import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class ReceiptAddingPage extends StatefulWidget {
  @override
  _ReceiptAddingPageState createState() => _ReceiptAddingPageState();
}

class _ReceiptAddingPageState extends State<ReceiptAddingPage> {
  var formKey = GlobalKey<FormState>();
  final Firestore firestore = Firestore.instance;
  Map<String, dynamic> myReceipts = Map();
  int receiptCount = 1;
  String receiptTitle, receiptDescription, videoURL;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                        firestore
                            .document(
                                "receipts/allreceipts/receiptID/$receiptCount")
                            .setData(myReceipts);
                        receiptCount++;
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
