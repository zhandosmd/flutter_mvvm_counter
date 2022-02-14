import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mvvm_counter/domain/entity/user.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDataProvider extends ChangeNotifier{   // class to ChangeNotifier, but only one listener

  Timer? _timer;
  var _user = User(0);
  User get user => _user;   // value to ValueNotifier   watch&notify
                            // or stream of users  BEEST  generate,pause,join,transform, minus cannot see current value

  void openConnect(){
    if(_timer != null) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (_){
      _user = User(_user.age + 1);
      notifyListeners();
    });
  }

  void closeConnect(){
    _timer?.cancel();
    _timer = null;
  }


  // final sharedPreferences = SharedPreferences.getInstance();
  //
  // Future<User> loadValue() async{
  //   final age = (await sharedPreferences).getInt('age') ?? 0;
  //   return User(age);
  // }
  //
  // Future<void> saveValue(User user) async{
  //   (await sharedPreferences).setInt('age', user.age);
  // }
}