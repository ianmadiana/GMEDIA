import 'package:flutter/material.dart';
import 'package:maspos/screens/login_screen.dart';

import '../widgets/category.dart';
import '../widgets/text_form_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  void _logout() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ));
  }

  void _addCategory() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(children: [
          Form(
            key: _formKey,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Add Category'),
                SizedBox(height: 20),
                TextFormFieldCustom(title: 'Category Name')
              ],
            ),
          ),
        ]),
      ),
    );
  }

  void _addProduct() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(children: [
          Form(
            key: _formKey,
            child: const SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Add Product'),
                  SizedBox(height: 20),
                  // PRODUCT IMAGE
                  TextFormFieldCustom(title: 'Category Product'),
                  SizedBox(height: 20),
                  // PRODUCT NAME
                  TextFormFieldCustom(title: 'Product Name'),
                  SizedBox(height: 20),
                  // PRICE
                  TextFormFieldCustom(title: 'Price'),
                  SizedBox(height: 20),
                  // CATEGORY
                  TextFormFieldCustom(title: 'Category')
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MASPOS'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          const Icon(Icons.shopping_cart_outlined),
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Category(),
                    Category(),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                // + ADD CATEGORY
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: _addCategory,
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                    child: Text(
                      '+ Add Category',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                // ADD PRODUCT
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: _addProduct,
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                    child: Text(
                      '+ Add Product',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
