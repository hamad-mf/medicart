class DoctorLoginScreenState {
  final bool isloading;
  DoctorLoginScreenState({this.isloading = false});

  DoctorLoginScreenState copywith({bool? isloading}) {
    return DoctorLoginScreenState(isloading: isloading ?? this.isloading);
  }
}
