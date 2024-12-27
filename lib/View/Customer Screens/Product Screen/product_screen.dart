import 'package:flutter/material.dart';
import 'package:medicart/Controller/add_to_cart_controller.dart';
import 'package:medicart/Utils/color_constants.dart';
import 'package:medicart/View/Global%20Widgets/custom_button.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ProductScreen extends StatefulWidget {
  String product_name;
  String image_url;
  String category;
  bool isPresNeeded;
  String details;
  num price;
  num stocks;
  String usage;

  ProductScreen(
      {super.key,
      required this.isPresNeeded,
      required this.product_name,
      required this.image_url,
      required this.category,
      required this.details,
      required this.price,
      required this.stocks,
      required this.usage});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
 

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_new)),
      actions: [
        Icon(Icons.favorite_border_outlined),
        SizedBox(width: 20),
        Icon(Icons.ios_share),
        SizedBox(width: 20)
      ],
    ),
    body: Stack(
      children: [
        // Main content of the screen
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Container(
                  width: 400,
                  height: 350,
                  decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        widget.image_url,
                        width: 340,
                        height: 340,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 30),
                // Product Details
                Text(
                  widget.product_name,
                  style: TextStyle(
                      color: ColorConstants.mainblack,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.details,
                  style: TextStyle(
                      color: ColorConstants.mainblack.withOpacity(0.7),
                      fontSize: 17),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      "₹${widget.price.toString()}",
                      style: TextStyle(
                          color: ColorConstants.mainblack,
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                    SizedBox(width: 10),
                    Text("${widget.stocks.toString()} left")
                  ],
                ),
                SizedBox(height: 20),
                // Prescription Indicator
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: 136,
                  height: 25,
                  decoration: BoxDecoration(
                      color: widget.isPresNeeded
                          ? ColorConstants.mainred.withOpacity(0.6)
                          : ColorConstants.appbar.withOpacity(0.8)),
                  child: Row(
                    children: [
                      Text(
                        "Prescription: ${widget.isPresNeeded ? ' Yes' : ' No'}",
                        style: TextStyle(
                            color: ColorConstants.mainwhite,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    text: 'Usage: ',
                    style: TextStyle(
                        color: ColorConstants.mainblack,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                    children: [
                      TextSpan(
                          text: widget.usage,
                          style: TextStyle(
                              color: ColorConstants.mainblack,
                              fontWeight: FontWeight.normal,
                              fontSize: 15))
                    ],
                  ),
                ),
                SizedBox(height: 40),
                // Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customButton(
                      onPressed: () async {
                        await context.read<AddToCartController>().onAddtoCart(
                            itemcount: 1,
                            category: widget.category,
                            details: widget.details,
                            image_url: widget.image_url,
                            product_name: widget.product_name,
                            usage: widget.usage,
                            price: widget.price,
                            stocks: widget.stocks,
                            requiresPrescription: widget.isPresNeeded,
                            context: context);
                      },
                      text: "Add to cart",
                    ),
                    customButton(
                      onPressed: () {},
                      text: "Buy now",
                    ),
                  ],
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),

        
        if (context.watch<AddToCartController>().isLoading)
          Container(
            color: Colors.black.withOpacity(0.5), 
            child: Center(
              child: CircularProgressIndicator(
                color: ColorConstants.mainwhite,
              ),
            ),
          ),
      ],
    ),
  );
}
}