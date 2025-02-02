class AdminOrdersScreenState {
  final bool isloading;
  AdminOrdersScreenState({this.isloading=false});

  AdminOrdersScreenState copywith({bool? isloading}) {
   return AdminOrdersScreenState(isloading: isloading ?? this.isloading);
  }
}
