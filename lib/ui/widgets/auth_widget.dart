import 'package:flutter/material.dart';
import 'package:flutter_mvvm_counter/domain/data_providers/auth_api_provider.dart';
import 'package:flutter_mvvm_counter/domain/services/auth_service.dart';
import 'package:flutter_mvvm_counter/ui/navigation/main_navigation.dart';
import 'package:provider/provider.dart';

enum _ViewModelAuthButtonState{ canSubmit, authProcess, disable}

class _ViewModelState{
  String authErrorTitle = '';
  String login = '';
  String password = '';
  bool isAuthInProcess = false;
  _ViewModelAuthButtonState get authButtonState{
    if(isAuthInProcess){
      return _ViewModelAuthButtonState.authProcess;
    }else if(login.isNotEmpty && password.isNotEmpty){
      return _ViewModelAuthButtonState.canSubmit;
    }else{
      return _ViewModelAuthButtonState.disable;
    }
  }
  _ViewModelState();
}

class _ViewModel extends ChangeNotifier{
  final _authService = AuthService();

  final _state = _ViewModelState();
  _ViewModelState get state => _state;

  void changeLogin(String value){
    if(_state.login == value) return;
    _state.login = value;
    notifyListeners();
  }
  void changePassword(String value){
    if(_state.password == value) return;
    _state.password = value;
    notifyListeners();
  }

  Future<void> onAuthButtonPressed(BuildContext context) async {
    final login = _state.login;
    final password = _state.password;

    if(login.isEmpty || password.isEmpty) return;

    _state.authErrorTitle = '';
    _state.isAuthInProcess = true;
    notifyListeners();

    try{
      await _authService.login(login, password);
      _state.isAuthInProcess = false;
      notifyListeners();
      MainNavigation.showLoader(context);
    } on AuthApiProviderIncorrectLoginDataError{
      _state.isAuthInProcess = false;
      _state.authErrorTitle = 'Wrong login or password';
      notifyListeners();
    } catch(e){
      _state.isAuthInProcess = false;
      _state.authErrorTitle = 'Something went wrong , try later';
      notifyListeners();
    }
  }
}

class AuthWidget extends StatelessWidget {
  const AuthWidget({Key? key}) : super(key: key);

  static Widget create() {
    return ChangeNotifierProvider(
        create: (_) => _ViewModel(),
        child: const AuthWidget()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              _ErrorTitleWidget(),
              SizedBox(height: 10,),
              _LoginWidget(),
              SizedBox(height: 10,),
              _PasswordWidget(),
              SizedBox(height: 10,),
              AuthButtonWidget()
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginWidget extends StatelessWidget {
  const _LoginWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    return TextField(
      decoration: const InputDecoration(
        labelText: 'Login',
        border: OutlineInputBorder()
      ),
      onChanged: model.changeLogin,
    );
  }
}

class _PasswordWidget extends StatelessWidget {
  const _PasswordWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    return TextField(
      decoration: const InputDecoration(
          labelText: 'Password',
          border: OutlineInputBorder()
      ),
      onChanged: model.changePassword,
    );
  }
}

class _ErrorTitleWidget extends StatelessWidget {
  const _ErrorTitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authErrorTitle = context.select((_ViewModel vm) => vm.state.authErrorTitle);
    return Text(authErrorTitle);
  }
}

class AuthButtonWidget extends StatelessWidget {
  const AuthButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    final authButtonState = context.select((_ViewModel vm) => vm.state.authButtonState);

    final onPressed = authButtonState == _ViewModelAuthButtonState.canSubmit
        ? model.onAuthButtonPressed
        : null;
    final child = authButtonState == _ViewModelAuthButtonState.authProcess
        ? const SizedBox(height: 10, width: 10, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 1,))
        : const Text('Sign in');
    return ElevatedButton(
      onPressed: () => onPressed?.call(context),
      child: child,
    );
  }
}



