class ProductAddingScreenState {
  final bool isloading;
  final bool requiresPrescription;

  ProductAddingScreenState({
    this.isloading = false,
    this.requiresPrescription = false,
  });

  ProductAddingScreenState copywith({
    bool? isloading,
    bool? requiresPrescription,
  }) {
    return ProductAddingScreenState(
      isloading: isloading ?? this.isloading,
      requiresPrescription: requiresPrescription ?? this.requiresPrescription,
    );
  }
}
