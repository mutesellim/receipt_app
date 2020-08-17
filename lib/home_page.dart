import 'package:flutter/material.dart';
import 'package:flutter_cook_book/admin_login_page.dart';
import 'package:flutter_cook_book/receipt_list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text("Admin Girişi"),
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
