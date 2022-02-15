import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/services/user_service.dart';

class _ViewModelState{
  final String ageTitle;

  _ViewModelState({
    required this.ageTitle,
  });
}

class _ViewModel extends ChangeNotifier{
  final _userService = UserService();

  var _state = _ViewModelState(ageTitle: '');
  _ViewModelState get state => _state;
  StreamSubscription? userSubscription;

  _ViewModel(){
    _state = _ViewModelState(
      ageTitle: _userService.user.age.toString(),
    );
    userSubscription = _userService.userStream.listen((user) {
      _state = _ViewModelState(
        ageTitle: _userService.user.age.toString(),
      );
      notifyListeners();
    });
    _userService.openConnect();
  }

  @override
  void dispose() {
    userSubscription?.cancel();
    _userService.closeConnect();
    super.dispose();
  }
}

class ExampleWidget extends StatelessWidget {
  const ExampleWidget({Key? key}) : super(key: key);

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => _ViewModel(),
      child: const ExampleWidget()
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<_ViewModel>();
    return Scaffold(
      body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                _AgeTitle(),
              ],
            ),
      )),
    );
  }
}

class _AgeTitle extends StatelessWidget {
  const _AgeTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ageTitle = context.select((_ViewModel vm) => vm.state.ageTitle);
    return Text(ageTitle);
  } 
}