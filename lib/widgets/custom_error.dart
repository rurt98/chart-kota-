import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// TODO: traducir

class CustomError extends StatelessWidget {
  const CustomError({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 100,
          child: Lottie.asset(
            'assets/lotties/error.json',
            repeat: true,
          ),
        ),
        const Text("Error al obtener los datos"),
      ],
    );
  }
}
