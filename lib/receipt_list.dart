import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cook_book/receipt_detail_page.dart';

class ReceiptsList extends StatefulWidget {
  @override
  _ReceiptsListState createState() => _ReceiptsListState();
}

final Firestore _firestore = Firestore.instance;


class _ReceiptsListState extends State<ReceiptsList> {
  @override
  Widget build(BuildContext context) {
    double myWidth = MediaQuery.of(context).size.width;

    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),itemCount:3 ,
      itemBuilder: (context, index) {
        Future<String> getPictureURL() async {
          String title;
          await _firestore
              .document(
                  "receipts/allreceipts/receiptID/" + (index + 1).toString())
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
                  "receipts/allreceipts/receiptID/" + (index + 1).toString())
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailPage(index + 1)));
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
