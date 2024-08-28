import 'package:flutter/material.dart';
import 'package:maspos/models/product_model.dart';
import 'package:maspos/screens/login_screen.dart';
import 'package:maspos/services/api_service.dart';

import '../models/category_model.dart';
import '../widgets/add_button.dart';
import '../widgets/category.dart';
import '../widgets/custom_button.dart';
import '../widgets/text_form_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.token});

  final String token;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ApiServices _apiServices;
  List<CategoryModel> _categories = [];
  List<ProductModel> _products = [];
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategoryId;

  @override
  void initState() {
    _apiServices = ApiServices(widget.token);
    _loadCategories();
    _loadProducts();
    super.initState();
  }

  Future<void> _loadCategories() async {
    final categories = await _apiServices.getCategories();
    setState(() {
      _categories = categories;
    });
  }

  Future<void> _loadProducts() async {
    final products = await _apiServices.getAllProduct();
    setState(() {
      _products = products;
    });
  }

  void _logout() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ));
  }

  void _addCategory() {
    final categoryController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Add Category'),
                      const SizedBox(height: 20),
                      // PRODUCT IMAGE
                      TextFormFieldCustom(
                        title: 'Category Product',
                        controller: categoryController,
                      ),
                      const SizedBox(height: 20),
                      // const CustomButton(title: 'Tambah', onPressed: null),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                Theme.of(context).colorScheme.primary),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                await _apiServices
                                    .addCategory(categoryController.text);
                                await _loadCategories();
                                Navigator.pop(context);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Failed to add category: $e')),
                                );
                              }
                            }
                          },
                          child: const Text(
                            'Tambah',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addProduct() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Add Product'),
                      const SizedBox(height: 20),
                      // PRODUCT IMAGE
                      const TextFormFieldCustom(title: 'Product Image'),
                      const SizedBox(height: 20),
                      // PRODUCT NAME
                      const TextFormFieldCustom(title: 'Product Name'),
                      const SizedBox(height: 20),
                      // PRICE
                      const TextFormFieldCustom(title: 'Price'),
                      const SizedBox(height: 20),
                      // CATEGORY
                      SizedBox(
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Select Item',
                          ),
                          value: _selectedCategoryId,
                          items: _categories.map(
                            (category) {
                              return DropdownMenuItem(
                                value: category.id,
                                child: Text(category.name),
                              );
                            },
                          ).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategoryId = value;
                            });
                            print('Selected value ID: $value');
                          },
                        ),
                      ),

                      const SizedBox(height: 20),
                      const CustomButton(title: 'Tambah'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
            Expanded(
              child: ListView.builder(
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  return Category(
                    product: _products[index],
                    category: category,
                  );
                },
              ),
            ),
            Row(
              children: [
                // + ADD CATEGORY
                AddButton(title: '+ Add Category', onPressed: _addCategory),
                const SizedBox(width: 10),
                // ADD PRODUCT
                AddButton(title: '+ Add Product', onPressed: _addProduct),
              ],
            )
          ],
        ),
      ),
    );
  }
}
