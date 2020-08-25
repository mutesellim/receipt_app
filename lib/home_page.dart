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
    Future<List> getList() async {
      List myList = [];
      await _firestore
          .document("receipts/allreceipts/receiptID/1")
          .get()
          .then((value) {
        myList.add(value.data["receiptTitle"]);
      });
      return myList;
    }

    final List suggestionList = [];
    return FutureBuilder(
        future: getList(),
        builder: (context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            suggestionList.add(snapshot.data.toString());
            return ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: goToDetail(),
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

  goToDetail() {
    //Navigator.push(_scaffoldKey.currentContext,
    //   MaterialPageRoute(builder: (context) => DetailPage(1)));
  }
}
