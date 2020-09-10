import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cook_book/receipt_detail_page.dart';

class ReceiptsList extends StatefulWidget {
  @override
  _ReceiptsListState createState() => _ReceiptsListState();
}

final Firestore _firestore = Firestore.instance;

final FirebaseStorage _firebaseStorage = FirebaseStorage(
    app: Firestore.instance.app,
    storageBucket: 'gs://cookbook-453e5.appspot.com');

Future<int> getCounter() async {
  int counter;
  await _firestore.document("receipts/allreceipts/").get().then((value) {
    counter = value.data["receiptCount"];
  });
  return counter;
}

class _ReceiptsListState extends State<ReceiptsList> {
  int myCounter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCounter().then((value) => myCounter = (value+1));
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

        Future<dynamic> getURL(String data) async {
          var url =
              await _firebaseStorage.ref().child("" + data).getDownloadURL();
          return url;
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
                          return FutureBuilder(
                              future: getURL(snapshot.data),
                              builder: (context, AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  return Image.network(snapshot.data);
                                } else
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                              });
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
                            snapshot.data,
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
