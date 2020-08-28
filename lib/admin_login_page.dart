import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cook_book/receipt_adding_page.dart';

class AdminLogin extends StatefulWidget {
  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                          controller: _userNameController,
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
                        child: TextFormField(obscureText: true,
                          controller: _passwordController,
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
    String mail = _userNameController.text;
    String password = _passwordController.text;
    var authResult = await _auth
        .signInWithEmailAndPassword(
          email: mail,
          password: password,
        )
        .catchError((e) => _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("Kullanıcı Adı veya Şifre Hatalı"),
              duration: Duration(seconds: 2),
            )));

    if (_userNameController.text == mail &&
        _passwordController.text == password) {
      _userNameController.clear();
      _passwordController.clear();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ReceiptAddingPage(storage: CounterStorage())));
    }
  }
}
