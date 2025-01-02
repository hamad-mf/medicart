class CartScreenState {
  num count;
  CartScreenState({this.count=1});

  CartScreenState copywith({num? newCount}) {
    return CartScreenState(count: newCount ?? count);
  }
}