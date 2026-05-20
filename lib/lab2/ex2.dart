// =======================================
// Exercise 2 – Collections & Operators
// =======================================

void main() {
  // List
  List<int> numbers = [10, 20, 30, 40];

  print("Original List: $numbers");

  // Access by index
  print("First element: ${numbers[0]}");

  // Add value
  numbers.add(50);
  print("After add: $numbers");

  // Remove value
  numbers.remove(20);
  print("After remove: $numbers");

  // Operators
  int a = 10;
  int b = 5;

  print("Addition: ${a + b}");
  print("Subtraction: ${a - b}");
  print("a == b : ${a == b}");
  print("Logical AND: ${(a > b) && (b > 0)}");

  // Ternary operator
  String result = (a > b) ? "a is bigger" : "b is bigger";
  print(result);

  // Set
  Set<int> uniqueNumbers = {1, 2, 2, 3, 4};

  print("Set values: $uniqueNumbers");

  // Map
  Map<String, String> student = {
    "name": "Quynh Anh",
    "major": "Software Engineering"
  };

  print("Student Map: $student");

  // Access map value
  print("Student name: ${student["name"]}");
}