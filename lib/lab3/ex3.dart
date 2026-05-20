import 'dart:async';

void main(){

  print("Start");

  scheduleMicrotask((){

    print(
        "Microtask"
    );

  });

  Future((){

    print(
        "Future Event"
    );

  });

  print("End");
}