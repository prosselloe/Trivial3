
import 'game_models.dart';

/// Representa una única casella en el tauler del joc.
class BoardSquare {
  final CyberCategory category;
  final bool isCyberPointSquare;
  final List<int> connections; // Índexs de les caselles connectades

  const BoardSquare({
    required this.category,
    this.isCyberPointSquare = false,
    this.connections = const [],
  });
}
