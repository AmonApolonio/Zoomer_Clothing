/**
 * Created by Amon Apolonio
 * https://github.com/AmonApolonio
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoomerstore/models/cart_model.dart';
import 'package:zoomerstore/models/user_model.dart';
import 'package:zoomerstore/screens/home_screen.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(
        builder: (context,child, model){
          return ScopedModel<CartModel>(
            model: CartModel(model),
            child: MaterialApp(
              title: "Zoomer's Clothing",
              theme: ThemeData(
                primarySwatch: Colors.blue,
                primaryColor: Color.fromARGB(255, 4, 125, 141),
                accentColor: Color.fromARGB(255, 253, 191, 148),
                accentColorBrightness: Brightness.light,
              ),
              debugShowCheckedModeBanner: false,
              home: HomeScreen(),
            ),
          );
        },
      ),
    );
  }
}
