abstract class AuthApiProviderError{}

class AuthApiProviderIncorrectLoginDataError{}

class AuthApiProvider{
  Future<String> login(String login, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    final isSuccess = login == 'admin' && password == '123456';
    if(isSuccess){
      return 'sdsadsadasdsafdsfasfsadsa';
    }else{
      throw AuthApiProviderIncorrectLoginDataError();
    }
  }

  Future<void> logout() async {

  }
}
