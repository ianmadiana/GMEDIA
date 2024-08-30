import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  const AddButton({
    super.key,
    required this.title,
    this.onPressed,
    this.bgButtonColor,
    this.bgTextColor,
  });

  final String title;
  final VoidCallback? onPressed;
  final Color? bgButtonColor;
  final Color? bgTextColor;

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
                      color: Theme.of(context).colorScheme.primary,
                      width: 1,
                    )),
              ),
              backgroundColor: WidgetStateProperty.all(bgButtonColor)),
          child: Text(
            title,
            style: TextStyle(
              color: bgTextColor ?? Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
