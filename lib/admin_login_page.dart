import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cook_book/receipt_adding_page.dart';
import 'package:flutter_cook_book/receipt_detail_page.dart';

class AdminLogin extends StatefulWidget {
  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var authResult;
  var firebaseUser;

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Kullanıcı Adı:",
                  ),
                  Container(
                    width: 200,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: TextFormField(
                          controller: userNameController,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Şifre:              ",
                  ),
                  Container(
                    width: 200,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: TextFormField(
                          controller: passwordController,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              RaisedButton(
                onPressed: () {
                  createUserWithEmailandPassword();
                },
                child: Text("Giriş Yap"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void createUserWithEmailandPassword() async {
    String mail = "mehmet@mehmet.com";
    String password = "12345678";
    var authResult = await _auth
        .signInWithEmailAndPassword(
          email: mail,
          password: password,
        )
        .catchError((e) => debugPrint("Error :" + e.toString()));
    var firebaseUser = authResult.user;

    if (userNameController.text == firebaseUser.email &&
        passwordController.text == firebaseUser.uid) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ReceiptAddingPage()));
    }
  }
}
