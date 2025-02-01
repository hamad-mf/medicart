class CustomerOrdersScreenState {
  final bool isloading;

  CustomerOrdersScreenState({this.isloading = false});

  CustomerOrdersScreenState copywith({bool? isloading}) {
    return CustomerOrdersScreenState(isloading: isloading ?? this.isloading);
  }
}
