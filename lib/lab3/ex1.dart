import 'dart:async';

void main() async {
  ProductRepository repo = ProductRepository();

  // Listen stream
  repo.liveAdded().listen((product) {
    print("New Product Added:");
    print(product);
  });

  // Get all products
  List<Product> products =
  await repo.getAll();

  print("Current Products:");

  products.forEach(print);

  // Add new product
  repo.addProduct(
      Product(3, "Tablet", 700));

  await Future.delayed(
      Duration(seconds: 1));
}

///////////////////////////////////////////////////

class Product {
  int id;
  String name;
  double price;

  Product(
      this.id,
      this.name,
      this.price);

  @override
  String toString() {
    return "Product(id:$id,name:$name,price:$price)";
  }
}

class ProductRepository {

  List<Product> products = [
    Product(1,"Laptop",1000),
    Product(2,"Phone",500)
  ];

  StreamController<Product>
  controller =
  StreamController.broadcast();

  Future<List<Product>>
  getAll() async {

    await Future.delayed(
        Duration(seconds:1));

    return products;
  }

  Stream<Product> liveAdded() {
    return controller.stream;
  }

  void addProduct(Product p){

    products.add(p);

    controller.add(p);
  }
}