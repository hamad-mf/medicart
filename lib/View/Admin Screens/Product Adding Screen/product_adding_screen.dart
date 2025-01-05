import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/Controller/Product%20Adding%20Screen%20Controller/product_adding_screen_controller.dart';
import 'package:medicart/Controller/Product%20Adding%20Screen%20Controller/product_adding_screen_state.dart';
import 'package:medicart/Utils/color_constants.dart';
import 'package:medicart/View/Common%20Screens/Profile%20Selection%20Screen/profile_selecction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class ProductAddingScreen extends ConsumerWidget {
  ProductAddingScreen({super.key});

  TextEditingController categoryctrl = TextEditingController();
  TextEditingController detailsctrl = TextEditingController();
  TextEditingController image_urlctrl = TextEditingController();
  TextEditingController pricectrl = TextEditingController();
  TextEditingController product_namectrl = TextEditingController();
  TextEditingController stocksctrl = TextEditingController();
  TextEditingController usagectrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool requiresPrescription = false;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final productaddingscreenstate =
        ref.watch(ProductAddingScreenStateNotifierProvider)
            as ProductAddingScreenState;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.mainbg,
      ),
      backgroundColor: ColorConstants.mainbg,
      body: Center(
        child: Form(
          key: _formKey,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  Text(
                    "Add a product",
                    style: TextStyle(
                        color: ColorConstants.mainblack,
                        fontSize: screenWidth * 0.07,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    child: TextFormField(
                      controller: product_namectrl,
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
                    height: screenHeight * 0.01,
                  ),
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    child: TextFormField(
                      controller: categoryctrl,
                      decoration: InputDecoration(
                          hintText: "Enter category",
                          hintStyle: TextStyle(color: Colors.grey),
                          labelText: "category",
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
                          return "Please enter a data";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    child: TextFormField(
                      controller: image_urlctrl,
                      decoration: InputDecoration(
                          hintText: "put image url",
                          hintStyle: TextStyle(color: Colors.grey),
                          labelText: "img url",
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
                          return "Please enter a data";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    child: TextFormField(
                      controller: detailsctrl,
                      decoration: InputDecoration(
                          hintText: "Enter details",
                          hintStyle: TextStyle(color: Colors.grey),
                          labelText: "details",
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
                          return "Please enter a data";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    child: TextFormField(
                      controller: pricectrl,
                      decoration: InputDecoration(
                          hintText: "Enter price",
                          hintStyle: TextStyle(color: Colors.grey),
                          labelText: "price",
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
                          return "Please enter a data";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    child: TextFormField(
                      controller: usagectrl,
                      decoration: InputDecoration(
                          hintText: "Enter usage",
                          hintStyle: TextStyle(color: Colors.grey),
                          labelText: "usage",
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
                          return "Please enter a data";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    child: TextFormField(
                      controller: stocksctrl,
                      decoration: InputDecoration(
                          hintText: "Enter stocks",
                          hintStyle: TextStyle(color: Colors.grey),
                          labelText: "stocks",
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
                          return "Please enter a data";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.03),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Requires Prescription?",
                          style: TextStyle(
                              color: ColorConstants.mainblack,
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.bold),
                        ),
                        Switch(
                          value: productaddingscreenstate.requiresPrescription,
                          onChanged: (value) {
                            ref
                                .read(ProductAddingScreenStateNotifierProvider
                                    .notifier)
                                .setRequiresPrescription(value);
                          },
                          activeColor: ColorConstants.mainblack,
                        )
                      ],
                    ),
                  ),
                  productaddingscreenstate.isloading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () async {
                            final category = categoryctrl.text.trim();
                            final details = detailsctrl.text.trim();
                            final image_url = image_urlctrl.text.trim();
                            final price = pricectrl.text;
                            final product_name = product_namectrl.text.trim();
                            final stocks = stocksctrl.text.trim();
                            final usage = usagectrl.text.trim();
                            if (_formKey.currentState!.validate()) {
                              ref
                                  .read(ProductAddingScreenStateNotifierProvider
                                      .notifier)
                                  .onProductAdd(
                                      category: category,
                                      details: details,
                                      image_url: image_url,
                                      product_name: product_name,
                                      usage: usage,
                                      requiresPrescription:
                                          requiresPrescription,
                                      price: num.parse(price),
                                      stocks: num.parse(stocks),
                                      context: context);
                            }
                            product_namectrl.clear();
                            categoryctrl.clear();
                            image_urlctrl.clear();
                            detailsctrl.clear();
                            pricectrl.clear();
                            usagectrl.clear();
                            stocksctrl.clear();
                            ref
                                .read(ProductAddingScreenStateNotifierProvider
                                    .notifier)
                                .toggleRequiresPrescription();
                          },
                          child: Text(
                            "Add",
                            style: TextStyle(
                                color: ColorConstants.mainblack,
                                fontSize: screenWidth * 0.06,
                                fontWeight: FontWeight.bold),
                          )),
                  SizedBox(
                    height: screenHeight * 0.03,
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
