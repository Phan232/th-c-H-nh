import 'dart:convert';

void main() async {

  List<User> users =
  await fetchUsers();

  users.forEach(print);
}

////////////////////////////////////////////////

class User {

  String name;
  String email;

  User(
      this.name,
      this.email
      );

  factory User.fromJson(
      Map<String,dynamic> json){

    return User(
        json["name"],
        json["email"]
    );
  }

  @override
  String toString() {

    return "User(name:$name,email:$email)";
  }
}

Future<List<User>>
fetchUsers() async {

  String jsonData='''

[
{"name":"Alice","email":"alice@gmail.com"},
{"name":"Bob","email":"bob@gmail.com"}

]

''';

  await Future.delayed(
      Duration(seconds:1));

  List decoded =
  jsonDecode(jsonData);

  return decoded
      .map(
          (e)=>
          User.fromJson(e))
      .toList();
}