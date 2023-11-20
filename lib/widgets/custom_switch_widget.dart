import 'package:flutter/material.dart';

class CustomSwitchWidget extends StatelessWidget {
  final bool value;
  final void Function(bool)? onChanged;

  const CustomSwitchWidget({
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: Theme.of(context).colorScheme.copyWith(
              outline: Colors.grey,
            ),
      ),
      child: SizedBox(
        height: 30,
        child: FittedBox(
          child: Switch(
            onChanged: onChanged,
            value: value,
          ),
        ),
      ),
    );
  }
}
