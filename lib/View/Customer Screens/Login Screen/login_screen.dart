import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/Controller/Login%20Screen%20Controller/login_screen_controller.dart';
import 'package:medicart/Controller/Login%20Screen%20Controller/login_screen_state.dart';
import 'package:medicart/Utils/color_constants.dart';
import 'package:medicart/View/Customer%20Screens/Registration%20Screen/registration_screen.dart';

// ignore: must_be_immutable
class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPassController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginscreenstate =
        ref.watch(LoginScreenStateNotifierProvider) as LoginScreenState;

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
                  "Login into your account",
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
                    controller: loginEmailController,
                    decoration: InputDecoration(
                        hintText: "Enter your email",
                        hintStyle: TextStyle(color: Colors.grey),
                        labelText: "Email",
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
                        return "Please Enter Your Email";
                      }
                      if (!RegExp(r'^[\w-]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
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
                    controller: loginPassController,
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
                loginscreenstate.isloading
                    ? CircularProgressIndicator.adaptive()
                    : ElevatedButton(
                        onPressed: () async {
                          final email = loginEmailController.text.trim();
                          final password = loginPassController.text.trim();
                          ref
                              .read(LoginScreenStateNotifierProvider.notifier)
                              .onLogin(
                                  email: email,
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
                TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistrationScreen()),
                        (route) => false,
                      );
                    },
                    child: Text(
                      "Dont have an account? Create",
                      style: TextStyle(color: ColorConstants.mainblack),
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
