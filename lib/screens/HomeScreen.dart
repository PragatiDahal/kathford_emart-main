import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart/global_variables.dart';
import 'package:emart/widgets/ProductCard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // list of images
  final List<String> imgList = [
    'https://images.unsplash.com/photo-1542291026-7eec264c27ff?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8c2hvZXN8ZW58MHx8MHx8fDA%3D&w=1000&q=80',
    'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2071&q=80',
    'https://images.unsplash.com/photo-1529374255404-311a2a4f1fd9?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2069&q=80',
    'https://images.unsplash.com/photo-1593305841991-05c297ba4575?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1957&q=80',
  ];

  String filterCategory = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, $firstName'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CarouselSlider(
                options: CarouselOptions(autoPlay: true),
                items: imgList
                    .map((item) => Container(
                          child: Image.network(
                            item,
                            fit: BoxFit.cover,
                            width: 1000,
                          ),
                        ))
                    .toList()),
            const SizedBox(height: 20),
            const Text(
              'Showing popular products',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            // list of products category
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: filterCategory == 'all'
                            ? Colors.blue
                            : Colors.white,
                        foregroundColor: filterCategory == 'all'
                            ? Colors.white
                            : Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          filterCategory = 'all';
                        });
                      },
                      child: const Text('All'),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: filterCategory == 'furniture'
                            ? Colors.blue
                            : Colors.white,
                        foregroundColor: filterCategory == 'furniture'
                            ? Colors.white
                            : Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          filterCategory = 'furniture';
                        });
                      },
                      child: const Text('Furniture'),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: filterCategory == 'clothes'
                            ? Colors.blue
                            : Colors.white,
                        foregroundColor: filterCategory == 'clothes'
                            ? Colors.white
                            : Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          filterCategory = 'clothes';
                        });
                      },
                      child: const Text('Clothes'),
                    ),
                  ],
                ),
              ),
            ),

            // future builder for getting data from firebase
            FutureBuilder<QuerySnapshot?>(
                future: filterCategory == "all"
                    ? FirebaseFirestore.instance.collection('products').get()
                    : FirebaseFirestore.instance
                        .collection('products')
                        .where("category", isEqualTo: filterCategory)
                        .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Failed to load data'));
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text('No data found'));
                  } else {
                    final data = snapshot.data!.docs;

                    return GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(data.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, "/details",
                                  arguments: {
                                    "id": data[index].id,
                                    "name": data[index]['name'],
                                    "price": data[index]['price'],
                                    "description": data[index]['description'],
                                    "category": data[index]['category'],
                                    "images": data[index]['images'],
                                    "userId": data[index]['userId'],
                                    "favouriteBy": data[index]['favouriteBy']
                                  });
                            },
                            child: ProductCard(
                              name: data[index]['name'],
                              price: data[index]['price'],
                              description: data[index]['description'],
                              category: data[index]['category'],
                              image: data[index]['images'][0],
                            ),
                          );
                        }));
                  }
                })
          ],
        ),
      ),
    );
  }
}
