import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Funciones que permiten definir de que tamaño es la pantalla de dispositivo
/// y que tipo de layout debe de mostrar (Celular, Tablet, Escritorio) y con sus
/// respectivas orientaciones de pantalla.

/// Breakpoints de ancho de pantalla para determinar el tipo de dispositivo que se está
/// usando.

const int largeScreenSize = 1366;
const int mediumScreenSize = 700;
const int smallScreenSize = 360;

/// Define los posibles tamaños de pantalla, divididos en pequeño, mediano y grande.
enum ScreenSize {
  /// Celulares.
  small,

  /// Tablets y escritorios pequeños.
  medium,

  /// Tamaño de escritorio.
  large,
}

/// Funciones adicionales al tamaño de la pantalla.
extension ScreenSizeExtension on ScreenSize {
  /// Obtiene el padding que debe de tener la pantalla dependiendo de su tamaño.
  double get padding {
    switch (this) {
      case ScreenSize.small:
        return 16.0;
      case ScreenSize.medium:
        return 20.0;
      case ScreenSize.large:
        return 40.0;
    }
  }
}

/// Funciones adicionales al contexto.
extension ContextExtension on BuildContext {
  /// Obtiene el tipo de pantalla en la que se está mostrando la vista.
  ScreenSize get screenSize {
    // Obtiene los valores de tamaños de la pantalla.
    double width = MediaQuery.of(this).size.width;
    double height = MediaQuery.of(this).size.height;

    // Si el ancho de la pantalla es menor del breakpoint de pantalla mediana, la
    // pantalla es de tamaño pequeño.
    // Si la pantalla se está corriendo en celular en modo horizontal la primera
    // condición no entra (ya que es tamaño de ancho mediano) entonces hay que comprobar
    // que el alto de pantalla debe de ser menor a cierto valor para considerarse
    // tamaño de pantalla pequeño.
    if (width < mediumScreenSize ||
        ((kIsWeb || Platform.isIOS || Platform.isAndroid) && height < 450)) {
      return ScreenSize.small;
    }

    // Si el ancho de la pantalla es menor del breakpoint de pantalla grande, la
    // pantalla es de tamaño mediano.
    if (width < largeScreenSize) return ScreenSize.medium;

    // Si no entra en ninguna condición, entonces la pantalla es grande.
    return ScreenSize.large;
  }

  /// Padding que se le debe de poner a la vista dependiendo del tamaño de la pantalla.
  EdgeInsets get contentPadding {
    switch (screenSize) {
      case ScreenSize.small:
        // En tamaño pequeño de pantalla se le agrega un padding al fondo de la vista para
        // poder hacer más scroll y que no esté al ras en el borde de la pantalla.
        return const EdgeInsets.all(16.0).copyWith(bottom: 40);
      case ScreenSize.medium:
        return const EdgeInsets.all(20.0);
      case ScreenSize.large:
        // Solo importa el padding al horizontal. El padding vertical no debe de
        //tener tanto padding.
        return const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20)
            .copyWith(top: 20);
    }
  }

  /// Padding que se le debe de poner dentro de una card dependiendo del tamaño
  /// de la pantalla.
  EdgeInsets get cardPadding {
    switch (screenSize) {
      case ScreenSize.small:
        // En tamaño pequeño de pantalla se le agrega un padding al fondo de la vista para
        // poder hacer más scroll y que no esté al ras en el borde de la pantalla.
        return const EdgeInsets.all(10.0);
      case ScreenSize.medium:
        return const EdgeInsets.all(20.0);
      case ScreenSize.large:
        // Solo importa el padding al horizontal. El padding vertical no debe de
        //tener tanto padding.
        return const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20);
    }
  }
}
