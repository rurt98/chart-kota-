import 'package:flutter/material.dart';

class HomeScreenBS extends StatefulWidget {
  const HomeScreenBS({super.key});

  @override
  State<HomeScreenBS> createState() => _HomeScreenBSState();
}

class _HomeScreenBSState extends State<HomeScreenBS> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.code, size: 80),
          Text(
            'En desarrollo',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
