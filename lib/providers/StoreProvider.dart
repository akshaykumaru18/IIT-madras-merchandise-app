import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class StoreProvider extends ChangeNotifier {
  StoreProvider(){
    fetchProducts();
  }
   List<Product> products = [
    // new Product("DSA Hoodie White", "Exclusive DSA Hoodie Grab Now",
    //     "assets/Icons/DS Front.png", 100.0),
    // new Product("DSA Hoodie Black", "Exclusive DSA Hoodie Grab Now",
    //     "assets/Icons/DS Back.png", 100.0,
    //     featured: true),
    // new Product("Data Science Hoodie", "Exclusive DSA Hoodie Grab Now",
    //     "assets/Icons/DSA Front.png", 100.0),
    // new Product("Diploma Hoodie", "Exclusive DSA Hoodie Grab Now",
    //     "assets/Icons/DWT Front.png", 100.0),
    // new Product("BSA Hoodie", "Exclusive DSA Hoodie Grab Now",
    //     "assets/Icons/ESDS Front.png", 100.0,
    //     featured: true),
  ];

  Future<void> fetchProducts() async {
    await FirebaseFirestore.instance
    .collection('Products')
    .get().then((value) {
        value.docs.forEach((doc) {
            Product product = new Product(
              doc['name'],
              doc['description'],
              doc['image'],
              double.parse(doc['price'].toString()),
              featured: doc['featured']);
            products.add(product);
        });
    });
    notifyListeners();
  }
  void updateCart(Product p){

    products.forEach((element) {
      if(element.name == p.name){
        element.addedToCart = !element.addedToCart;
           notifyListeners();
          
      }
     
    });
    
  }

  Future<void> purchase() async {
    //Payment Logic
  }
}

class Product {
  String name;
  String description;
  String image;
  double price;
  bool featured;
  bool addedToCart;
  Product(this.name, this.description, this.image, this.price,
      {this.featured = false, this.addedToCart = false});
}
