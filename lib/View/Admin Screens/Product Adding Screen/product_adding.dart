import 'package:flutter/material.dart';
import 'package:medicart/Controller/product_adding_screen_controller.dart';
import 'package:medicart/Utils/color_constants.dart';
import 'package:medicart/View/Common%20Screens/Profile%20Selection%20Screen/profile_selection_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductAdding extends StatefulWidget {
  const ProductAdding({super.key});

  @override
  State<ProductAdding> createState() => _ProductAddingState();
}

class _ProductAddingState extends State<ProductAdding> {
  TextEditingController categoryctrl = TextEditingController();
  TextEditingController detailsctrl = TextEditingController();
  TextEditingController image_urlctrl = TextEditingController();
  TextEditingController pricectrl = TextEditingController();
  TextEditingController product_namectrl = TextEditingController();
  TextEditingController stocksctrl = TextEditingController();
  TextEditingController usagectrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool requiresPrescription = false;

  Future<void> _adminlogout() async {
    SharedPreferences adminprefs = await SharedPreferences.getInstance();
    await adminprefs.setBool(
        'isAdminLoggedIn', false); // Set isAdminLoggedIn to false

    // Navigate back to LoginScreen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => ProfileSelectionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.mainbg,
      body: Center(
        child: Form(
          key: _formKey,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {
                            _adminlogout();
                          },
                          icon: Icon(Icons.exit_to_app)),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
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
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
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
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
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
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
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
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
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
                    padding: const EdgeInsets.all(8.0),
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
                    padding: const EdgeInsets.all(8.0),
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
                    padding: EdgeInsets.all(9),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Requires Prescription?",
                          style: TextStyle(
                              color: ColorConstants.mainblack,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Switch(
                          value: requiresPrescription,
                          onChanged: (value) {
                            setState(() {
                              requiresPrescription = value;
                            });
                          },
                          activeColor: ColorConstants.mainblack,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  context.watch<ProductAddingScreenController>().isLoading
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
                              await context
                                  .read<ProductAddingScreenController>()
                                  .onProductadd(
                                    requiresPrescription: requiresPrescription,
                                      product_name: product_name,
                                      category: category,
                                      image_url: image_url,
                                      price: num.parse(price),
                                      details: details,
                                      usage: usage,
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
                          },
                          child: Text(
                            "Add",
                            style: TextStyle(
                                color: ColorConstants.mainwhite,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
