import 'package:final_project_ba_char/styles/colors.dart';
import 'package:final_project_ba_char/widgets/custom_menu_anchor_widget.dart';
import 'package:flutter/material.dart';

// TODO: traducir
class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback? onPressedEdit;
  final List<Widget>? extraWidgets;
  final AlignmentGeometry? alignment;
  final EdgeInsets? padding;
  final Widget? icon;

  const ActionButtonsWidget({
    super.key,
    this.onPressedEdit,
    this.extraWidgets,
    this.alignment,
    this.padding,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment ?? Alignment.centerLeft,
      child: CustomMenuAnchorWidget(
        icon: icon ?? const Icon(Icons.more_vert),
        padding: padding,
        menuChildren: [
          if (onPressedEdit != null)
            CustomMenuItemButton(
              selected: false,
              icon: Icons.edit,
              iconColor: greenApp,
              txt: 'Editar',
              onPressed: onPressedEdit!,
            ),
          ...extraWidgets ?? [],
        ],
      ),
    );
  }
}
