// =======================================
// Exercise 3 – Control Flow & Functions
// =======================================

void main() {
  // IF ELSE
  int score = 85;

  if (score >= 90) {
    print("Grade A");
  } else if (score >= 75) {
    print("Grade B");
  } else {
    print("Grade C");
  }

  // SWITCH CASE
  int day = 3;

  switch (day) {
    case 1:
      print("Monday");
      break;

    case 2:
      print("Tuesday");
      break;

    case 3:
      print("Wednesday");
      break;

    default:
      print("Other day");
  }

  // FOR LOOP
  print("For loop:");

  for (int i = 1; i <= 5; i++) {
    print(i);
  }

  // FOR-IN LOOP
  List<String> fruits = ["Apple", "Banana", "Orange"];

  print("For-in loop:");

  for (String fruit in fruits) {
    print(fruit);
  }

  // forEach LOOP
  print("forEach loop:");

  fruits.forEach((fruit) {
    print(fruit);
  });

  // Function calls
  print("Sum: ${addNumbers(5, 7)}");

  print("Multiply: ${multiplyNumbers(3, 4)}");
}

// Normal function
int addNumbers(int a, int b) {
  return a + b;
}

// Arrow function
int multiplyNumbers(int a, int b) => a * b;