/**
 * Created by Amon Apolonio
 * https://github.com/AmonApolonio
 */

import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {

  String category;
  String id;

  String title;
  String description;

  double price;

  List images;
  List sizes;
  List colors;

//Function to convert the data from the Firebase snapshot to local data in the ProductData class
  ProductData.fromDocument(DocumentSnapshot snapshot){
    id = snapshot.documentID;
    title = snapshot.data["title"];
    description = snapshot.data["description"];
    price = snapshot.data["price"] + 0.0;
    images = snapshot.data["images"];
    sizes = snapshot.data["sizes"];
    colors = snapshot.data["colors"];
  }

//Function to create a map containing only the product title and price
  Map<String, dynamic> toResumeMap(){
    return{
      "title": title,
      "price": price,
    };
  }

}