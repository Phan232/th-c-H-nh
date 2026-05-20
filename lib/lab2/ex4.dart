// =======================================
// Exercise 4 – Intro to OOP
// =======================================

void main() {
  // Create Car object
  Car car1 = Car("Toyota");
  car1.displayInfo();

  // Create object with named constructor
  Car car2 = Car.named();
  car2.displayInfo();

  // Create ElectricCar object
  ElectricCar tesla = ElectricCar("Tesla", 95);
  tesla.displayInfo();
}

// Parent class
class Car {
  String brand;

  // Constructor
  Car(this.brand);

  // Named constructor
  Car.named() : brand = "Unknown Brand";

  // Method
  void displayInfo() {
    print("Car brand: $brand");
  }
}

// Child class
class ElectricCar extends Car {
  int batteryLevel;

  // Constructor
  ElectricCar(String brand, this.batteryLevel) : super(brand);

  // Override method
  @override
  void displayInfo() {
    print("Electric Car: $brand");
    print("Battery Level: $batteryLevel%");
  }
}