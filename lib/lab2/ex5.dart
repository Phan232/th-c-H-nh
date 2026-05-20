// =======================================
// Exercise 5 – Async, Future, Null Safety
// =======================================

import 'dart:async';

void main() async {
  print("Loading data...");

  // Wait for async function
  String data = await fetchData();

  print(data);

  // NULL SAFETY
  String? nullableName;

  // ?? operator
  print(nullableName ?? "Default Name");

  nullableName = "Dart Student";

  // ! operator
  print(nullableName!.length);

  // ? operator
  print(nullableName?.toUpperCase());

  // STREAM
  Stream<int> numberStream =
  Stream.periodic(Duration(seconds: 1), (value) => value + 1).take(5);

  // Listen to stream values
  await for (int number in numberStream) {
    print("Stream value: $number");
  }
}

// Async function
Future<String> fetchData() async {
  // Simulate loading
  await Future.delayed(Duration(seconds: 2));

  return "Data loaded successfully!";
}