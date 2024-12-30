class RegistrationScreenState {
  final bool isloading;

  RegistrationScreenState({this.isloading = false});

  RegistrationScreenState copywith({bool? isloading}) {
    return RegistrationScreenState(isloading: isloading ?? this.isloading);
  }
}
