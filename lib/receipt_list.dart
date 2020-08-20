import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cook_book/receipt_detail_page.dart';
import 'package:path_provider/path_provider.dart';

class MyStorage {
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
}

class ReceiptsList extends StatefulWidget {
  final MyStorage storage;

  ReceiptsList({Key key, @required this.storage}) : super(key: key);

  @override
  _ReceiptsListState createState() => _ReceiptsListState();
}

final Firestore _firestore = Firestore.instance;

class _ReceiptsListState extends State<ReceiptsList> {
  int myCounter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.storage.readCounter().then((value) {setState(() {
      myCounter= value;
    });});
  }

  @override
  Widget build(BuildContext context) {
    double myWidth = MediaQuery.of(context).size.width;

    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
      itemCount: myCounter,
      itemBuilder: (context, index) {
        Future<String> getPictureURL() async {
          String title;
          await _firestore
              .document("receipts/allreceipts/receiptID/" + index.toString())
              .get()
              .then((value) {
            title = value.data["pictureURL"];
          });
          return title;
        }

        Future<String> getReceiptTitle() async {
          String title;
          await _firestore
              .document("receipts/allreceipts/receiptID/" + index.toString())
              .get()
              .then((value) {
            title = value.data["receiptTitle"];
          });
          return title;
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DetailPage(index)));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: FutureBuilder(
                      future: getPictureURL(),
                      builder: (context, AsyncSnapshot<String> snapshot) {
                        if (snapshot.hasData) {
                          return Image.asset(
                            "assets/" + snapshot.data,
                            //height: myHeight,
                            width: myWidth,
                            fit: BoxFit.contain,
                          );
                        } else
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                      },
                    ),
                  ),
                  FutureBuilder(
                      future: getReceiptTitle(),
                      builder: (context, AsyncSnapshot<String> snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data + " Altbaşlık",
                            maxLines: 2,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                            textAlign: TextAlign.center,
                          );
                        } else
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                      }),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
