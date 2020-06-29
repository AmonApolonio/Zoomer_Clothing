/**
 * Created by Amon Apolonio
 * https://github.com/AmonApolonio
 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zoomerstore/datas/cart_product.dart';
import 'package:zoomerstore/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  UserModel user;

  List<CartProduct> products = [];
  String couponCode;
  int discountPercentage = 0;
  bool isLoading = false;

  CartModel(this.user){
    if(user.isLoggedIn()){
      _loadCartItems();
    }
  }

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

//Function to add a item to the cart, "both locally and virtually"
  void addCartItem(CartProduct cartProduct) {
    products.add(cartProduct);

    Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .add(cartProduct.toMap())
        .then((doc) {
      cartProduct.cid = doc.documentID;
    });
    notifyListeners();
  }

//Function to remove a item to the cart, "both locally and virtually"
  void removeCartItem(CartProduct cartProduct) {
    Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document(cartProduct.cid)
        .delete();

    products.remove(cartProduct);

    notifyListeners();
  }

//Function to drecrease the item cart amount, "both locally and virtually"
  void decProduct(CartProduct cartProduct) {
    cartProduct.quantity--;
    Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document(cartProduct.cid)
        .updateData(cartProduct.toMap());

    notifyListeners();
  }

//Function to increse the item cart amount, "both locally and virtually"
  void incProduct(CartProduct cartProduct) {
    cartProduct.quantity++;
    Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document(cartProduct.cid)
        .updateData(cartProduct.toMap());

    notifyListeners();
  }

//Function to set a coupon
  void setCoupon(String couponCode, int discountPercentage){
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

//Function to notify the part of the app that depends on this class data
  void updatePrices(){
    notifyListeners();
  }

//Function to get the products price
  double getProductsPrice(){
    double price = 0.0;
    for(CartProduct c in products){
      if(c.productData != null)
        price += c.quantity * c.productData.price;
    }
    return price;
  }

//Function to get discount value
  double getDiscount(){
    return getProductsPrice() * discountPercentage / 100;
  }

//Function to get the ship price, for now I just set 9.99 as standard, but it can be a price calculate based on the user location
  double getShipPrice(){
    return 9.99;
  }

//Function to send the order to the Firebase
  Future<String> finishOrder() async{
    if(products.length == 0) return null;

    isLoading = true;
    notifyListeners();

    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();
    
    DocumentReference refOrder = await Firestore.instance.collection("orders").add(
      {
        "clientId": user.firebaseUser.uid,
        "products": products.map((cartProduct)=>cartProduct.toMap()).toList(),
        "productsPrice": productsPrice,
        "shipPrice": shipPrice,
        "discount": discount,
        "totalPrice": productsPrice - discount + shipPrice,
        "status": 1,

      }
    );
    
    await Firestore.instance.collection("users").document(user.firebaseUser.uid)
        .collection("orders").document(refOrder.documentID).setData(
      {
        "orderId": refOrder.documentID,
      }
    );

    QuerySnapshot query = await Firestore.instance.collection("users")
        .document(user.firebaseUser.uid).collection("cart").getDocuments();

    for(DocumentSnapshot doc in query.documents){
      doc.reference.delete();
    }

    products.clear();
    couponCode = null;
    discountPercentage = 0;

    isLoading = false;
    notifyListeners();

    return refOrder.documentID;

  }

//Function to get the Firebase data and locate it on a map named "products"
  void _loadCartItems() async {
    QuerySnapshot query = await Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .getDocuments();

    products =
        query.documents.map((doc) => CartProduct.fromDocument(doc)).toList();

    notifyListeners();
  }
}
