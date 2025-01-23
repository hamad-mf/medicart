import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/Utils/color_constants.dart';
import 'package:medicart/View/Customer%20Screens/Product%20Screen/product_screen.dart';
import 'package:medicart/View/Customer%20Screens/View%20By%20Category%20Screen/view_by_category_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CustomerHomeScreen extends ConsumerStatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends ConsumerState<CustomerHomeScreen> {
  List<Map<String, String>> products = [];
  final Stream<QuerySnapshot> _productsStream =
      FirebaseFirestore.instance.collection('products').snapshots();

  final PageController _controller = PageController();
  final int _numPages = 3;
  Timer? _timer;



  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      int nextPage = _controller.page!.round() + 1; //next page to
      if (nextPage >= _numPages) {
        //if its last slide go back to first
        _controller.animateToPage(0,
            duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
      } else {
        //move to next page
        _controller.animateToPage(nextPage,
            duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: ColorConstants.mainwhite,
      appBar: AppBar(
        backgroundColor: ColorConstants.appbar,
        actions: [
          InkWell(
            onTap: () {
             
            },
            child: Icon(
              Icons.notifications,
              color: ColorConstants.mainwhite,
              size: screenHeight * 0.03,
            ),
          ),
          SizedBox(
            width: screenWidth * 0.02,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  width: double.infinity,
                  height: screenHeight * 0.40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [ColorConstants.appbar, ColorConstants.mainwhite],
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      SizedBox(
                        height: screenHeight * 0.06,
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "Search...",
                            prefixIcon: Icon(Icons.search, color: Colors.grey),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 104,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: screenHeight * 0.19,
                    child: PageView(
                      controller: _controller,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    "https://images.pexels.com/photos/593451/pexels-photo-593451.jpeg?auto=compress&cs=tinysrgb&w=600"),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    "https://images.pexels.com/photos/51929/medications-cure-tablets-pharmacy-51929.jpeg?auto=compress&cs=tinysrgb&w=600"),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    "https://images.pexels.com/photos/3683067/pexels-photo-3683067.jpeg?auto=compress&cs=tinysrgb&w=600"),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.33,
                  left: screenWidth * 0.45,
                  right: 0,
                  child: SmoothPageIndicator(
                    controller: _controller,
                    count: _numPages,
                    effect: WormEffect(
                      dotHeight: screenHeight * 0.010,
                      dotWidth: screenWidth * 0.016,
                      activeDotColor: ColorConstants.mainblack,
                      dotColor: ColorConstants.mainblack,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Row(
              children: [
                SizedBox(
                  width: screenWidth * 0.025,
                ),
                Text(
                  "View By Category",
                  style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewByCategoryScreen()));
                  },
                  child: Text(
                    "See All",
                    style: TextStyle(
                        color: ColorConstants.appbar,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.04),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: screenWidth * 0.04,
                  color: ColorConstants.appbar,
                ),
                SizedBox(
                  width: screenWidth * 0.035,
                )
              ],
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    width: screenWidth * 0.04,
                  ),
                  Container(
                    height: screenHeight * 0.04,
                    width: screenWidth * 0.32,
                    decoration: BoxDecoration(
                        color: ColorConstants.mainbg,
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(19)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.network(
                          'https://res.cloudinary.com/dflu65eef/image/upload/v1734014656/Vitamins_qolxd4.png',
                          scale: screenWidth * 0.070,
                        ),
                        Text(
                          "Vitamins",
                          style: TextStyle(fontSize: screenWidth * 0.034),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: screenWidth * 0.04,
                  ),
                  Container(
                    height: screenHeight * 0.04,
                    width: screenWidth * 0.32,
                    decoration: BoxDecoration(
                        color: ColorConstants.mainbg,
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(19)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.network(
                          'https://res.cloudinary.com/dflu65eef/image/upload/v1734014385/Antibiotics_axajjp.png',
                          scale: screenWidth * 0.070,
                        ),
                        Text(
                          "Antibiotics",
                          style: TextStyle(fontSize: screenWidth * 0.034),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: screenWidth * 0.04,
                  ),
                  Container(
                    height: screenHeight * 0.04,
                    width: screenWidth * 0.32,
                    decoration: BoxDecoration(
                        color: ColorConstants.mainbg,
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(19)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.network(
                          'https://res.cloudinary.com/dflu65eef/image/upload/v1734014247/Pain_Relief_vby7ae.png',
                          scale: screenWidth * 0.070,
                        ),
                        Text(
                          "Pain Relief",
                          style: TextStyle(fontSize: screenWidth * 0.034),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: screenWidth * 0.04,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Row(
              children: [
                SizedBox(
                  width: screenWidth * 0.025,
                ),
                Text(
                  "Recommended for you",
                  style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _productsStream,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: const Text('Something went wrong'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  return GridView.builder(
                    shrinkWrap: true, // Allow GridView to shrink to fit content
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Number of columns
                      crossAxisSpacing:
                          screenWidth * 0.03, // Space between columns
                      mainAxisSpacing:
                          screenHeight * 0.02, // Space between rows
                      childAspectRatio: screenWidth *
                          0.002, // Width-to-height ratio of each container
                    ),
                    itemCount: 21, // Number of containers
                    itemBuilder: (context, index) {
                      final List<QueryDocumentSnapshot<Object?>> productlist =
                          snapshot.data!.docs;
                      return InkWell(
                        onTap: () {
                          final List<QueryDocumentSnapshot<Object?>>
                              productlist = snapshot.data!.docs;
                          final selectedProduct = productlist[index];

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductScreen(
                                        isPresNeeded: selectedProduct[
                                            "prescription_required"],
                                        product_name:
                                            selectedProduct["product_name"],
                                        image_url: selectedProduct["image_url"],
                                        category: selectedProduct["category"],
                                        details: selectedProduct["details"],
                                        price: selectedProduct["price"],
                                        stocks: selectedProduct["stocks"],
                                        usage: selectedProduct["usage"],
                                      )));
                        },
                        child: Container(
                          height: screenWidth * 0.02,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white10.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(2, 2),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Image.network(
                                  productlist[index]["image_url"],
                                  width: screenWidth * 0.20,
                                  height: screenHeight * 0.09,
                                ),
                              ),
                              Text(
                                productlist[index]["product_name"],
                                style: TextStyle(
                                    fontSize: screenWidth * 0.040,
                                    color: ColorConstants.mainblack,
                                    overflow: TextOverflow.ellipsis),
                              ),
                              Text(
                                "₹${productlist[index]["price"]}",
                                style: TextStyle(
                                    fontSize: screenWidth * 0.040,
                                    color: ColorConstants.mainblack,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    padding: EdgeInsets.all(screenWidth * 0.03),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
