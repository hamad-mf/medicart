import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DisplayImagesScreen extends StatelessWidget {
  const DisplayImagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Uploaded Images')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('images').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No images uploaded yet.'));
          }

          final images = snapshot.data!.docs;

          return ListView.builder(
            itemCount: images.length,
            itemBuilder: (context, index) {
              final imageUrl = images[index]['url'];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(imageUrl),
              );
            },
          );
        },
      ),
    );
  }
}
