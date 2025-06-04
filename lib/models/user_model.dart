class UserModel {
  static final UserModel _instance = UserModel._internal();
  
  factory UserModel() {
    return _instance;
  }
  
  UserModel._internal();
  
  String name = '';
  DateTime? birthDate;
  String? weton;
  int? neptuValue;
}
