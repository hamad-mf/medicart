import 'package:flutter/material.dart';

class ViewByCategoryScreen extends StatefulWidget {
  const ViewByCategoryScreen({super.key});

  @override
  State<ViewByCategoryScreen> createState() => _ViewByCategoryScreenState();
}

class _ViewByCategoryScreenState extends State<ViewByCategoryScreen> {
  // Sample categories and their colors
  final List<String> categories = [
    "Eczema",
    "Nasal",
    "Fever",
    "Infection",
    "Spasm"
  ];
  final List<Color> categoryColors = [
    Colors.lightBlueAccent,
    Colors.orangeAccent,
    Colors.pinkAccent,
    Colors.greenAccent,
    Colors.purpleAccent,
  ];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Grid View'),
      ),
      body: Row(
        children: [
          // Category Sidebar
          Container(
            width: 100,
            color: Colors.blue[50],
            child: ListView.builder(
              itemCount: categories.length,
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
                      color:
                          selectedIndex == index ? Colors.blue : Colors.white,
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
                        SizedBox(height: 5),
                        Text(
                          categories[index],
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
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: 10, // Example: Fixed 10 items
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: categoryColors[selectedIndex],
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.medical_services,
                            size: 50, color: Colors.white),
                        SizedBox(height: 10),
                        Text(
                          'Product Demo',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '\$${index + 10}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
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
