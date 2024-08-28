import 'package:flutter/material.dart';

class TextFormFieldCustom extends StatelessWidget {
  const TextFormFieldCustom({
    super.key,
    required this.title,
    this.controller,
    this.uploadImg,
  });

  final String title;
  final IconData? uploadImg;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        hintText: title,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        suffixIcon: IconButton(onPressed: () {}, icon: Icon(uploadImg)),
      ),
      validator: (value) => value!.isEmpty ? "Masukkan kategori" : null,
    );
  }
}
