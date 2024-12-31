class PersonalDetailsAddingScreenState {
  final bool isloading;

  PersonalDetailsAddingScreenState({this.isloading = false});

  PersonalDetailsAddingScreenState copywith({bool? isloading}) {
    return PersonalDetailsAddingScreenState(
        isloading: isloading ?? this.isloading);
  }
}
