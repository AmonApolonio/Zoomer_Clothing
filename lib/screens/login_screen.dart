/**
 * Created by Amon Apolonio
 * https://github.com/AmonApolonio
 */

import 'package:flutter/material.dart';
import 'package:zoomerstore/models/user_model.dart';
import 'package:zoomerstore/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Entrar"),
          centerTitle: true,
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 500),
                      transitionsBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation,
                          Widget child) {
                        return SlideTransition(
                          position: new Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: new SlideTransition(
                            position: new Tween<Offset>(
                              begin: Offset.zero,
                              end: const Offset(1.0, 0.0),
                            ).animate(secondaryAnimation),
                            child: child,
                          ),
                        );
                      },
                      pageBuilder: (
                        BuildContext context,
                        Animation<double> animation,
                        Animation<double> secAnimation,
                      ) {
                        return SignupScreen();
                      }),
                );
              },
              child: Text(
                "CRIAR CONTA",
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body:
            ScopedModelDescendant<UserModel>(builder: (context, child, model) {
          if (model.isLoading)
            return Center(
              child: CircularProgressIndicator(),
            );
          else
            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    validator: (text) {
                      if (text.isEmpty || !text.contains("@"))
                        return "Email inválido!";
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "E-mail",
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    controller: _passController,
                    validator: (text) {
                      if (text.isEmpty || text.length < 6)
                        return "Senha inválida";
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Senha",
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        if(_emailController.text.isEmpty)
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text("Insira seu email para recuperação"),
                              backgroundColor: Colors.redAccent,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        else{
                          model.recoverPass(_emailController.text);
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text("Confira seu email!"),
                              backgroundColor: Theme.of(context).primaryColor,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      child: Text(
                        "Esqueci minha senha",
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  SizedBox(
                    height: 44.0,
                    child: RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                        }
                        model.signIn(
                          email: _emailController.text,
                          pass: _passController.text,
                          onSuccess: _onSuccess,
                          onFail: _onFail,
                        );
                      },
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: Text(
                        "Entrar",
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
        }));
  }

  void _onSuccess() {
    Navigator.of(context).pop();
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Falha ao Entrar!"),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
