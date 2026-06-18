
import 'dart:math';
import 'package:flutter/material.dart';
import 'board_square.dart';

enum CyberCategory {
  passwordManagement,
  onlineShopping,
  socialMedia,
  deviceProtection,
  safeBrowsing,
  onlineFraud,
}

class Question {
  final String text;
  final CyberCategory category;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;

  const Question({
    required this.text,
    required this.category,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
  });
}

class Player {
  final String name;
  int position;
  final List<CyberCategory> earnedCyberPoints;

  Player({
    required this.name,
    this.position = 0,
    List<CyberCategory>? earnedCyberPoints,
  }) : earnedCyberPoints = earnedCyberPoints ?? [];
}

class GameBoard {
  final List<Player> players;
  final List<BoardSquare> squares;
  int currentPlayerIndex;

  GameBoard({
    required this.players,
    required this.squares,
    this.currentPlayerIndex = 0,
  });

  Player get currentPlayer => players[currentPlayerIndex];

  BoardSquare get currentSquare => squares[currentPlayer.position];

  void nextTurn() {
    currentPlayerIndex = (currentPlayerIndex + 1) % players.length;
  }

  void movePlayer(int destination) {
    currentPlayer.position = destination;
  }

  List<int> getPossibleMoves(int roll) {
    if (roll <= 0) return [];

    Set<int> visited = {currentPlayer.position};
    List<int> currentLevel = [currentPlayer.position];

    for (int i = 0; i < roll; i++) {
      List<int> nextLevel = [];
      for (int pos in currentLevel) {
        for (int connection in squares[pos].connections) {
          if (!visited.contains(connection)) {
            visited.add(connection);
            nextLevel.add(connection);
          }
        }
      }
      currentLevel = nextLevel;
    }
    return currentLevel;
  }

  Color getColorForCategory(CyberCategory category) {
    switch (category) {
      case CyberCategory.passwordManagement:
        return Colors.blue;
      case CyberCategory.onlineShopping:
        return Colors.red;
      case CyberCategory.socialMedia:
        return Colors.green;
      case CyberCategory.deviceProtection:
        return Colors.orange;
      case CyberCategory.safeBrowsing:
        return Colors.purple;
      case CyberCategory.onlineFraud:
        return Colors.yellow;
    }
  }

  static GameBoard createStandardBoard(List<Player> players) {
    const int squaresInOuterRing = 24;
    const int squaresPerArm = 3;
    const int numArms = 6;
    const int totalSquares = 1 + squaresInOuterRing + (squaresPerArm * numArms);
    final random = Random();

    // 1. Definim les connexions del graf
    List<List<int>> connections = List.generate(totalSquares, (_) => []);
    for (int i = 0; i < squaresInOuterRing; i++) {
      final currentIndex = i + 1;
      final nextIndex = ((i + 1) % squaresInOuterRing) + 1;
      connections[currentIndex].add(nextIndex);
      connections[nextIndex].add(currentIndex);
    }
    for (int i = 0; i < numArms; i++) {
      final ringConnectionIndex = i * (squaresInOuterRing ~/ numArms) + 1;
      int previousArmIndex = ringConnectionIndex;
      for (int j = 0; j < squaresPerArm; j++) {
        final armSquareIndex = 1 + squaresInOuterRing + (i * squaresPerArm) + j;
        connections[previousArmIndex].add(armSquareIndex);
        connections[armSquareIndex].add(previousArmIndex);
        previousArmIndex = armSquareIndex;
      }
      connections[previousArmIndex].add(0);
      connections[0].add(previousArmIndex);
    }

    final allCategories = CyberCategory.values.toList();
    final List<BoardSquare?> tempSquares = List.filled(totalSquares, null);

    // 2. Assignem Ciberpunts primer amb categories úniques
    final cyberPointIndices = List.generate(numArms, (i) => i * (squaresInOuterRing ~/ numArms) + 1);
    final cyberPointCategories = List<CyberCategory>.from(allCategories)..shuffle(random);
    
    for (int i = 0; i < cyberPointIndices.length; i++) {
      final index = cyberPointIndices[i];
      tempSquares[index] = BoardSquare(
        category: cyberPointCategories[i],
        isCyberPointSquare: true,
        connections: connections[index],
      );
    }
    
    // 3. Assignem la resta de caselles, assegurant que no hi ha adjacents amb la mateixa categoria
    for (int i = 0; i < totalSquares; i++) {
      if (tempSquares[i] != null) continue; // Ja està assignat (Ciberpunt o un altre ja processat)

      // Obtenim les categories dels veïns
      final neighborCategories = connections[i]
          .map((neighborIndex) => tempSquares[neighborIndex]?.category)
          .where((category) => category != null)
          .cast<CyberCategory>()
          .toSet();

      // Trobem les categories permeses
      final allowedCategories = allCategories
          .where((c) => !neighborCategories.contains(c))
          .toList();
      
      CyberCategory category;
      if (allowedCategories.isEmpty) {
        // Fallback: si totes les categories estan bloquejades, triem una aleatòria
        category = allCategories[random.nextInt(allCategories.length)];
      } else {
        // Triem una categoria aleatòria de les permeses
        category = allowedCategories[random.nextInt(allowedCategories.length)];
      }
      
      tempSquares[i] = BoardSquare(
        category: category,
        isCyberPointSquare: false, // No pot ser un ciberpunt
        connections: connections[i],
      );
    }

    // 4. Construeix la llista final (no-nul·la)
    final List<BoardSquare> finalSquares = tempSquares.map((s) => s!).toList();

    return GameBoard(players: players, squares: finalSquares);
  }
}
