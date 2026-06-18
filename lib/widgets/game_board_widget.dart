
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/game_models.dart';

class GameBoardWidget extends StatelessWidget {
  final GameBoard gameBoard;
  final List<int> possibleMoves;
  final Function(int) onSquareSelected;

  // Constants per a la geometria del tauler
  static const int _squaresInOuterRing = 24;
  static const int _squaresPerArm = 3;
  static const int _numArms = 6;

  const GameBoardWidget({
    super.key,
    required this.gameBoard,
    this.possibleMoves = const [],
    required this.onSquareSelected,
  });

  IconData _getIconForCategory(CyberCategory category) {
    switch (category) {
      case CyberCategory.passwordManagement: return Icons.vpn_key;
      case CyberCategory.onlineShopping: return Icons.shopping_cart;
      case CyberCategory.socialMedia: return Icons.group;
      case CyberCategory.deviceProtection: return Icons.security;
      case CyberCategory.safeBrowsing: return Icons.shield;
      case CyberCategory.onlineFraud: return Icons.report_problem;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final center = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
        final outerRadius = min(constraints.maxWidth, constraints.maxHeight) * 0.45;
        final squareSize = min(constraints.maxWidth, constraints.maxHeight) * 0.08;

        return Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: _GameBoardPainter(center: center, radius: outerRadius),
            ),
            ...List.generate(gameBoard.squares.length, (index) {
              final position = _getSquarePosition(index, center, outerRadius);
              return Positioned(
                left: position.dx - squareSize / 2,
                top: position.dy - squareSize / 2,
                child: _buildSquare(context, index, squareSize),
              );
            }),
          ],
        );
      },
    );
  }

  Offset _getSquarePosition(int index, Offset center, double radius) {
    if (index == 0) return center; // Casella central

    if (index >= 1 && index <= _squaresInOuterRing) { // Anell exterior
      final angle = (index - 1) * (360 / _squaresInOuterRing) * (pi / 180) - (pi / 2);
      return Offset(center.dx + cos(angle) * radius, center.dy + sin(angle) * radius);
    }
    
    // Branques de connexió
    final armIndex = (index - _squaresInOuterRing - 1) ~/ _squaresPerArm;
    final stepInArm = (index - _squaresInOuterRing - 1) % _squaresPerArm;
    
    final angle = armIndex * (360 / _numArms) * (pi / 180) - (pi / 2);
    final distance = radius - (radius / (_squaresPerArm + 1)) * (stepInArm + 1);

    return Offset(center.dx + cos(angle) * distance, center.dy + sin(angle) * distance);
  }

  Widget _buildSquare(BuildContext context, int index, double size) {
    final square = gameBoard.squares[index];
    final color = index == 0 ? Colors.grey.shade800 : gameBoard.getColorForCategory(square.category);
    final playersOnSquare = gameBoard.players.where((p) => p.position == index).toList();
    final isPossible = possibleMoves.contains(index);

    return GestureDetector(
      onTap: () => onSquareSelected(index),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isPossible ? Colors.white : (square.isCyberPointSquare ? Colors.yellow.shade600 : Colors.black.withAlpha((255 * 0.5).round())),
            width: isPossible ? 3 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isPossible ? Colors.white.withAlpha((255 * 0.9).round()) : Colors.black.withAlpha((255 * 0.6).round()),
              spreadRadius: isPossible ? size * 0.15 : 2,
              blurRadius: isPossible ? size * 0.2 : 4,
            )
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (square.isCyberPointSquare)
              Icon(_getIconForCategory(square.category), color: Colors.white.withAlpha((255 * 0.5).round()), size: size * 0.6),
            if (playersOnSquare.isNotEmpty)
              _buildPlayerTokens(playersOnSquare, context, size * 0.8),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerTokens(List<Player> players, BuildContext context, double size) {
     final playerColors = [Colors.red.shade700, Colors.blue.shade700, Colors.green.shade700, Colors.yellow.shade800];
    
    if (players.length == 1) {
      final playerIndex = gameBoard.players.indexOf(players.first);
      return Container(
        width: size * 0.7,
        height: size * 0.7,
        decoration: BoxDecoration(
          color: playerColors[playerIndex % playerColors.length],
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1.5),
        ),
      );
    } else {
      return Wrap(
        alignment: WrapAlignment.center,
        spacing: 2,
        runSpacing: 2,
        children: players.map((player) {
          final playerIndex = gameBoard.players.indexOf(player);
          return Container(
            width: size * 0.4,
            height: size * 0.4,
            decoration: BoxDecoration(
              color: playerColors[playerIndex % playerColors.length],
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1),
            ),
          );
        }).toList(),
      );
    }
  }
}

class _GameBoardPainter extends CustomPainter {
  final Offset center;
  final double radius;
  static const int _numArms = 6;
  static const int _squaresPerArm = 3;


  _GameBoardPainter({required this.center, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade700
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    // Dibuixa les 6 branques
    for (int i = 0; i < _numArms; i++) {
      final angle = i * (360 / _numArms) * (pi / 180) - (pi / 2);
      final startPoint = Offset(
        center.dx + cos(angle) * (radius / (_squaresPerArm + 1)),
        center.dy + sin(angle) * (radius / (_squaresPerArm + 1)),
      );
      final endPoint = Offset(
        center.dx + cos(angle) * radius,
        center.dy + sin(angle) * radius,
      );
      canvas.drawLine(startPoint, endPoint, paint);
    }

    // Dibuixa l'anell exterior
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
