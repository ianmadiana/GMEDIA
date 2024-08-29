import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maspos/models/cart_item_model.dart';
import 'package:maspos/models/product_model.dart';
import 'package:maspos/screens/cart_screen.dart';
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
  List<ProductModel> _products = [];
  List<CategoryModel> _categories = [];
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategoryId;
  XFile? _selectedImage;

  TextEditingController productNameC = TextEditingController();
  TextEditingController productPriceC = TextEditingController();

  String _enteredProductName = '';
  int _enteredProductPrice = 0;

  @override
  void initState() {
    _apiServices = ApiServices(widget.token);
    _loadCategories();
    _loadProducts();
    super.initState();
  }

  @override
  void dispose() {
    productNameC.dispose();
    productPriceC.dispose();
    super.dispose();
  }

  Future<void> _saveItem(ProductModel product) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await _apiServices.addProduct(
          _enteredProductName,
          _enteredProductPrice,
          _selectedCategoryId!,
          _selectedImage!.path,
        );
        await _loadProducts();

        setState(() {
          productNameC.clear();
          productPriceC.clear();
          _selectedCategoryId = null;
          _selectedImage = null;
        });
      } catch (e) {
        print('Error : $e');
      }
    }
  }

  _imagePreview() {
    if (_selectedImage != null) {
      return Image.file(
        File(_selectedImage!.path),
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    } else {
      return const Text('Upload image');
    }
  }

  Future<void> _loadProducts() async {
    try {
      final products = await _apiServices.getAllProduct();
      setState(() {
        _products = products;
      });
    } catch (e) {
      print('Failed to load products: $e');
    }
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _apiServices.getCategories();
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      // print('Failed to load products: $e');
    }
  }

  void _logout() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ));
  }

  void _goToCart() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CartScreen(),
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
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => DraggableScrollableSheet(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () async {
                                final ImagePicker picker = ImagePicker();
                                final XFile? pickedImage = await picker
                                    .pickImage(source: ImageSource.gallery);
                                if (pickedImage != null) {
                                  setState(() {
                                    _selectedImage = pickedImage;
                                  });
                                }
                              },
                              icon: const Icon(Icons.cloud_upload_outlined),
                            ),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedImage = null;
                                  });
                                },
                                icon: const Icon(Icons.delete)),
                            _imagePreview()
                          ],
                        ),
                        const SizedBox(height: 20),
                        // PRODUCT NAME
                        TextFormField(
                          controller: productNameC,
                          decoration: InputDecoration(
                            filled: true,
                            hintText: 'Masukkan nama produk',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? "Masukkan nama produk" : null,
                          onSaved: (newValue) {
                            setState(() {
                              _enteredProductName = newValue!;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        // PRICE
                        TextFormField(
                          controller: productPriceC,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: true,
                            hintText: 'Masukkan harga produk',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? "Masukkan harga produk" : null,
                          onSaved: (newValue) {
                            setState(() {
                              _enteredProductPrice = int.parse(newValue!);
                            });
                          },
                        ),
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
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          title: 'Tambah',
                          onPressed: () {
                            ProductModel product = ProductModel(
                              categoryId: _selectedCategoryId!,
                              name: _enteredProductName,
                              price: _enteredProductPrice,
                              pictureUrl: _selectedImage!.path,
                            );
                            _saveItem(product);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
        title: Text(
          'MASPOS',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_alt_outlined),
          ),
          IconButton(
            onPressed: _goToCart,
            icon: Icon(Icons.shopping_cart_outlined),
          ),
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: _products.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final productsInCategory = _products
                            .where(
                                (product) => product.categoryId == category.id)
                            .toList();

                        return Category(
                          category: category,
                          products: productsInCategory,
                          token: widget.token,
                          onLoad: _loadProducts,
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
            ),
          ],
        ),
      ),
    );
  }
}
