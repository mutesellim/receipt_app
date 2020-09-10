import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
  final int _index;

  DetailPage(this._index);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final Firestore _firestore = Firestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage(
      app: Firestore.instance.app,
      storageBucket: 'gs://cookbook-453e5.appspot.com');

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height / 3;
    double myWidth = MediaQuery.of(context).size.width * (5 / 6);

    return Scaffold(
        appBar: AppBar(
          title: FutureBuilder(
            future: getReceiptTitle(),
            builder: (context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data);
              } else
                return Center(
                  child: CircularProgressIndicator(),
                );
            },
          ),
        ),
        body: Center(
          child: Container(
            child: ListView(
              children: [
                Column(
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder(
                        future: getReceiptTitle(),
                        builder: (context, AsyncSnapshot<String> snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            );
                          } else
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder(
                        future: getVideoURL(),
                        builder: (context, AsyncSnapshot<String> snapshot) {
                          if (snapshot.hasData) {
                            return InkWell(
                              child: Text("Tarif Adresine Git",
                                  style: TextStyle(
                                    fontSize: 14,fontWeight: FontWeight.bold
                                  )),
                              onTap: () => launch(snapshot.data),
                            );
                          } else
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder(
                        future: getReceiptDescription(),
                        builder: (context, AsyncSnapshot<String> snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data,
                            );
                          } else
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  Future<String> getReceiptTitle() async {
    String title;
    await _firestore
        .document("receipts/allreceipts/receiptID/" + widget._index.toString())
        .get()
        .then((value) {
      title = value.data["receiptTitle"];
    });
    return title;
  }

  Future<String> getReceiptDescription() async {
    String title;
    await _firestore
        .document("receipts/allreceipts/receiptID/" + widget._index.toString())
        .get()
        .then((value) {
      title = value.data["receiptDescription"];
    });
    return title;
  }

  Future<String> getVideoURL() async {
    String title;
    await _firestore
        .document("receipts/allreceipts/receiptID/" + widget._index.toString())
        .get()
        .then((value) {
      title = value.data["videoURL"];
    });
    return title;
  }

  Future<String> getPictureURL() async {
    String title;
    await _firestore
        .document("receipts/allreceipts/receiptID/" + widget._index.toString())
        .get()
        .then((value) {
      title = value.data["pictureURL"];
    });
    return title;
  }

  Future<dynamic> getURL(String data) async {
    var url = await _firebaseStorage.ref().child("" + data).getDownloadURL();
    return url;
  }
}
