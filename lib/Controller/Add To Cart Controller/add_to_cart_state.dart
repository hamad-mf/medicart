class AddToCartState {
  final bool isloading;

  AddToCartState({this.isloading = false});

  AddToCartState copywith({bool? isloading}) {
    return AddToCartState(isloading: isloading ?? this.isloading);
  }
}