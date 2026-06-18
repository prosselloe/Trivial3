
import 'package:flutter/material.dart';
import 'dart:math';

import '../models/game_models.dart';
import '../data/questions.dart';
import '../widgets/game_board_widget.dart';
import '../widgets/game_control_panel.dart';

class GameScreen extends StatefulWidget {
  final List<String> playerNames;
  const GameScreen({super.key, required this.playerNames});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameBoard _gameBoard;
  late List<Question> _questions;
  int? _lastDiceRoll;
  List<int> _possibleMoves = [];

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    final players = widget.playerNames.map((name) => Player(name: name)).toList();
    _gameBoard = GameBoard.createStandardBoard(players);
    _questions = List<Question>.from(trivialQuestions)..shuffle();
  }

  Future<void> _rollDice() async {
    if (!mounted || _possibleMoves.isNotEmpty) return;

    // 1. Mostra el resultat del dau
    setState(() {
      _lastDiceRoll = Random().nextInt(6) + 1;
      _possibleMoves = []; // Assegura que no hi ha moviments possibles seleccionables
    });

    // 2. Espera un moment
    await Future.delayed(const Duration(milliseconds: 1000));

    if (!mounted) return;

    // 3. Calcula i mostra les caselles possibles
    setState(() {
      _possibleMoves = _gameBoard.getPossibleMoves(_lastDiceRoll!);
    });
  }

  void _onSquareSelected(int newPosition) {
    if (_possibleMoves.contains(newPosition)) {
      setState(() {
        _gameBoard.movePlayer(newPosition);
        _possibleMoves = [];
        _lastDiceRoll = null; // Neteja el dau després de moure
      });

      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          _showQuestionDialog();
        }
      });
    }
  }

  Question _getQuestionForCategory(CyberCategory category) {
    final question = _questions.firstWhere(
      (q) => q.category == category,
      orElse: () {
        _questions = List<Question>.from(trivialQuestions)..shuffle();
        return _questions.firstWhere((q) => q.category == category);
      },
    );
    _questions.remove(question);
    return question;
  }

  void _showQuestionDialog() {
    if (_gameBoard.currentPlayer.position == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Casella central! Llença el dau per sortir.'), backgroundColor: Colors.blueAccent),
        );
        _lastDiceRoll = null;
        return;
    }

    final currentSquare = _gameBoard.currentSquare;
    final question = _getQuestionForCategory(currentSquare.category);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          'Categoria: ${question.category.name}',
          style: TextStyle(
            color: _gameBoard.getColorForCategory(question.category),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question.text, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            ...List.generate(question.options.length, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    backgroundColor: WidgetStateColor.resolveWith((states) => Colors.grey.shade800),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _handleAnswer(index == question.correctOptionIndex, question.explanation);
                  },
                  child: Text(question.options[index], textAlign: TextAlign.center),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _handleAnswer(bool isCorrect, String explanation) {
    if (!mounted) return;

    final player = _gameBoard.currentPlayer;
    final square = _gameBoard.currentSquare;

     ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Explicació: $explanation"),
          duration: const Duration(seconds: 5),
        ),
      );

    if (isCorrect) {
      if (square.isCyberPointSquare && !player.earnedCyberPoints.contains(square.category)) {
        setState(() {
          player.earnedCyberPoints.add(square.category);
        });
      }
      
      if (player.earnedCyberPoints.length == CyberCategory.values.length) {
        _showEndGameDialog(player);
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Correcte! Pots tornar a llençar.'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      setState(() {
        _gameBoard.nextTurn();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Incorrecte! Torn del següent jugador.'),
          backgroundColor: Colors.red,
        ),
      );
    }
    
    setState(() {
        _lastDiceRoll = null;
    });
  }

 void _showEndGameDialog(Player winner) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Fi de la Partida!'),
        content: Text('${winner.name} ha guanyat la partida! Ha aconseguit tots els Ciberpunts.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(); 
              Navigator.of(context).pop();
            },
            child: const Text('Nova Partida'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trivial de la Ciberseguretat'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: GameBoardWidget(
              gameBoard: _gameBoard,
              possibleMoves: _possibleMoves,
              onSquareSelected: _onSquareSelected,
            ),
          ),
          const Divider(),
          Expanded(
            flex: 1,
            child: GameControlPanel(
              gameBoard: _gameBoard,
              lastDiceRoll: _lastDiceRoll,
              onRollDice: _rollDice,
              isDiceEnabled: _possibleMoves.isEmpty, 
            ),
          ),
        ],
      ),
    );
  }
}
