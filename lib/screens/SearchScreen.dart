import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchQuery = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Products'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CupertinoSearchTextField(
                  placeholder: 'Search products',
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  }),
              const SizedBox(height: 20),
              Text(
                searchQuery.isNotEmpty
                    ? "Search result for '$searchQuery'"
                    : "Showing all products",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("products")
                      .where("name", isGreaterThanOrEqualTo: searchQuery)
                      .snapshots(),
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CupertinoActivityIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Error loading data'));
                    } else if (!snapshot.hasData) {
                      return const Center(child: Text('No data found'));
                    } else {
                      final data = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: data.length,
                        shrinkWrap: true,
                        itemBuilder: ((context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, "/details",
                                  arguments: {
                                    "name": data[index]['name'],
                                    "price": data[index]['price'],
                                    "description": data[index]['description'],
                                    "category": data[index]['category'],
                                    "images": data[index]['images'],
                                    "userId": data[index]['userId'],
                                     "favoriteBy":data[index]['favouriteBy']
                                  });
                            },
                            child: ListTile(
                              leading: Image.network(data[index]['images'][0]),
                              title: Text(data[index]['name']),
                              subtitle: Text(data[index]['description']),
                              trailing: Icon(Icons.arrow_forward_ios),
                            ),
                          );
                        }),
                      );
                    }
                  }))
            ],
          ),
        ),
      ),
    );
  }
}
