import 'package:flutter/cupertino.dart';
import '../Model/Product.dart';
import 'package:uuid/uuid.dart';

class Products with ChangeNotifier {
  List<Product> _products = [
    Product(
        id: Uuid().v1(),
        name: 'Fire Rod',
        unitName: 'kg',
        unitPrice: 200,
        category: 'rod',
        availableAmount: 300),
    Product(
        id: Uuid().v4(),
        name: 'Crown cement',
        unitName: 'bag',
        unitPrice: 50,
        category: 'cement',
        availableAmount: 500),
    Product(
        id: Uuid().v5(Uuid.NAMESPACE_URL, 'www.google.com'),
        name: 'shosta balu',
        unitName: 'kg',
        unitPrice: 50,
        category: 'balu',
        availableAmount: 5000),
    Product(
        id: Uuid().v5(Uuid.NAMESPACE_URL, 'www.facebook.com'),
        name: 'goru',
        unitName: 'piece',
        unitPrice: 10000,
        category: 'animal',
        availableAmount: 10),
    Product(
        id: Uuid().v5(Uuid.NAMESPACE_URL, 'www.twitter.com'),
        name: 'murgi',
        unitName: 'kg',
        unitPrice: 350,
        category: 'animal',
        availableAmount: 500),
    Product(
        id: Uuid().v5(Uuid.NAMESPACE_URL, 'www.instagram.com'),
        name: 'hash',
        unitName: 'kg',
        unitPrice: 50,
        category: 'animal',
        availableAmount: 200),
    Product(
        id: Uuid().v1(),
        name: 'vhera',
        unitName: 'piece',
        unitPrice: 2000,
        category: 'animal',
        availableAmount: 30),
  ];

  List<String> _categories = ['rod', 'balu', 'cement', 'animal'];

  void addCategory(String name) {
    for (int i = 0; i < categories.length; i++) {
      if (_categories[i] == name) {
        return;
      }
    }
    _categories.add(name);
    notifyListeners();
  }

  void updateProduct(Product temp, int index) {
    _products.removeAt(index);
    _products.add(new Product(
        availableAmount: temp.availableAmount,
        category: temp.category,
        id: temp.id,
        name: temp.name,
        unitName: temp.unitName,
        unitPrice: temp.unitPrice));
    notifyListeners();
  }

  Product getProductById(String id) {
    for (int i = 0; i < _products.length; i++) {
      if (_products[i].id == id) return _products[i];
    }
    return null;
  }

  List<String> get categories {
    return [..._categories];
  }

  bool checkDuplicate(String value) {
    for (int i = 0; i < _categories.length; i++) {
      if (_categories[i] == value) return true;
    }
    return false;
  }

  void addProduct(Product obj) {
    _products.add(obj);
    notifyListeners();
  }

  int getIndexById(String id) {
    for (int i = 0; i < _products.length; i++) {
      if (_products[i].id == id) return i;
    }
    return -1;
  }

  void callListener() {
    notifyListeners();
  }

  List<Product> getProductsbyCategory(String category) {
    return _products.where((element) => element.category == category).toList();
  }

  List<String> getProductsList() {
    return _products.map((item) {
      return item.name;
    }).toList();
  }

  Product getProductByName(String name) {
    for (int i = 0; i < _products.length; i++) {
      if (_products[i].name == name) return _products[i];
    }
    return null;
  }

  List<Product> get products {
    return [..._products];
  }
}
