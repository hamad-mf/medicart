class AdminLoginScreenState {
  final bool isloading;

  AdminLoginScreenState({this.isloading=false});

  AdminLoginScreenState copywith({bool? isloading}) {
    return AdminLoginScreenState(isloading: isloading ?? this.isloading);
  }
}
