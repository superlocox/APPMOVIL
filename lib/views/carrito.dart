

import 'package:flutter/foundation.dart';

class CartItem{
  final String id;
  final cart_product_name;
  final cart_product_picture;
  final cart_product_price;
  final cart_product_count;
  final total;

  CartItem({
    this.id,
    this.cart_product_name,
    this.cart_product_picture,
    this.cart_product_count,
    this.cart_product_price,
    this.total
 });
}

class Carrito with ChangeNotifier{
  Map<String,CartItem> _items = {};

 // final url = "https://sade-app.herokuapp.com/";
 // final url2 = "http://10.0.0.7:4000/";

  
  Map<String,CartItem> get items{
    return{..._items};
  }
  
  int get itemCount{
    return _items.length;
  }
  
  void addItems(String pdid, String name,  price, picture){
    if(_items.containsKey(pdid)){
      _items.update(pdid, (existingCartItem) => CartItem(
          id:existingCartItem.id,
          cart_product_name:existingCartItem.cart_product_name,
          cart_product_count: existingCartItem.cart_product_count+1,
          cart_product_price: existingCartItem.cart_product_price,
          cart_product_picture: existingCartItem.cart_product_picture

      )

      );

    }else{
      _items.putIfAbsent(pdid, () => CartItem(
        id: pdid,
        cart_product_name: name,
        cart_product_price: price,
        cart_product_count: 1,
          cart_product_picture: picture
      ));
    }
    notifyListeners();
  }

  void removeItem(String id){
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String id){
    if(!_items.containsKey(id)){
      return;
    }if(_items[id].cart_product_count>=1){

      _items.update(id, (existingCartItem) => CartItem(
          id:existingCartItem.id,
          cart_product_name:  existingCartItem.cart_product_name,
          cart_product_count: existingCartItem.cart_product_count-1,
          cart_product_price: existingCartItem.cart_product_price,
          cart_product_picture: existingCartItem.cart_product_picture
      )
      );

      if(_items[id].cart_product_count==0){
        removeItem(id);
      }

      notifyListeners();
    }





  }

  double get totalAmmount{
    var total = 0.0;
    _items.forEach((key, CartItem) {
      total+=CartItem.cart_product_price * CartItem.cart_product_count;
    });
    return total;
  }

  void clear(){
    _items= {};
    notifyListeners();
  }




  
}