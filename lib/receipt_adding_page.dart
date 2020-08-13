import 'package:flutter/material.dart';
import 'package:flutter_cook_book/models/receipts.dart';
import 'package:flutter_cook_book/utils/database_helper.dart';

class ReceiptAddingPage extends StatefulWidget {
  @override
  _ReceiptAddingPageState createState() => _ReceiptAddingPageState();
}

class _ReceiptAddingPageState extends State<ReceiptAddingPage> {
  var formKey = GlobalKey<FormState>();
  List<Receipts> allReceipts;
  DatabaseHelper databaseHelper;
  String receiptTitle, receiptDescription, videoURL;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allReceipts = List<Receipts>();
    databaseHelper = DatabaseHelper();
    databaseHelper.getReceipts().then((receiptsMapList) {
      for (Map readMap in receiptsMapList) {
        allReceipts.add(Receipts.fromMap(readMap));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("asd"),
      ),
      body: allReceipts.length > 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
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
                              databaseHelper
                                  .addReceipt(Receipts(2,2,receiptTitle,
                                      receiptDescription, videoURL))
                                  .then((savedReceiptID) {
                                if (savedReceiptID != 0) {
                                  debugPrint(
                                      "gelen veri: $receiptTitle $receiptDescription $videoURL");
                                }
                              });
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
