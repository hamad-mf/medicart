import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/Controller/Doctor%20Login%20Screen%20Controller/doctor_login_screen_controller.dart';
import 'package:medicart/Controller/Doctor%20Login%20Screen%20Controller/doctor_login_screen_state.dart';
import 'package:medicart/Utils/color_constants.dart';

// ignore: must_be_immutable
class DoctorLoginScreen extends ConsumerWidget {
  DoctorLoginScreen({super.key});

  TextEditingController doctorUsernameController = TextEditingController();
  TextEditingController doctorPassController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final docotrloginscreenstate =
        ref.watch(DoctorLoginScreenStateNotifierProvider)
            as DoctorLoginScreenState;

    return Scaffold(
      backgroundColor: ColorConstants.mainbg,
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 0,
                ),
                Text(
                  "Enter your credentials",
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
                    controller: doctorUsernameController,
                    decoration: InputDecoration(
                        hintText: "Enter your username",
                        hintStyle: TextStyle(color: Colors.grey),
                        labelText: "Username",
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
                        return "Please Enter Your Username";
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
                    controller: doctorPassController,
                    decoration: InputDecoration(
                        hintText: "Enter your password",
                        hintStyle: TextStyle(color: Colors.grey),
                        labelText: "Password",
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
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      }
                      if (value.length < 6) {
                        return "password must be atleast 6 characters";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                docotrloginscreenstate.isloading
                    ? CircularProgressIndicator.adaptive()
                    : ElevatedButton(
                        onPressed: () async {
                          final username = doctorUsernameController.text.trim();
                          final password = doctorPassController.text.trim();
                          ref
                              .read(DoctorLoginScreenStateNotifierProvider
                                  .notifier)
                              .onDoctorLogin(
                                  email: username,
                                  password: password,
                                  context: context);
                        },
                        style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                                ColorConstants.mainblack),
                            minimumSize: WidgetStatePropertyAll(Size(300, 50)),
                            shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)))),
                        child: Text(
                          "Login",
                          style: TextStyle(
                              color: ColorConstants.mainwhite,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
