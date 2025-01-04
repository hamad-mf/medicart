import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/Controller/View%20By%20Category%20Screen%20Controller/category_controller.dart';
import 'package:medicart/Controller/View%20By%20Category%20Screen%20Controller/category_state.dart';
import 'package:medicart/View/Customer%20Screens/Product%20Screen/product_screen.dart';

class ViewByCategoryScreen extends ConsumerStatefulWidget {
  const ViewByCategoryScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ViewByCategoryScreenState();
}

class _ViewByCategoryScreenState extends ConsumerState<ViewByCategoryScreen> {
  final categoryControllerProvider =
      StateNotifierProvider<CategoryController, CategoryState>((ref) {
    return CategoryController();
  });

  // Stream Provider for Products by Category
  final productsByCategoryProvider =
      StreamProvider.family.autoDispose<QuerySnapshot, String>((ref, category) {
    return FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: category)
        .snapshots();
  });

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => ref.read(categoryControllerProvider.notifier).fetchCategories());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final categoryState = ref.watch(categoryControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Categories'),
      ),
      body: categoryState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : categoryState.error != null
              ? Center(child: Text(categoryState.error!))
              : Row(
                  children: [
                    // Category Sidebar
                    Container(
                      width: screenWidth * 0.26,
                      color: Colors.blue[50],
                      child: ListView.builder(
                        itemCount: categoryState.categories.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.all(screenWidth * 0.02),
                              padding: EdgeInsets.all(screenWidth * 0.02),
                              decoration: BoxDecoration(
                                color: selectedIndex == index
                                    ? Colors.blue
                                    : Colors.white,
                                borderRadius:
                                    BorderRadius.circular(screenWidth * 0.03),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.category,
                                    size: screenWidth * 0.06,
                                    color: selectedIndex == index
                                        ? Colors.white
                                        : Colors.blue,
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  Text(
                                    categoryState.categories[index],
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.035,
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
                        padding: EdgeInsets.all(screenWidth * 0.022),
                        child: Consumer(
                          builder: (context, ref, child) {
                            final productsStream = ref.watch(
                              productsByCategoryProvider(
                                categoryState.categories[selectedIndex],
                              ),
                            );

                            return productsStream.when(
                              data: (snapshot) {
                                if (snapshot.docs.isEmpty) {
                                  return const Center(
                                    child: Text(
                                        'No products available for this category.'),
                                  );
                                }
                                final products = snapshot.docs;

                                return GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: screenWidth < 600 ? 2 : 3,
                                    crossAxisSpacing: screenWidth * 0.02,
                                    mainAxisSpacing: screenHeight * 0.02,
                                    childAspectRatio: 3 / 4.9,
                                  ),
                                  itemCount: products.length,
                                  itemBuilder: (context, index) {
                                    final product = products[index];
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ProductScreen(
                                              product_name:
                                                  product["product_name"],
                                              image_url: product["image_url"],
                                              category: product["category"],
                                              details: product["details"],
                                              price: product["price"],
                                              stocks: product["stocks"],
                                              usage: product["usage"],
                                              isPresNeeded: product[
                                                  "prescription_required"],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: screenHeight * 0.25,
                                        padding:
                                            EdgeInsets.all(screenWidth * 0.03),
                                        decoration: BoxDecoration(
                                          color:
                                              Colors.white10.withOpacity(0.7),
                                          borderRadius: BorderRadius.circular(
                                              screenWidth * 0.03),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              offset: Offset(
                                                  screenWidth * 0.005,
                                                  screenHeight * 0.005),
                                              blurRadius: screenWidth * 0.02,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: Image.network(
                                                product['image_url'],
                                                width: screenWidth * 0.25,
                                                height: screenHeight * 0.15,
                                              ),
                                            ),
                                            SizedBox(
                                                height: screenHeight * 0.01),
                                            Text(
                                              product['product_name'],
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: screenWidth * 0.035,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(
                                                height: screenHeight * 0.005),
                                            Text(
                                              '₹${product['price']}',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: screenWidth * 0.04,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              loading: () => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              error: (error, stackTrace) => const Center(
                                child: Text('Something went wrong.'),
                              ),
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
