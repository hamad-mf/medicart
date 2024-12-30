

class LoginScreenState {
  final bool isloading;
  LoginScreenState({this.isloading = false});

  LoginScreenState copywith({bool? isloading}) {
    return LoginScreenState(isloading: isloading ?? this.isloading);
  }
}
