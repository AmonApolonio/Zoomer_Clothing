/**
 * Created by Amon Apolonio
 * https://github.com/AmonApolonio
 */

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:zoomerstore/datas/cart_product.dart';
import 'package:zoomerstore/datas/product_data.dart';
import 'package:zoomerstore/models/cart_model.dart';
import 'package:zoomerstore/models/user_model.dart';
import 'package:zoomerstore/screens/cart_screen.dart';
import 'package:zoomerstore/screens/login_screen.dart';

class ProductScreen extends StatefulWidget {
  final ProductData product;

  ProductScreen(this.product);

  @override
  _ProductScreenState createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductData product;
  String size;
  String color;

  _ProductScreenState(this.product);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        centerTitle: true,
      ),
      body: Builder(
          builder: (context) => ListView(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 0.9,
                child: Carousel(
                  images: product.images.map((url) {
                    return NetworkImage(url);
                  }).toList(),
                  dotSize: 4.0,
                  dotSpacing: 15.0,
                  dotBgColor: Colors.transparent,
                  dotColor: primaryColor,
                  autoplay: false,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      product.title,
                      maxLines: 3,
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "R\$ ${product.price.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      "Tamanho",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 34.0,
                      child: GridView(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        scrollDirection: Axis.horizontal,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 0.5,
                        ),
                        children: product.sizes.map((s) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (size != s){
                                  size = s;
                                } else {
                                  size = null;
                                }
                              });
                            },
                            child: Container(
                              width: 50.0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                                border: Border.all(
                                  color:
                                  s == size ? primaryColor : Colors.grey[500],
                                  width: 3.0,
                                ),
                              ),
                              child: Text(s),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      "Cor",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 34.0,
                      child: GridView(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        scrollDirection: Axis.horizontal,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 0.317,
                        ),
                        children: product.colors.map((c) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (color != c){
                                  color = c;
                                } else {
                                  color = null;
                                }

                              });
                            },
                            child: Container(
                              width: 50.0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                                border: Border.all(
                                  color:
                                  c == color ? primaryColor : Colors.grey[500],
                                  width: 3.0,
                                ),
                              ),
                              child: Text(c),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    SizedBox(
                      height: 44.0,
                      child: RaisedButton(
                        onPressed: size != null && color != null
                            ? () {
                          if (UserModel.of(context).isLoggedIn()) {

                            CartProduct cartProduct = CartProduct();
                            cartProduct.size = size;
                            cartProduct.quantity = 1;
                            cartProduct.pid = product.id;
                            cartProduct.category = product.category;
                            cartProduct.productData = product;

                            CartModel.of(context).addCartItem(cartProduct);

                            Scaffold.of(context).showSnackBar(
                                SnackBar(content: Text("Item adicionado ao carrinho"),
                                  backgroundColor: Theme.of(context).primaryColor,
                                  duration: Duration(seconds: 2),)
                            );

                            setState(() {
                              size = null;
                              color = null;
                            });

                            Future.delayed(const Duration(milliseconds: 1500), (){
                              Navigator.of(context).pushReplacement(MaterialPageRoute(
                                  builder: (context) => CartScreen()));
                            }
                            );


                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                          }
                        }
                            : null,
                        color: primaryColor,
                        textColor: Colors.white,
                        child: Text(
                          UserModel.of(context).isLoggedIn()
                              ? "Adicionar ao Carrinho"
                              : "Entre para comprar",
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      "Descrição",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      product.description,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ),
    );
  }
}
