import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/screens/home_screen.dart';

class GameScreen extends StatefulWidget {
  String player1;
  String player2;
  GameScreen({super.key, required this.player1, required this.player2});
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<List<String>> _board;
  late String _currPlayer;
  late String _winner;
  late bool _gameOver;

  @override
  void initState() {
    super.initState();
    _currPlayer = "X";
    _winner = "";
    _gameOver = false;
    _board = List.generate(3, (_) => List.generate(3, (_) => ""));
  }

  void _makeComputerMove() {
    if (_gameOver) {
      return;
    }

    // Implement the computer's move here.
    // For simplicity, we'll just make a random move here.
    List<int> emptyCells = [];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_board[i][j] == "") {
          emptyCells.add(i * 3 + j);
        }
      }
    }

    if (emptyCells.isNotEmpty) {
      final randomIndex =
          emptyCells[DateTime.now().millisecondsSinceEpoch % emptyCells.length];
      final row = randomIndex ~/ 3;
      final col = randomIndex % 3;

      // Simulate computer's move after a short delay for a more natural feel
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          _board[row][col] = "O"; // Computer always enters "O"
          _checkForWin(row, col);

          if (_winner != "X" && _winner != "O" && !_gameOver) {
            _currPlayer = "X";
          }
        });
      });
    }
  }

  void makeMove(int row, int col) {
    if (_board[row][col] != "" || _gameOver) {
      return;
    }
    setState(() {
      _board[row][col] = _currPlayer;
      _checkForWin(row, col);

      if (!_gameOver) {
        _currPlayer = "X";
        _makeComputerMove();
      }
    });
  }

  void resetGame() {
    setState(() {
      _currPlayer = "X";
      _winner = "";
      _gameOver = false;
      _board = List.generate(3, (_) => List.generate(3, (_) => ""));
    });
  }

  void _checkForWin(int row, int col) {
    // Check the row
    if (_board[row][0] == _currPlayer &&
        _board[row][1] == _currPlayer &&
        _board[row][2] == _currPlayer) {
      _winner = _currPlayer;
      _gameOver = true;
    }

    // Check the column
    else if (_board[0][col] == _currPlayer &&
        _board[1][col] == _currPlayer &&
        _board[2][col] == _currPlayer) {
      _winner = _currPlayer;
      _gameOver = true;
    }

    // Check diagonals
    else if (row == col &&
        _board[0][0] == _currPlayer &&
        _board[1][1] == _currPlayer &&
        _board[2][2] == _currPlayer) {
      _winner = _currPlayer;
      _gameOver = true;
    } else if (row + col == 2 &&
        _board[0][2] == _currPlayer &&
        _board[1][1] == _currPlayer &&
        _board[2][0] == _currPlayer) {
      _winner = _currPlayer;
      _gameOver = true;
    }

    // Check for a tie
    if (!_board.any((row) => row.any((cell) => cell == "")) && _winner == "") {
      _gameOver = true;
      _winner = "It's a Tie";
    }

    // If there's a winner or it's a tie, show the result
    if (_gameOver) {
      String resultTitle;
      if (_winner == "X") {
        resultTitle = widget.player1 + " Won";
      } else if (_winner == "O") {
        if (_currPlayer == "X") {
          resultTitle = "Computer Won";
        } else {
          resultTitle = widget.player2 + " Won";
        }
      } else {
        resultTitle = "It's a Tie";
      }

      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        btnOkText: "Play Again!",
        title: resultTitle,
        btnOkOnPress: () {
          resetGame();
        },
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 48, 61, 68),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 80,
              ),
              SizedBox(
                  height: 120,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Turn: ",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            _currPlayer == "X"
                                ? "${widget.player1} ($_currPlayer)"
                                : "Computer",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color:
                                  _currPlayer == "X" ? Colors.red : Colors.blue,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 121, 137, 145),
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(5),
                child: GridView.builder(
                    itemCount: 9,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                    itemBuilder: (context, index) {
                      int row = index ~/ 3;
                      int col = index % 3;
                      return GestureDetector(
                        onTap: () => makeMove(row, col),
                        child: Container(
                          margin: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              _board[row][col],
                              style: TextStyle(
                                  fontSize: 120,
                                  fontWeight: FontWeight.bold,
                                  color: _board[row][col] == "X"
                                      ? Colors.red
                                      : Colors.blue),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => resetGame(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 2),
                      child: const Text(
                        "Reset Game",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
