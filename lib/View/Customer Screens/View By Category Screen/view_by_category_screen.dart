import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:medicart/Controller/category_screen_controller.dart';

class ViewByCategoryScreen extends StatefulWidget {
  const ViewByCategoryScreen({super.key});

  @override
  State<ViewByCategoryScreen> createState() => _ViewByCategoryScreenState();
}

class _ViewByCategoryScreenState extends State<ViewByCategoryScreen> {
  int selectedIndex = 0; // To track the selected category
  final List<Color> categoryColors = [
    Colors.lightBlueAccent,
    Colors.orangeAccent,
    Colors.pinkAccent,
    Colors.greenAccent,
    Colors.purpleAccent,
  ];

  Stream<QuerySnapshot> fetchProductsByCategory(String category) {
    return FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: category)
        .snapshots();
  }

  @override
  void initState() {
    super.initState();
    final controller =
        Provider.of<CategoryScreenController>(context, listen: false);
    controller.fetchCategories(); // Fetch categories once the screen loads
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CategoryScreenController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Category Grid View'),
      ),
      body: controller.categories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                // Category Sidebar
                Container(
                  width: 100,
                  color: Colors.blue[50],
                  child: ListView.builder(
                    itemCount: controller.categories.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8.0),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: selectedIndex == index
                                ? Colors.blue
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.category,
                                color: selectedIndex == index
                                    ? Colors.white
                                    : Colors.blue,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                controller.categories[index],
                                style: TextStyle(
                                  color: selectedIndex == index
                                      ? Colors.white
                                      : Colors.blue,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Products Grid
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: fetchProductsByCategory(
                          controller.categories[selectedIndex]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return const Center(
                            child: Text('Something went wrong.'),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text(
                                'No products available for this category.'),
                          );
                        }

                        final products = snapshot.data!.docs;

                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 3 / 4,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.medical_services,
                                      size: 50, color: Colors.white),
                                  const SizedBox(height: 10),
                                  Text(
                                    product['product_name'], // Product name
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '\$${product['price']}', // Product price
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
