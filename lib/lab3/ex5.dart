void main(){

  Settings a =
  Settings();

  Settings b =
  Settings();

  print(
      identical(a,b)
  );
}

/////////////////////////////////////

class Settings{

  static final Settings
  _instance =
  Settings._internal();

  Settings._internal();

  factory Settings(){

    return _instance;
  }

}