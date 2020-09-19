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
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height/3;
    return FutureBuilder(
      future: getCounter(),
      builder: (context, AsyncSnapshot<int> snapshot) {
        if (snapshot.hasData) {
          return GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
            itemCount: snapshot.data + 1,
            itemBuilder: (context, index) {
              Future<String> getPictureURL() async {
                String title;
                await _firestore
                    .document(
                        "receipts/allreceipts/receiptID/" + index.toString())
                    .get()
                    .then((value) {
                  title = value.data["pictureURL"];
                });
                return title;
              }

              Future<String> getReceiptTitle() async {
                String title;
                await _firestore
                    .document(
                        "receipts/allreceipts/receiptID/" + index.toString())
                    .get()
                    .then((value) {
                  title = value.data["receiptTitle"];
                });
                return title;
              }

              Future<dynamic> getURL(String data) async {
                var url = await _firebaseStorage
                    .ref()
                    .child("" + data)
                    .getDownloadURL();
                return url;
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailPage(index)));
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
                                        return Image.network(snapshot.data,width: _width,height: _height,);
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
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
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
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
