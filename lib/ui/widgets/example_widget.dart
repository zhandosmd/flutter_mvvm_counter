import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/services/user_service.dart';

class ViewModelState{
  final String ageTitle;

  ViewModelState({
    required this.ageTitle,
  });
}

class ViewModel extends ChangeNotifier{
  final _userService = UserService();
  
  var _state = ViewModelState(ageTitle: '');
  ViewModelState get state => _state;

  ViewModel(){
    loadValue();
  }

  Future<void> loadValue() async{
    await _userService.initialize();
    _updateState();
  }

  Future<void> onIncrementButtonPressed() async{
    _userService.incrementAge();
    _updateState();
  }

  Future<void> onDecrementButtonPressed() async{
    _userService.decrementAge();
    _updateState();
  }

  void _updateState(){
    final user = _userService.user;

    _state = ViewModelState(ageTitle: user.age.toString(),);
    notifyListeners();
  }
}

class ExampleWidget extends StatelessWidget {
  const ExampleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                _AgeTitle(),
                _AgeIncrementWidget(),
                _AgeDecrementWidget(),
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
    final ageTitle = context.select((ViewModel vm) => vm.state.ageTitle);
    return Text(ageTitle);
  } 
}

class _AgeIncrementWidget extends StatelessWidget {
  const _AgeIncrementWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ViewModel>();
    return ElevatedButton(
      onPressed: viewModel.onIncrementButtonPressed,
      child: const Text('+'),
    );
  }
}

class _AgeDecrementWidget extends StatelessWidget {
  const _AgeDecrementWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ViewModel>();
    return ElevatedButton(
      onPressed: viewModel.onDecrementButtonPressed,
      child: const Text('-'),
    );
  }
}

