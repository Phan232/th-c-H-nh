void main() async {

  Stream<int> numbers =
  Stream.fromIterable(
      [1,2,3,4,5]
  );

  await numbers
      .map(
          (n)=>n*n
  )
      .where(
          (n)=>n%2==0
  )
      .forEach(
          (n){

        print(
            "Output:$n"
        );

      });
}