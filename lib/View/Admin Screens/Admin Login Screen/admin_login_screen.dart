import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/Controller/Admin%20Login%20Screen%20Controller/admin_login_screen_controller.dart';
import 'package:medicart/Controller/Admin%20Login%20Screen%20Controller/admin_login_screen_state.dart';
import 'package:medicart/Utils/color_constants.dart';

// ignore: must_be_immutable
class AdminLoginScreen extends ConsumerWidget {
  AdminLoginScreen({super.key});
  TextEditingController adminUsernameController = TextEditingController();
  TextEditingController adminPassController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adminloginscreenstate = ref
        .watch(AdminLoginScreenStateNotifierProvider) as AdminLoginScreenState;
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
                    controller: adminUsernameController,
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
                    controller: adminPassController,
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
                adminloginscreenstate.isloading
                    ? CircularProgressIndicator.adaptive()
                    : ElevatedButton(
                        onPressed: () async {
                          final username = adminUsernameController.text.trim();
                          final password = adminPassController.text.trim();
                          ref
                              .read(AdminLoginScreenStateNotifierProvider
                                  .notifier)
                              .onAdminLogin(
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
