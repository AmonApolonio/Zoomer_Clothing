/**
 * Created by Amon Apolonio
 * https://github.com/AmonApolonio
 */

import 'package:flutter/material.dart';
import 'package:zoomerstore/screens/cart_screen.dart';

class CartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(
        Icons.shopping_cart,
        color: Colors.white,
      ),
      onPressed: (){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context)=>CartScreen())
        );
      },
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
