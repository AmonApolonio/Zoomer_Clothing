/**
 * Created by Amon Apolonio
 * https://github.com/AmonApolonio
 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zoomerstore/datas/product_data.dart';

class CartProduct{

  String cid;
  String category;
  String pid;
  int quantity;
  String size;

  ProductData productData;

  CartProduct(

      );

//Function to convert the data from the Firebase snapshot to local data in the CarttData class
  CartProduct.fromDocument(DocumentSnapshot document){
    cid = document.documentID;
    category = document.data["category"];
    pid = document.data["pid"];
    quantity = document.data["quantity"];
    size = document.data["size"];
  }


//Function to create a map containing the cart's product data
  Map<String, dynamic> toMap(){
    return{
      "category": category,
      "pid": pid,
      "quantity": quantity,
      "size": size,
      "product": productData.toResumeMap(),
    };
  }

}