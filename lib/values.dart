// Importamos el paquete de Flutter para trabajar con la interfaz gráfica.
import 'package:flutter/material.dart';

// Definimos las dimensiones de la cuadrícula del juego.
int rowLength = 10; // Número de filas
int colLenght = 15; // Número de columnas

// Definimos una enumeración para las direcciones posibles de movimiento de las piezas.
enum Direction {
  left,  // Izquierda
  right, // Derecha
  down,  // Abajo
}

// Definimos una enumeración para los diferentes tipos de piezas de Tetris (Tetrominós).
enum Tetromino {
  L,
  J,
  I,
  O,
  S,
  Z,
  T,
}

// Mapeamos cada tipo de Tetromino a un color específico.
const Map<Tetromino, Color> tetrominoColors = {
  Tetromino.L: Color(0xFFFFA500), // Naranja
  Tetromino.J: Color.fromARGB(255, 0, 102, 255), // Azul
  Tetromino.I: Color.fromARGB(255, 242, 0, 255), // Rosa
  Tetromino.O: Color(0xFFFFFF00), // Amarillo
  Tetromino.S: Color(0xFF008000), // Verde
  Tetromino.Z: Color(0xFFFF0000), // Rojo
  Tetromino.T: Color.fromARGB(255, 144, 0, 255), // Púrpura
};
