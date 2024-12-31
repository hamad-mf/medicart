import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/Controller/Personal%20Details%20Adding%20Screen%20Controller/personal_details_adding_screen_controller.dart';
import 'package:medicart/Controller/Personal%20Details%20Adding%20Screen%20Controller/personal_details_adding_screen_state.dart';
import 'package:medicart/Utils/color_constants.dart';

// ignore: must_be_immutable
class PersonalDetailsAddingScreen extends ConsumerWidget {
  PersonalDetailsAddingScreen({super.key});

  TextEditingController emailctrl = TextEditingController();
  TextEditingController fullnamectrl = TextEditingController();
  TextEditingController phnctrl = TextEditingController();
  TextEditingController cityctrl = TextEditingController();
  TextEditingController countryctrl = TextEditingController();
  TextEditingController pincodectrl = TextEditingController();
  TextEditingController statectrl = TextEditingController();
  TextEditingController streetadressctrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personaldetailsaddingscreenstate =
        ref.watch(PersonalDetailsAddingScreenStateNotifeirProvider)
            as PersonalDetailsAddingScreenState;
    return Scaffold(
      backgroundColor: ColorConstants.mainbg,
      body: Center(
        child: Form(
            key: _formKey,
            child: SafeArea(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "Add a product",
                    style: TextStyle(
                        color: ColorConstants.mainblack,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: fullnamectrl,
                      decoration: InputDecoration(
                          hintText: "Enter product namel",
                          hintStyle: TextStyle(color: Colors.grey),
                          labelText: "product name",
                          labelStyle: TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(12))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Your product name";
                        }

                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: emailctrl,
                      decoration: InputDecoration(
                          hintText: "Enter product namel",
                          hintStyle: TextStyle(color: Colors.grey),
                          labelText: "product name",
                          labelStyle: TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(12))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Your product name";
                        }

                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: phnctrl,
                      decoration: InputDecoration(
                          hintText: "Enter product namel",
                          hintStyle: TextStyle(color: Colors.grey),
                          labelText: "product name",
                          labelStyle: TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(12))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Your product name";
                        }

                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: cityctrl,
                      decoration: InputDecoration(
                          hintText: "Enter product namel",
                          hintStyle: TextStyle(color: Colors.grey),
                          labelText: "product name",
                          labelStyle: TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(12))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Your product name";
                        }

                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: countryctrl,
                      decoration: InputDecoration(
                          hintText: "Enter product namel",
                          hintStyle: TextStyle(color: Colors.grey),
                          labelText: "product name",
                          labelStyle: TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(12))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Your product name";
                        }

                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: pincodectrl,
                      decoration: InputDecoration(
                          hintText: "Enter product namel",
                          hintStyle: TextStyle(color: Colors.grey),
                          labelText: "product name",
                          labelStyle: TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(12))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Your product name";
                        }

                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: statectrl,
                      decoration: InputDecoration(
                          hintText: "Enter product namel",
                          hintStyle: TextStyle(color: Colors.grey),
                          labelText: "product name",
                          labelStyle: TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(12))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Your product name";
                        }

                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: streetadressctrl,
                      decoration: InputDecoration(
                          hintText: "Enter product namel",
                          hintStyle: TextStyle(color: Colors.grey),
                          labelText: "product name",
                          labelStyle: TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(12))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Your product name";
                        }

                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  personaldetailsaddingscreenstate.isloading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () async {
                            final email = emailctrl.text.trim();
                            final full_name = fullnamectrl.text.trim();
                            final phn = phnctrl.text.trim();
                            final city = cityctrl.text.trim();
                            final country = countryctrl.text.trim();
                            final pincode = pincodectrl.text.trim();
                            final state = statectrl.text.trim();
                            final street_address = streetadressctrl.text.trim();
                            final shipping_address = {
                              'city': city,
                              'country': country,
                              'pin_code': pincode,
                              'state': state,
                              'street_address': street_address
                            };
                            if (_formKey.currentState!.validate()) {
                              ref
                                  .read(
                                      PersonalDetailsAddingScreenStateNotifeirProvider
                                          .notifier)
                                  .onAddDetails(
                                      full_name: full_name,
                                      email: email,
                                      phn: num.parse(phn),
                                      shipping_adress: shipping_address,
                                      context: context);
                            }
                          },
                          child: Text(
                            "Update",
                            style: TextStyle(
                                color: ColorConstants.mainwhite,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ))
                ],
              ),
            ))),
      ),
    );
  }
}
