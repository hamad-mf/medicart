class DoctorOrdersScreenState {
  final bool isloading;
  DoctorOrdersScreenState({this.isloading=false});

  DoctorOrdersScreenState copywith({bool? isloading}) {
   return DoctorOrdersScreenState(isloading: isloading ?? this.isloading);
  }
}
