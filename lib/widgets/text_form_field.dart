import 'package:flutter/material.dart';

class TextFormFieldCustom extends StatefulWidget {
  const TextFormFieldCustom({
    super.key,
    required this.title,
    this.controller,
    this.uploadImg,
     this.enteredProductName,
     this.enteredPrice,
  });

  final String title;
  final IconData? uploadImg;
  final TextEditingController? controller;
  final TextEditingController? enteredProductName;
  final TextEditingController? enteredPrice;

  @override
  State<TextFormFieldCustom> createState() => _TextFormFieldCustomState();
}

class _TextFormFieldCustomState extends State<TextFormFieldCustom> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        filled: true,
        hintText: widget.title,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        suffixIcon: IconButton(onPressed: () {}, icon: Icon(widget.uploadImg)),
      ),
      validator: (value) => value!.isEmpty ? "Masukkan kategori" : null,
      onSaved: (newValue) {
        setState(() {
          newValue = widget.enteredProductName!.text;
        });
      },
    );
  }
}
