import 'package:final_project_ba_char/styles/colors.dart';
import 'package:flutter/material.dart';

class CustomMenuAnchorWidget extends StatelessWidget {
  final List<Widget> menuChildren;
  final Widget icon;
  final EdgeInsets? padding;
  const CustomMenuAnchorWidget({
    super.key,
    required this.icon,
    required this.menuChildren,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      menuChildren: menuChildren,
      style: MenuStyle(
        elevation: MaterialStateProperty.resolveWith<double>((_) => 8.0),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      builder:
          (BuildContext context, MenuController controller, Widget? child) =>
              GestureDetector(
        onTap: () => controller.isOpen ? controller.close() : controller.open(),
        child: icon,
      ),
    );
  }
}

class CustomMenuItemButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool selected;
  final String txt;
  final IconData? icon;
  final Color? iconColor;
  const CustomMenuItemButton({
    super.key,
    required this.onPressed,
    required this.selected,
    required this.txt,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return MenuItemButton(
      onPressed: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 8,
        ),
        child: Row(
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 18,
                color: iconColor,
              ),
            const SizedBox(width: 8),
            Text(
              txt,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: darkGreyApp,
                fontSize: 12,
              ),
            ),
            if (selected) ...[
              const SizedBox(width: 10),
              Icon(Icons.check_circle, color: darkGreyApp, size: 13),
            ],
          ],
        ),
      ),
    );
  }
}
