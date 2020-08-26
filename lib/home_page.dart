import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cook_book/admin_login_page.dart';
import 'package:flutter_cook_book/receipt_detail_page.dart';
import 'package:flutter_cook_book/receipt_list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

final Firestore _firestore = Firestore.instance;
var _scaffoldKey = GlobalKey<ScaffoldState>();

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: ReceiptSearch());
              }),
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text("Admin Login"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminLogin()));
                    },
                  ),
                )
              ];
            },
          )
        ],
        title: Text("Ana Sayfa"),
      ),
      body: Center(
        child: ReceiptsList(
          storage: MyStorage(),
        ),
      ),
    );
  }
}

class ReceiptSearch extends SearchDelegate<List> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var list = [0, 1, 2, 3];

    Future<List> getList() async {
      List myList = [];
      for (int i = 0; i < list.length; i++) {
        await _firestore
            .document("receipts/allreceipts/receiptID/$i")
            .get()
            .then((value) {
          myList.add(value.data["receiptTitle"]);
        });
      }
      return myList;
    }

    return FutureBuilder(
        future: getList(),
        builder: (context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            final List suggestionList = [];
            suggestionList.addAll(snapshot.data);
            return ListView.builder(
              itemBuilder: (context, index) {
              return ListTile(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailPage(index))),
                        leading: Icon(Icons.local_dining),
                        title: Text(suggestionList[index]),
                      );
              },
              itemCount: suggestionList.length,
            );
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
        });
  }
}
