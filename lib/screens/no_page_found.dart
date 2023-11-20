import 'package:final_project_ba_char/helpers/responsive_helpers.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoPageFound extends StatelessWidget {
  const NoPageFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Lottie.asset(
                  'assets/lotties/404.json',
                  width: size.width * 0.35,
                  repeat: true,
                  fit: BoxFit.fitWidth,
                ),
              ),
              const SizedBox(
                height: 40.0,
              ),
              if (context.screenSize == ScreenSize.small) ...[
                _buildInfColumn(size, context),
              ] else ...[
                _buildInfoRow(size, context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfColumn(Size size, BuildContext context) {
    return SizedBox(
      width: size.width * 0.7,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Oops!',
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Text(
            "Parece que no podemos encontrar la página que estás buscando",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(Size size, BuildContext context) {
    return SizedBox(
      width: size.width * 0.7,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (context.screenSize != ScreenSize.small) const Spacer(),
          const Text(
            'Oops!',
            style: TextStyle(
              fontSize: 70,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            width: 30.0,
          ),
          const Expanded(
            child: Text(
              "Parece que no podemos encontrar la página que estás buscando",
            ),
          ),
          if (context.screenSize != ScreenSize.small) const Spacer(),
        ],
      ),
    );
  }
}
