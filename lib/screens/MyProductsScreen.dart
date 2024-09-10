import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart/global_variables.dart';
import 'package:emart/services/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyProductsScreen extends StatefulWidget {
  const MyProductsScreen({super.key});

  @override
  State<MyProductsScreen> createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  void _deleteproduct(String id) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete products"),
            content: Text("Are you sure want to delete product?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel", style: TextStyle(color: Colors.red)),
              ),
              TextButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('products')
                      .doc(id)
                      .delete();
                  Navigator.pop(context);
                  setState(() {});
                },
                child: Text("Confirm"),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My products'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('products')
                .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Image.network(data[index]['images'][0]),
                        title: Text(data[index]['name']),
                        subtitle: Text(data[index]['description']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/edit_product',
                                    arguments: {
                                      "id": data[index].id,
                                      "name": data[index]['name'],
                                      "price": data[index]['price'],
                                      "description": data[index]['description'],
                                      "category": data[index]['category'],
                                      "images": data[index]['images'],
                                      "userId": data[index]['userId'],
                                    });
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () {
                                _deleteproduct(data[index].id);
                              },
                              icon: const Icon(Icons.delete),
                            )
                          ],
                        ),
                      );
                    });
              }
            }));
  }
}
