import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mvvm_counter/domain/data_providers/user_data_provider.dart';
import 'package:flutter_mvvm_counter/domain/entity/user.dart';

typedef UserServiceOnUpdate = void Function(User);

class UserService {
  // подпискка в обратную сторону
  final _userDataProvider = UserDataProvider();
  VoidCallback? _currentOnUpdate;
  // var _user = User(0);
  // User get user => _user;

  void startListenUser(UserServiceOnUpdate onUpdate){
    final currentOnUpdate = () {
      onUpdate(_userDataProvider.user);
    };
    _currentOnUpdate = currentOnUpdate;
    _userDataProvider.addListener(currentOnUpdate);
    onUpdate(_userDataProvider.user);
    _userDataProvider.openConnect();
  }

  void stopListenUser(){
    final currentOnUpdate = _currentOnUpdate;
    if(currentOnUpdate!=null){
      _userDataProvider.removeListener(currentOnUpdate);
    }
  }

  // Future<void> initialize() async {
  //   _user = await _userDataProvider.loadValue();
  // }

  // void incrementAge() {
  //   _user = user.copyWith(age: user.age+1);
  //   _userDataProvider.saveValue(_user);
  // }

  // void decrementAge() {
  //   _user = _user.copyWith(age: max(_user.age-1, 0));
  //   _userDataProvider.saveValue(_user);
  // }
}