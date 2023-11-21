import 'package:final_project_ba_char/styles/colors.dart';
import 'package:flutter/material.dart';

class TextCountWidget extends StatelessWidget {
  final bool hasItems;
  final VoidCallback onTap;
  final VoidCallback? onTapAddItem;
  final String txt;
  const TextCountWidget({
    super.key,
    required this.hasItems,
    required this.onTap,
    this.onTapAddItem,
    required this.txt,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: !hasItems && onTapAddItem != null
          ? IconButton(
              onPressed: onTapAddItem,
              tooltip: 'Agregar',
              icon: const Icon(
                Icons.add_circle_outline,
                color: Colors.green,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(5.0),
              child: InkWell(
                onTap: hasItems ? onTap : null,
                child: Text(
                  txt,
                  style: TextStyle(
                    decoration: hasItems
                        ? TextDecoration.underline
                        : TextDecoration.none,
                    color: accentColor,
                  ),
                ),
              ),
            ),
    );
  }
}
