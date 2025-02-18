import 'package:flutter/material.dart'; // Importa el paquete de Material Design para construir la UI.
import 'board.dart'; // Importa el archivo 'board.dart', donde probablemente está definido el tablero del juego.

void main() {
  runApp(const MyApp()); // Punto de entrada de la aplicación. Ejecuta MyApp como la raíz de la UI.
}

// Define la clase principal de la aplicación, que es un StatelessWidget (no tiene estado interno).
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Constructor con una clave opcional para optimización.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Oculta la etiqueta de "Debug" en la parte superior derecha.
      home: GameBoard(), // Establece 'GameBoard' como la pantalla principal de la aplicación.
    );
  }
}
