class PlaceOrderState {
  final bool isloading;
  PlaceOrderState({this.isloading = false});

  PlaceOrderState copywith({bool? isloading}) {
    return PlaceOrderState(isloading: isloading ?? this.isloading);
  }
}
