import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  AddButton({
    super.key,
    required this.title,
    this.onPressed,
    this.color,
  });

  final String title;
  final VoidCallback? onPressed;
  Color? color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              backgroundColor: WidgetStateProperty.all(color)),
          child: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
