import 'package:flutter/material.dart'; // Importa Flutter (widgets básicos).
import 'board.dart'; // Importa el tablero del juego (archivo local).

void main() {
  runApp(const MyApp()); // Inicia la app con `MyApp` como raíz.
}

class MyApp extends StatelessWidget { // Widget sin estado (no cambia).
  const MyApp({super.key}); // Constructor con clave.

  @override
  Widget build(BuildContext context) { // Construye la interfaz.
    return MaterialApp( // Configura la app con diseño Material.
      debugShowCheckedModeBanner: false, // Oculta el banner de debug.
      home: GameBoard(), // Pantalla inicial: `GameBoard`.
    );
  }
}
