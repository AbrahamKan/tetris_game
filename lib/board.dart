import 'dart:async'; // Para usar temporizadores (Timer).
import 'dart:math'; // Para generar números aleatorios (Random).
import 'package:flutter/material.dart'; // Widgets básicos de Flutter.
import 'package:tetris_game/pixel.dart'; // Widget personalizado para los bloques del juego.
import 'package:tetris_game/values.dart'; // Constantes como rowLength y colLength.
import 'piece.dart'; // Lógica de las piezas del Tetris.

/*

GAME BOARD

This is a 2x2 grid with null representing an empty space
a non empty space will have the color to represent the landed pieces

*/

//creación del tablero
List<List<Tetromino?>> gameBoard = List.generate( // Crea una lista bidimensional (matriz) para representar el tablero.
  colLenght, // Define el número de filas del tablero (colLenght).
  (i) => List.generate(rowLength, (j) => null), // Para cada fila, crea una lista con rowLength columnas, inicializadas en null.
);

class GameBoard extends StatefulWidget { // Define una clase llamada GameBoard que extiende StatefulWidget, permitiendo que el widget tenga un estado mutable.
  const GameBoard({super.key}); // Constructor del widget.

  @override
  State<GameBoard> createState() => _GameBoardState(); // Crea el estado del widget.
}

class _GameBoardState extends State<GameBoard> { // Define una clase privada _GameBoardState que extiende State<GameBoard>, encargada de manejar el estado y la lógica del widget GameBoard.
  // current tetris piece
  Piece currentPiece = Piece(type: Tetromino.L); // Pieza actual en juego.

  //current score
  int currentScore = 0; // Puntuación del jugador.

  //GAME OVER status
  bool gameOver = false; // Estado de fin de juego.

  @override
  void initState() { // Sobrescribe el método initState, que se ejecuta una sola vez cuando el StatefulWidget se inserta en el árbol de widgets.
    super.initState();// Llama al método initState de la clase padre (State) para asegurar que la inicialización básica se complete.

    // start game when app starts
    startGame(); // Inicia el juego cuando el widget se carga.
  }

  void startGame() {
    currentPiece.initializePiece(); // Inicializa la posición de la pieza.

    //frame refresh rate
    Duration frameRate = const Duration(milliseconds: 600); // Intervalo de actualización.
    gameLoop(frameRate); // Inicia el bucle del juego.
  }

  //game loop
  void gameLoop(Duration frameRate) { // Define un método llamado gameLoop que recibe un parámetro frameRate de tipo Duration.
    Timer.periodic( // Inicia un temporizador periódico que se ejecuta repetidamente.
      frameRate, // Define el intervalo de tiempo entre cada ejecución del bucle.
      (timer) { // Función de callback que se ejecuta cada vez que el temporizador llega al intervalo definido.
        setState(() { // Llama a setState para actualizar el estado del widget y reconstruir la interfaz.
          //Clear lines
          clearLines(); // Llama al método clearLines para eliminar las líneas completas del tablero.

          //check landing
          checkLanding(); // Llama al método checkLanding para verificar si la pieza actual ha aterrizado.

          // check if game is over
          if (gameOver == true) { // Verifica si la variable gameOver es true, indicando que el juego ha terminado.
            timer.cancel(); // Detiene el temporizador para que el bucle deje de ejecutarse.
            showGameOverDialog(); // Llama al método showGameOverDialog para mostrar un diálogo de fin de juego.
          }

          //move current pice down
          currentPiece.movePiece(Direction.down); // Mueve la pieza actual hacia abajo en el tablero.
        });
      },
    );
  }

  //GAME OVER MESSAGE
  void showGameOverDialog() { // Define un método llamado showGameOverDialog para mostrar un diálogo de fin de juego.
    showDialog( // Función de Flutter para mostrar un diálogo.
      context: context, // Proporciona el contexto necesario para mostrar el diálogo.
      builder: (context) => AlertDialog( // Constructor del diálogo, que devuelve un AlertDialog.
        title: Text('Game Over'), // Establece el título del diálogo como "Game Over".
        content: Text("Your Score is: $currentScore"), // Muestra el contenido del diálogo, incluyendo la puntuación actual.
        actions: [ // Define las acciones (botones) que aparecerán en el diálogo.
          TextButton( // Crea un botón de texto.
            onPressed: () { // Define lo que sucede cuando se presiona el botón.
              //Reset the game
              resetGame(); // Llama al método resetGame para reiniciar el juego.

              Navigator.pop(context); // Cierra el diálogo y regresa a la pantalla anterior.
            },
            child: Text('Play Again'), // Establece el texto del botón como "Play Again".
          ),
        ],
      ),
    );
  }

  //Reset
  void resetGame() {
    //clear
    gameBoard = List.generate(
      colLenght,
      (i) => List.generate(
        rowLength,
        (j) => null,
      ),
    ); // Limpia el tablero.

    //new game
    gameOver = false; // Reinicia el estado de fin de juego.
    currentScore = 0; // Reinicia la puntuación.

    //create new piece
    createNewPiece(); // Crea una nueva pieza.

    //start gamer again
    startGame(); // Reinicia el juego.
  }

  //check for collision in a future position
  //return true -> there is a collision
  //return false -> there is no collision
  bool checkCollision(Direction direction) {
    //loop through each position of the current piece
    for (int i = 0; i < currentPiece.position.length; i++) {
      //calculate the row and column of the current position
      int row = (currentPiece.position[i] / rowLength).floor(); // Calcula la fila.
      int col = currentPiece.position[i] % rowLength; // Calcula la columna.

      //adjust the row and col based on the direction
      if (direction == Direction.left) {
        col -= 1; // Mueve a la izquierda.
      } else if (direction == Direction.right) {
        col += 1; // Mueve a la derecha.
      } else if (direction == Direction.down) {
        row += 1; // Mueve hacia abajo.
      }

      // check if the piece is out of bounds (either too low or too far to the left or right)
      if (row >= colLenght || col < 0 || col >= rowLength) {
        return true; // Hay colisión con los bordes.
      }

      // check if the position is already occupied in the gameBoard
      if (row >= 0 && col >= 0 && gameBoard[row][col] != null) {
        return true; // Hay colisión con otra pieza.
      }
    }

    // if no collisions are detected, return false
    return false; // No hay colisión.
  }

  void checkLanding() {
    //if going down is occupied
    if (checkCollision(Direction.down)) { // Si hay colisión hacia abajo.
      //mark position as occupied on the gameboard
      for (int i = 0; i < currentPiece.position.length; i++) {
        int row = (currentPiece.position[i] / rowLength).floor();
        int col = currentPiece.position[i] % rowLength;
        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = currentPiece.type; // Marca la posición como ocupada.
        }
      }

      //once landed, create the next piece
      createNewPiece(); // Crea una nueva pieza.
    }
  }

// Define un método para crear una nueva pieza en el juego.
  void createNewPiece() {
    // create a random object to generate random tetromino types
    Random rand = Random(); // Crea un objeto Random para generar números aleatorios.

    //create a new piece with random type
    Tetromino randomType = Tetromino.values[rand.nextInt(Tetromino.values.length)]; // Selecciona un tipo de tetromino aleatorio de la lista de valores posibles.
    currentPiece = Piece(type: randomType); // Crea una nueva pieza con el tipo aleatorio y la asigna a currentPiece.
    currentPiece.initializePiece(); // Inicializa la posición de la pieza en el tablero.

    if (isGameOver()) { // Verifica si el juego ha terminado llamando al método isGameOver.
      gameOver = true; // Si el juego terminó, establece gameOver en true.
    }
  }

  //move left
  void moveLeft() {
    //make sure the move is valid before moving there
    if (!checkCollision(Direction.left)) { // Si no hay colisión.
      setState(() {
        currentPiece.movePiece(Direction.left); // Mueve la pieza a la izquierda.
      });
    }
  }

  //move right
  void moveRight() {
    //make sure the move is valid before moving there
    if (!checkCollision(Direction.right)) { // Si no hay colisión.
      setState(() {
        currentPiece.movePiece(Direction.right); // Mueve la pieza a la derecha.
      });
    }
  }

// Función para bajar rápidamente
void dropPieceFast() {
  setState(() {
    while (!checkCollision(Direction.down)) { // Mientras no haya colisión hacia abajo.
      currentPiece.movePiece(Direction.down); // Mueve la pieza hacia abajo.
    }
    // Cuando la pieza ya no pueda moverse, verifica si aterrizó.
    checkLanding();
    // Verifica si el juego terminó.
    if (isGameOver()) {
      gameOver = true;
      showGameOverDialog();
    }
  });
}

  //rotate piece
void rotatePiece() { // Define un método llamado rotatePiece para rotar la pieza actual.
    setState(() { // Llama a setState para actualizar el estado del widget y reconstruir la interfaz.
      currentPiece.rotatePiece(); // Llama al método rotatePiece de la pieza actual para rotarla.
    });
  }

  // clear lines
void clearLines() { // Define un método llamado clearLines para eliminar las líneas completas del tablero.
    // step 1: loop through each row of the game board from bottom to top
    for (int row = colLenght - 1; row >= 0; row--) { // Recorre cada fila del tablero desde la parte inferior hacia arriba.
      //step 2: initialize a variable to track if the row is full
      bool rowIsFull = true; // Inicializa una variable para verificar si la fila está completamente llena.

      // step 3: loop through each column in the current row
      for (int col = 0; col < rowLength; col++) { // Recorre cada columna de la fila actual.
        //if there is an empty cell
        if (gameBoard[row][col] == null) { // Verifica si la celda actual está vacía (null).
          rowIsFull = false; // Si hay una celda vacía, la fila no está llena.
          break; // Sale del bucle interno, ya que no es necesario verificar el resto de la fila.
        }
      }
      //step 4:
      if (rowIsFull) {
        //Step 5:
        for (int r = row; r > 0; r--) {
          // copy the above row to the current
          gameBoard[r] = List.from(gameBoard[r - 1]); // Desplaza filas hacia abajo.
        }

        // Step 6:
        gameBoard[0] = List.generate(row, (index) => null); // Limpia la fila superior.

        //step 7: Increase the score
        currentScore++; // Aumenta la puntuación.
      }
    }
  }

  //Game OVER
  bool isGameOver() {
    //check if any columns in the top row are filled
    for (int col = 0; col < rowLength; col++) {
      if (gameBoard[0][col] != null) {
        return true; // Si la fila superior tiene piezas.
      }
    }

    return false; // No hay fin de juego.
  }

  @override
  Widget build(BuildContext context) { // Define el método build, que construye la interfaz de usuario.
    return Scaffold( // Retorna un Scaffold, que es la estructura básica de una pantalla en Flutter.
      backgroundColor: Colors.black, // Establece el color de fondo de la pantalla como negro.
      body: Column( // Usa un Column para organizar los widgets verticalmente.
        children: [
          //GAME GRID
          Expanded( // Expande el widget hijo para ocupar el espacio disponible.
            child: GridView.builder( // Crea un grid dinámico.
              itemCount: rowLength * colLenght, // Define el número total de celdas en el grid (filas * columnas).
              physics: const NeverScrollableScrollPhysics(), // Desactiva el desplazamiento del grid.
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: rowLength), // Configura el grid con un número fijo de columnas (rowLength).
              itemBuilder: (context, index) { // Constructor de cada celda del grid.
                // get row and col of each index
                int row = (index / rowLength).floor(); // Calcula la fila correspondiente al índice actual.
                int col = index % rowLength; // Calcula la columna correspondiente al índice actual.

                // current piece
                if (currentPiece.position.contains(index)) { // Verifica si el índice actual es parte de la posición de la pieza actual.
                  return Pixel( // Retorna un widget Pixel para representar la pieza.
                    color: currentPiece.color, // Establece el color de la pieza.
                    child: index, // Pasa el índice como hijo (puede usarse para depuración o visualización).
                  );
                }

                //landed pieces
                else if (gameBoard[row][col] != null) { // Verifica si la celda actual contiene una pieza aterrizada.
                final Tetromino? tetrominoType = gameBoard[row][col]; // Obtiene el tipo de tetromino en la celda.
                return Pixel( // Retorna un widget Pixel para representar la pieza aterrizada.
                color: tetrominoColors[tetrominoType], // Asigna el color correspondiente al tipo de tetromino.
                child: '', // No muestra ningún texto dentro del Pixel.
                );
                }

                // blank pixel
                else { // Si la celda está vacía.
                return Pixel( // Retorna un widget Pixel para representar una celda vacía.
                 color: Colors.grey[900], // Asigna un color gris oscuro para representar el espacio vacío.
                  child: index, // Muestra el índice dentro del Pixel (puede usarse para depuración o visualización).
                );
                }
              },
            ),
          ),

          //SCORE
          Text('Score: $currentScore', style: TextStyle(color: Colors.white)), // Muestra la puntuación.

          //GAME CONTROLS
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0, top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //left
                IconButton(
                  onPressed: moveLeft,
                  color: Colors.white,
                  icon: Icon(Icons.arrow_back_ios)), // Botón izquierda.

                //rotate
                IconButton(
                  onPressed: rotatePiece,
                  color: Colors.white,
                  icon: Icon(Icons.rotate_right)), // Botón rotar.

                //rigth
                  IconButton(
                  onPressed: moveRight,
                  color: Colors.white,
                  icon: Icon(Icons.arrow_forward_ios)), 
                  
                   IconButton(
                   onPressed: dropPieceFast, // Llama a la función para bajar rápidamente.
                   color: Colors.white,
                   icon: Icon(Icons.arrow_downward)),// Botón derecha.
              ],
            ),
          ),
        ],
      ),
    );
  }
}