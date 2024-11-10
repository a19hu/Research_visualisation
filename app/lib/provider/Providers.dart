import 'package:flutter/material.dart';

// Counter model
class Counter extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}

// User model
class User extends ChangeNotifier {
  String _name = "Guest";

  String get name => _name;

  void updateName(String newName) {
    _name = newName;
    notifyListeners();
  }
}


// Language model

class LanguageProvider extends ChangeNotifier {
  String _name = "English";

  String get name => _name;

  set updateLanguage(String newName) {
    _name = newName;
    notifyListeners();
  }

}

class UserProvider extends ChangeNotifier{
  String _name = 'user has not been registered';

  String get name => _name;
  set name ( String newName){
    _name = newName;
    notifyListeners();
  }

}