import 'package:flutter/services.dart';  // Importa la biblioteca de servicios de Flutter, aunque en este código no se usa.
import 'package:tetris_game/board.dart';  // Importa el archivo 'board.dart' que probablemente contiene la configuración del tablero.
import 'package:tetris_game/values.dart';  // Importa el archivo 'values.dart' que contiene valores como colores y constantes.

class Piece {  // Define la clase `Piece`, que representa una pieza de Tetris.

  // Tipo de pieza de Tetris (L, J, I, O, S, Z, T).
  Tetromino type;

  // Constructor de la clase `Piece`, que requiere el tipo de pieza como argumento.
  Piece({required this.type});

  // La posición de la pieza en el tablero, representada como una lista de enteros.
  List<int> position = [];

  // Color de la pieza de Tetris.
  Color get color {
    return tetrominoColors[type] ??
      const Color(0xFFFFFFFF);  // Si no se encuentra el color en `tetrominoColors`, usa blanco por defecto.
  }

  // Método para inicializar la posición de la pieza en el tablero.
  void initializePiece() {
    switch (type) {  // Evalúa el tipo de pieza y asigna una lista de posiciones iniciales.
      case Tetromino.L:
        position = [
          -26,  // Posiciones relativas en la cuadrícula del tablero.
          -16,
          -6,
          -5,
        ];
        break;
      case Tetromino.J:
        position = [
          -25,
          -15,
          -5,
          -6,
        ];
        break;
      case Tetromino.I:
        position = [
          -4,
          -5,
          -6,
          -7,
        ];
        break;
      case Tetromino.O:
        position = [
          -15,
          -16,
          -5,
          -6,
        ];
        break;
      case Tetromino.S:
        position = [
          -15,
          -14,
          -6,
          -5,
        ];
        break;
      case Tetromino.Z:
        position = [
          -17,
          -16,
          -6,
          -5,
        ];
        break;
      case Tetromino.T:
        position = [
          -26,
          -16,
          -6,
          -15,
        ];
        break;
      default:
        // No hace nada si el tipo de pieza no coincide con ningún caso.
    }
  }

  // Método para mover la pieza en el tablero.
  void movePiece(Direction direction) {
    switch (direction) {  // Evalúa la dirección del movimiento.
      case Direction.down:  // Mover hacia abajo.
        for (int i = 0; i < position.length; i++) {
          position[i] += rowLength;  // Suma `rowLength` a cada posición para moverla una fila hacia abajo.
        }
        break;
      case Direction.left:  // Mover hacia la izquierda.
        for (int i = 0; i < position.length; i++) {
          position[i] -= 1;  // Resta 1 a cada posición para mover la pieza una columna a la izquierda.
        }
        break;
      case Direction.right:  // Mover hacia la derecha.
        for (int i = 0; i < position.length; i++) {
          position[i] += 1;  // Suma 1 a cada posición para mover la pieza una columna a la derecha.
        }
        break;
      default:
        // No hace nada si la dirección no es válida.
    }
  }

///////////////////////////////////////////////
  // Estado de rotación de la pieza. Comienza en 1.
  int rotationState = 1;

  // Método para rotar la pieza.
  void rotatePiece() {
    // Nueva posición después de la rotación.
    List<int> newPosition = [];

    // Determina la rotación según el tipo de pieza.
    switch (type) {
      case Tetromino.L:  // Si la pieza es de tipo 'L'.
        switch (rotationState) {  // Evalúa el estado de rotación actual.

          case 0:  // Estado de rotación 0.
            newPosition = [
              position[1] - rowLength,       // Celda arriba de la celda base.
              position[1],                   // Celda base.
              position[1] + rowLength,       // Celda abajo de la celda base.
              position[1] + rowLength + 1,   // Celda abajo a la derecha.
            ];
            // Verifica si la nueva posición es válida antes de asignarla.
            if (piecePositionIsValid(newPosition)) {
              // Actualiza la posición de la pieza.
              position = newPosition;
              // Cambia al siguiente estado de rotación (0 → 1 → 2 → 3 → 0).
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 1:  // Estado de rotación 1.
            newPosition = [
              position[1] - 1,               // Celda a la izquierda de la base.
              position[1],                   // Celda base.
              position[1] + 1,               // Celda a la derecha de la base.
              position[1] + rowLength - 1,   // Celda abajo a la izquierda.
            ];
            // Verifica si la nueva posición es válida.
            if (piecePositionIsValid(newPosition)) {
              // Actualiza la posición de la pieza.
              position = newPosition;
              // Cambia al siguiente estado de rotación.
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 2:  // Estado de rotación 2.
            newPosition = [
              position[1] + rowLength,       // Celda abajo de la base.
              position[1],                   // Celda base.
              position[1] - rowLength,       // Celda arriba de la base.
              position[1] - rowLength - 1,   // Celda arriba a la izquierda.
            ];
            // Verifica si la nueva posición es válida.
            if (piecePositionIsValid(newPosition)) {
              // Actualiza la posición de la pieza.
              position = newPosition;
              // Cambia al siguiente estado de rotación.
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 3:  // Estado de rotación 3.
            newPosition = [
              position[1] - rowLength + 1,   // Celda arriba a la derecha.
              position[1],                   // Celda base.
              position[1] + 1,               // Celda a la derecha de la base.
              position[1] - 1,               // Celda a la izquierda de la base.
            ];
            // Verifica si la nueva posición es válida.
            if (piecePositionIsValid(newPosition)) {
              // Actualiza la posición de la pieza.
              position = newPosition;
              // Restablece el estado de rotación a 0 (vuelve al inicio del ciclo).
              rotationState = 0;
            }
            break;
        }
        break;

        case Tetromino.J:
        switch(rotationState) {
          case 0:
          newPosition = [
            position[1] - rowLength,
            position[1],
            position[1] + rowLength,
            position[1] + rowLength - 1,
          ];
          //check that this new position is a valid move before assigning it to the real position
         if(piecePositionIsValid(newPosition)){
           //update position
          position = newPosition ;
          // update rotation state
          rotationState = (rotationState + 1) % 4;
         }
          break;

          case 1:
          newPosition = [
            position[1] - rowLength - 1,
            position[1],
            position[1] - 1,
            position[1] + 1,
          ];
           //check that this new position is a valid move before assigning it to the real position
         if(piecePositionIsValid(newPosition)){
           //update position
          position = newPosition ;
          // update rotation state
          rotationState = (rotationState + 1) % 4;
         }
          break;

          case 2:
          newPosition = [
            position[1] + rowLength,
            position[1],
            position[1] - rowLength,
            position[1] - rowLength + 1,
          ];
          //check that this new position is a valid move before assigning it to the real position
         if(piecePositionIsValid(newPosition)){
           //update position
          position = newPosition ;
          // update rotation state
          rotationState = (rotationState + 1) % 4;
         }
          break;

          case 3:
          newPosition = [
            position[1] + 1,
            position[1],
            position[1] - 1,
            position[1] + rowLength + 1
          ];
          //check that this new position is a valid move before assigning it to the real position
         if(piecePositionIsValid(newPosition)){
           //update position
          position = newPosition ;
          // update rotation state
          rotationState = 0; // reset rotation state to 0 
         }
          break;
        }
        break;

        case Tetromino.I:
        switch(rotationState) {
          case 0:
          newPosition = [
            position[1] - 1,
            position[1],
            position[1] + 1,
            position[1] + 2
          ];
          //check that this new position is a valid move before assigning it to the real position
         if(piecePositionIsValid(newPosition)){
           //update position
          position = newPosition ;
          // update rotation state
          rotationState = (rotationState + 1) % 4;
         }
          break;

          case 1:
          newPosition = [
            position[1] - rowLength,
            position[1],
            position[1] + rowLength,
            position[1] + 2 * rowLength
          ];
           //check that this new position is a valid move before assigning it to the real position
         if(piecePositionIsValid(newPosition)){
           //update position
          position = newPosition ;
          // update rotation state
          rotationState = (rotationState + 1) % 4;
         }
          break;

          case 2:
          newPosition = [
            position[1] + 1,
            position[1],
            position[1] - 1,
            position[1] - 2,
          ];
          //check that this new position is a valid move before assigning it to the real position
         if(piecePositionIsValid(newPosition)){
           //update position
          position = newPosition ;
          // update rotation state
          rotationState = (rotationState + 1) % 4;
         }
          break;

          case 3:
          newPosition = [
            position[1] + rowLength,
            position[1],
            position[1] - rowLength,
            position[1] - 2 * rowLength
          ];
          //check that this new position is a valid move before assigning it to the real position
         if(piecePositionIsValid(newPosition)){
           //update position
          position = newPosition ;
          // update rotation state
          rotationState = 0; // reset rotation state to 0
         }
          break;
        }
        break;

        case Tetromino.O:
        /* no tiene rotacion */
        break;


        case Tetromino.S:
        switch(rotationState) {
          case 0:
          newPosition = [
            position[1],
            position[1] + 1,
            position[1] + rowLength - 1,
            position[1] + rowLength
          ];
          //check that this new position is a valid move before assigning it to the real position
         if(piecePositionIsValid(newPosition)){
           //update position
          position = newPosition ;
          // update rotation state
          rotationState = (rotationState + 1) % 4;
         }
          break;

          case 1:
          newPosition = [
            position[0] - rowLength,
            position[0],
            position[0] + 1,
            position[0] + rowLength + 1
          ];
           //check that this new position is a valid move before assigning it to the real position
         if(piecePositionIsValid(newPosition)){
           //update position
          position = newPosition ;
          // update rotation state
          rotationState = (rotationState + 1) % 4;
         }
          break;

          case 2:
          newPosition = [
            position[1],
            position[1] + 1,
            position[1] + rowLength - 1,
            position[1] + rowLength
          ];
          //check that this new position is a valid move before assigning it to the real position
         if(piecePositionIsValid(newPosition)){
           //update position
          position = newPosition ;
          // update rotation state
          rotationState = (rotationState + 1) % 4;
         }
          break;

          case 3:
          newPosition = [
            position[0] - rowLength,
            position[0],
            position[0] + 1,
            position[0] + rowLength + 1
          ];
          //check that this new position is a valid move before assigning it to the real position
         if(piecePositionIsValid(newPosition)){
           //update position
          position = newPosition ;
          // update rotation state
          rotationState = 0; // reset rotation state to 0 
         }
          break;
        }
        break;
case Tetromino.Z:
  switch (rotationState) {
    case 0:
      newPosition = [
        position[0] + rowLength - 2,
        position[1],
        position[2] + rowLength - 1,
        position[3] + 1
      ];
      // Check that this new position is a valid move before assigning it to the real position
      if (piecePositionIsValid(newPosition)) {
        // Update position
        position = newPosition;
        // Update rotation state
        rotationState = (rotationState + 1) % 4;
      }
      break;

    case 1:
      newPosition = [
        position[0] - rowLength + 2,
        position[1],
        position[2] - rowLength + 1,
        position[3] - 1
      ];
      // Check that this new position is a valid move before assigning it to the real position
      if (piecePositionIsValid(newPosition)) {
        // Update position
        position = newPosition;
        // Update rotation state
        rotationState = (rotationState + 1) % 4;
      }
      break;

    case 2:
      newPosition = [
        position[0] + rowLength - 2,
        position[1],
        position[2] + rowLength - 1,
        position[3] + 1
      ];
      // Check that this new position is a valid move before assigning it to the real position
      if (piecePositionIsValid(newPosition)) {
        // Update position
        position = newPosition;
        // Update rotation state
        rotationState = (rotationState + 1) % 4;
      }
      break;

    case 3:
      newPosition = [
        position[0] - rowLength + 2,
        position[1],
        position[2] - rowLength + 1, // Corregido: era "+ rowLength + 1"
        position[3] - 1
      ];
      // Check that this new position is a valid move before assigning it to the real position
      if (piecePositionIsValid(newPosition)) {
        // Update position
        position = newPosition;
        // Update rotation state
        rotationState = 0; // Reset rotation state to 0
      }
      break;
  }
  break;

        case Tetromino.T:
        switch(rotationState) {
          case 0:
          newPosition = [
            position[2] - rowLength,
            position[2],
            position[2] + 1,
            position[2] + rowLength,
          ];
          //check that this new position is a valid move before assigning it to the real position
         if(piecePositionIsValid(newPosition)){
           //update position
          position = newPosition ;
          // update rotation state
          rotationState = (rotationState + 1) % 4;
         }
          break;

          case 1:
          newPosition = [
            position[1] - 1,
            position[1],
            position[1] + 1,
            position[1] + rowLength,
          ];
           //check that this new position is a valid move before assigning it to the real position
         if(piecePositionIsValid(newPosition)){
           //update position
          position = newPosition ;
          // update rotation state
          rotationState = (rotationState + 1) % 4;
         }
          break;

          case 2:
          newPosition = [
            position[1] - rowLength,
            position[1] - 1,
            position[1],
            position[1] + rowLength
          ];
          //check that this new position is a valid move before assigning it to the real position
         if(piecePositionIsValid(newPosition)){
           //update position
          position = newPosition ;
          // update rotation state
          rotationState = (rotationState + 1) % 4;
         }
          break;

          case 3:
          newPosition = [
            position[2] - rowLength,
            position[2] - 1,
            position[2],
            position[2] + 1,
          ];
          //check that this new position is a valid move before assigning it to the real position
         if(piecePositionIsValid(newPosition)){
           //update position
          position = newPosition ;
          // update rotation state
          rotationState = 0; // reset rotation state to 0
         }
          break;
        }
        break;
    }
  }

  // Verifica si una posición individual en el tablero es válida.
  bool positionIsValid(int position) {
    // Obtiene la fila en la que se encuentra la posición.
    int row = (position / rowLength).floor();
    // Obtiene la columna en la que se encuentra la posición.
    int col = position % rowLength;

    // Si la posición está fuera de los límites o ya está ocupada en el tablero, retorna falso.
    if (row < 0 || col < 0 || gameBoard[row][col] != null) {
      return false;
    }

    // De lo contrario, la posición es válida y retorna verdadero.
    else {
      return true;
    }
  }

  // Verifica si toda una pieza puede ubicarse en una posición válida.
  bool piecePositionIsValid(List<int> piecePosition) {
    // Variables para detectar si la pieza ocupa la primera o la última columna.
    bool firstColOccupied = false;
    bool lastColOccupied = false;

    // Itera sobre cada celda de la pieza.
    for (int pos in piecePosition) {
      // Si alguna posición ya está ocupada o es inválida, retorna falso.
      if (!positionIsValid(pos)) {
        return false;
      }

      // Obtiene la columna en la que se encuentra la posición actual.
      int col = pos % rowLength;

      // Verifica si alguna parte de la pieza está en la primera columna.
      if (col == 0) {
        firstColOccupied = true;
      }
      // Verifica si alguna parte de la pieza está en la última columna.
      if (col == rowLength - 1) {
        lastColOccupied = true;
      }
    }

    // Si la pieza ocupa tanto la primera como la última columna, significa que atraviesa la pared del tablero.
    // En este caso, retorna falso para evitar la rotación ilegal.
    return !(firstColOccupied && lastColOccupied);
  }
}