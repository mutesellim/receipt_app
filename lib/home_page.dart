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

Future<int> getCounter() async {
  int counter;
  await _firestore.document("receipts/allreceipts/").get().then((value) {
    counter = value.data["receiptCount"];
  });
  return counter;
}

var _scaffoldKey = GlobalKey<ScaffoldState>();

class _HomePageState extends State<HomePage> {
  int myCounter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCounter().then((value) => myCounter = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                    context: context, delegate: ReceiptSearch(myCounter));
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
        child: ReceiptsList(),
      ),
    );
  }
}

class ReceiptSearch extends SearchDelegate<List> {
  int counter;

  ReceiptSearch(this.counter);

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
    Future<List> getList() async {
      List myList = [];
      for (int i = 0; i <= counter; i++) {
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
            final List suggestionList =
                snapshot.data.where((e) => e == query).toList();
            return ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DetailPage(snapshot.data.indexOf(query)))),
                    leading: Icon(Icons.local_dining),
                    title: Text(suggestionList[index]));
              },
              itemCount: suggestionList.length,
            );
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    Future<List> getList() async {
      List myList = [];
      for (int i = 0; i <= counter; i++) {
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
            final List suggestionList = query.isEmpty
                ? snapshot.data
                : snapshot.data.where((e) => e == query).toList();

            return ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailPage(query.isEmpty
                              ? index
                              : snapshot.data.indexOf(query)))),
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
