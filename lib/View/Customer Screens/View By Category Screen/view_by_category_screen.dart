import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/Controller/View%20By%20Category%20Screen%20Controller/category_controller.dart';
import 'package:medicart/Controller/View%20By%20Category%20Screen%20Controller/category_state.dart';
import 'package:medicart/View/Customer%20Screens/Product%20Screen/product_screen.dart';

class ViewByCategoryScreen extends ConsumerStatefulWidget {
  const ViewByCategoryScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ViewByCategoryScreenState();
}

class _ViewByCategoryScreenState extends ConsumerState<ViewByCategoryScreen> {


  final categoryControllerProvider =
    StateNotifierProvider<CategoryController, CategoryState>((ref) {
  return CategoryController();
});

// Stream Provider for Products by Category
final productsByCategoryProvider = StreamProvider.family.autoDispose<
    QuerySnapshot, String>((ref, category) {
  return FirebaseFirestore.instance
      .collection('products')
      .where('category', isEqualTo: category)
      .snapshots();
});

   int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        ref.read(categoryControllerProvider.notifier).fetchCategories());
  }

  @override
  Widget build(BuildContext context) {
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
                      width: 100,
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
                                    categoryState.categories[index],
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
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 3 / 4,
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
                                        height: 108,
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.white10
                                              .withOpacity(0.7),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black26,
                                              offset: Offset(2, 2),
                                              blurRadius: 5,
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
                                                width: 90,
                                                height: 80,
                                              ),
                                            ),
                                            Text(
                                              product['product_name'],
                                              style: const TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              '\$${product['price']}',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
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
