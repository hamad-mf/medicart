import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/Controller/Registration%20Screen%20Controller/registration_screen_controller.dart';
import 'package:medicart/Controller/Registration%20Screen%20Controller/registration_screen_state.dart';
import 'package:medicart/Utils/color_constants.dart';
import 'package:medicart/View/Customer%20Screens/Login%20Screen/login_screen.dart';

// ignore: must_be_immutable
class RegistrationScreen extends ConsumerWidget {
  RegistrationScreen({super.key});

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController CpassController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registrationscreenstate =
        ref.watch(RegistrationScreenStateNotifierProvider)
            as RegistrationScreenState;

    return Scaffold(
      backgroundColor: ColorConstants.mainbg,
      body: Center(
        child: Form(
          key: _formKey,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                  ),
                  Text(
                    "Create an account",
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
                      controller: emailController,
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
                      controller: passController,
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
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: CpassController,
                      decoration: InputDecoration(
                          hintText: "Re-Enter your password",
                          hintStyle: TextStyle(color: Colors.grey),
                          labelText: "Confirm Password",
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
                        if (value == null || value != passController.text) {
                          return "Passsword does'nt match";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  registrationscreenstate.isloading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () async {
                            final email = emailController.text.trim();
                            final password = passController.text.trim();
                            if (_formKey.currentState!.validate()) {
                              ref
                                  .read(RegistrationScreenStateNotifierProvider
                                      .notifier)
                                  .onRegistration(
                                      email: email,
                                      password: password,
                                      role: "user",
                                      context: context);
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                  ColorConstants.mainblack),
                              minimumSize:
                                  WidgetStatePropertyAll(Size(300, 50)),
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12)))),
                          child: Text(
                            "Create Account",
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
                              builder: (context) => LoginScreen()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: Text(
                        "Already have an account? Login",
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
      ),
    );
  }
}
