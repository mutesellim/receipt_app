import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
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
                            return Image.asset(
                              "assets/" + snapshot.data,
                              width: myWidth,
                              height: myHeight,
                              fit: BoxFit.contain,
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
                        future: getReceiptTitle(),
                        builder: (context, AsyncSnapshot<String> snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
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
        .document("receipts/allreceipts/receiptID/1")
        .get()
        .then((value) {
      title = value.data["receiptTitle"];
    });
    return title;
  }

  Future<String> getReceiptDescription() async {
    String title;
    await _firestore
        .document("receipts/allreceipts/receiptID/1")
        .get()
        .then((value) {
      title = value.data["receiptDescription"];
    });
    return title;
  }

  Future<String> getReceiptURL() async {
    String title;
    await _firestore
        .document("receipts/allreceipts/receiptID/1")
        .get()
        .then((value) {
      title = value.data["receiptTitle"];
    });
    return title;
  }

  Future<String> getPictureURL() async {
    String title;
    await _firestore
        .document("receipts/allreceipts/receiptID/1")
        .get()
        .then((value) {
      title = value.data["pictureURL"];
    });
    return title;
  }
}
