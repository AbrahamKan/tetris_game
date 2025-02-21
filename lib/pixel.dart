import 'package:flutter/material.dart';

// Definimos un widget personalizado llamado Pixel, que extiende StatelessWidget.
class Pixel extends StatelessWidget {
  // Declaramos dos variables para el color y el contenido del Pixel.
  var color;
  var child;

  // Constructor del widget Pixel, donde se requieren los parámetros color y child.
  // Se usa `super.key` para manejar claves en los widgets.
  Pixel({super.key,
  required this.color,
  required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Definimos la decoración del contenedor con un color de fondo y bordes redondeados.
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
      // Agregamos un margen de 1 píxel alrededor del contenedor.
      margin: EdgeInsets.all(1),
      // Centramos el contenido dentro del contenedor.
      child: Center(
        child: Text(
          // Convertimos el `child` a String y lo mostramos como texto dentro del Pixel.
          child.toString(),
          // Definimos el estilo del texto con color blanco.
          style: TextStyle(color: Colors.white),
        ),
      )
    );
  }
}
