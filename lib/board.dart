import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tetris_game/pixel.dart';
import 'package:tetris_game/values.dart';
import 'piece.dart';

/* 

GAME BOARD

This is a 2x2 grid with null representing an empty space
a non empty space will have the color to represent the landed pieces

*/

//create game board
List <List<Tetromino?>> gameBoard = List.generate(
  colLenght,
   (i) => List.generate(
    rowLength,
    (j) => null,
   ),
   );  

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {

  // current tetris piece
  Piece currentPiece = Piece(type: Tetromino.L);

  //current score
  int currentScore = 0;

  //GAME OVER status
  bool gameOver = false;

  @override
  void initState() {
    super.initState();

    // start game when app starts
    startGame();
  }

  void startGame(){
    currentPiece.initializePiece();

    //frame refresh rate
    Duration frameRate = const Duration(milliseconds: 600);
    gameLoop(frameRate);
  }

  //game loop
  void gameLoop(Duration frameRate) {
    Timer.periodic(
      frameRate,
      (timer){
        setState(() {

          //Clear lines
          clearLines();

          //check landing
          checkLanding();

          // check if game is over
          if(gameOver == true){
            timer.cancel();
            showGameOverDialog();
          }

          //move current pice down
          currentPiece.movePiece(Direction.down);
        });
      }
    );
  }

  //GAME OVER MESSAGE
  void showGameOverDialog(){
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Text('Game Over'),
      content: Text("Your Score is: $currentScore"),
      actions: [
        TextButton(onPressed: (){
          //Reset the game
          resetGame();

          Navigator.pop(context);
        }, 
        child: Text('Play Again'))
      ],
    ),
  );
}

  //Reset
  void resetGame(){
    //clear
    gameBoard = List.generate(
      colLenght,
      (i) => List.generate(
        rowLength,
        (j) => null,
      ),
    );
    //new game
    gameOver = false;
    currentScore = 0;

    //create new piece
    createNewPiece();

    //start gamer again
    startGame();
  }


  //check for collision in a future position
  //return true -> there is a collision
  //return false -> there is no collision
  bool checkCollision(Direction direction) {
  //loop through each position of the current piece
  for (int i = 0; i < currentPiece.position.length; i++) {
    //calculate the row and column of the current position
    int row = (currentPiece.position[i] / rowLength).floor();
    int col = currentPiece.position[i] % rowLength;

    //adjust the row and col based on the direction
    if (direction == Direction.left) {
      col -= 1;
    } else if (direction == Direction.right) {
      col += 1;
    } else if (direction == Direction.down) {
      row += 1;
    }

    // check if the piece is out of bounds (either too low or too far to the left or right)
    if (row >= colLenght || col < 0 || col >= rowLength) {
      return true;
    }

    // check if the position is already occupied in the gameBoard
    if (row >= 0 && col >= 0 && gameBoard[row][col] != null) {
      return true;
    }
  }

  // if no collisions are detected, return false
  return false;
}

  void checkLanding(){
    //if going down is occupied
    if(checkCollision(Direction.down)){
      //mark position as occupied on the gameboard
      for (int i=0; i < currentPiece.position.length; i++){
        int row = (currentPiece.position[i] / rowLength).floor();
        int col = currentPiece.position[i] % rowLength;
        if (row>=0 && col>=0){
          gameBoard[row][col] = currentPiece.type;
        }
      }

      //once landed, create the next piece\
    createNewPiece();
    }
  }

  void createNewPiece(){
    // create a random object to generate random tetromino types
    Random rand = Random();

    //create a new piece with random type
    Tetromino randomType =
      Tetromino.values[rand.nextInt(Tetromino.values.length)];
      currentPiece = Piece(type: randomType);
      currentPiece.initializePiece();

      /* 
      
      
      
      */
      if(isGameOver()){
        gameOver = true;
      }
  }

  //move left
  void moveLeft(){
    //make sure the move is valid before moving there
    if (!checkCollision(Direction.left)){
      setState(() {
        currentPiece.movePiece(Direction.left);
      });
    }
  }
  //move right
  void moveRight(){
     //make sure the move is valid before moving there
    if (!checkCollision(Direction.right)){
      setState(() {
        currentPiece.movePiece(Direction.right);
      });
    }
  }
  //rotate piece
  void rotatePiece(){
    setState(() {
      currentPiece.rotatePiece();
    });
  }

  // clear lines
    void clearLines(){
      // step 1: loop thwroug each row of the game board from bottom to top
      for (int row = colLenght - 1; row >= 0; row--){
        //step 2: inicialize a variable to tack if the row is full
        bool rowIsFull = true;

        // step 3
        for (int col = 0 ; col < rowLength; col++){
            //if there is an empty
            if (gameBoard[row][col] == null){
               rowIsFull = false;
               break;
            }
          }

          //step 4: 
          if (rowIsFull){
            //Step 5:
            for(int r = row; r > 0; r--){
              // copy the above row to thhe current
              gameBoard[r] = List.from(gameBoard[r - 1]);
            }

            // Step 6:
            gameBoard[0] = List.generate(row, (index) => null);

            //step 7: Increase the score
            currentScore++;

          }
      }
    }

    //Game OVER
    bool isGameOver(){
      //check if any columns in the top row are filled
      for (int col = 0 ; col < rowLength; col++){
        if (gameBoard[0][col] != null){
          return true;
        }
      }

      return false;
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.black,
       body: Column(
         children: [


          //GAME GRID 
           Expanded(
             child: GridView.builder( 
              itemCount: rowLength * colLenght,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: rowLength), 
             itemBuilder: (context, index) {
              
              // get row and col of each index
              int row = (index / rowLength).floor();
              int col = index % rowLength;
             
              // current piece
              if(currentPiece.position.contains(index)){
                return Pixel(
                color: currentPiece.color, 
                child: index,
                );
              } 
             
              //landed pieces
              else if (gameBoard[row][col] != null){
                final Tetromino? tetrominoType = gameBoard[row][col];
                return Pixel(color: tetrominoColors[tetrominoType], child: '');
              }
              // blank pixel
              else{
                return Pixel(
                color: Colors.grey[900], 
                child: index,
                );
              }
              },
             ),
           ),

          //SCORE
          Text('Score: $currentScore', style: TextStyle(color: Colors.white),),

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
                  icon: Icon( Icons.arrow_back_ios)
                  ),
              //rotate
                IconButton(
                  onPressed: rotatePiece, 
                  color: Colors.white,
                  icon: Icon( Icons.rotate_right)
                  ),
              //rigth
                IconButton(
                  onPressed: moveRight, 
                  color: Colors.white,
                  icon: Icon( Icons.arrow_forward_ios)
                  ),
              ],
             ),
           )
         ],
       ),
    );
  }
}