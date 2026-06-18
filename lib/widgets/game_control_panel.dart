import 'package:flutter/material.dart';
import '../models/game_models.dart';

class GameControlPanel extends StatelessWidget {
  final GameBoard gameBoard;
  final int? lastDiceRoll;
  final VoidCallback onRollDice;
  final bool isDiceEnabled; // Nou paràmetre

  const GameControlPanel({
    super.key,
    required this.gameBoard,
    this.lastDiceRoll,
    required this.onRollDice,
    this.isDiceEnabled = true, // Valor per defecte
  });

  @override
  Widget build(BuildContext context) {
    final player = gameBoard.currentPlayer;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Torn de:', style: Theme.of(context).textTheme.titleLarge),
              Text(player.name, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              if (lastDiceRoll != null && isDiceEnabled) // Mostra el dau només si no s'està triant
                Text(
                  'Dau: $lastDiceRoll',
                   style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              // Canvia el color si està desactivat
              backgroundColor: isDiceEnabled ? null : Colors.grey.shade700,
            ),
            // Desactiva el botó si no està habilitat
            onPressed: isDiceEnabled ? onRollDice : null,
            child: Text(
              isDiceEnabled ? 'Llençar Dau' : 'Tria una casella', 
              style: const TextStyle(fontSize: 18)
            ),
          ),
           Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text('Ciberpunts:', style: Theme.of(context).textTheme.titleLarge),
               Wrap(
                 spacing: 4.0,
                 runSpacing: 4.0,
                 children: CyberCategory.values.map((category) {
                   final hasPoint = player.earnedCyberPoints.contains(category);
                   return Icon(
                     hasPoint ? Icons.check_circle : Icons.radio_button_unchecked,
                     color: gameBoard.getColorForCategory(category),
                     size: 28,
                   );
                 }).toList(),
               )
            ],
           ),
        ],
      ),
    );
  }
}
