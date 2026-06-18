import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/screens/game_screen.dart';
import 'package:myapp/main.dart'; // Importa el ThemeProvider

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _playerControllers = [
    TextEditingController(text: 'Jugador 1'),
    TextEditingController(text: 'Jugador 2'),
  ];

  @override
  void dispose() {
    for (var controller in _playerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addPlayer() {
    if (_playerControllers.length < 4) {
      setState(() {
        _playerControllers.add(TextEditingController(text: 'Jugador ${_playerControllers.length + 1}'));
      });
    }
  }

  void _removePlayer(int index) {
    if (_playerControllers.length > 2) {
      setState(() {
        _playerControllers.removeAt(index).dispose();
      });
    }
  }

  void _startGame() {
    final playerNames = _playerControllers.map((c) => c.text.trim()).where((name) => name.isNotEmpty).toList();
    if (playerNames.length < 2) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Es necessiten almenys 2 jugadors amb nom.')),
        );
        return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GameScreen(playerNames: playerNames),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trivial de la Ciberseguretat'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Configuració de la Partida',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ..._playerControllers.asMap().entries.map((entry) {
              int index = entry.key;
              TextEditingController controller = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          labelText: 'Nom del Jugador ${index + 1}',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                        ),
                      ),
                    ),
                    if (_playerControllers.length > 2)
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                        onPressed: () => _removePlayer(index),
                      ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),
            if (_playerControllers.length < 4)
              TextButton.icon(
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Afegir Jugador'),
                onPressed: _addPlayer,
              ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onPressed: _startGame,
              child: const Text('Començar Joc'),
            ),
          ],
        ),
      ),
    );
  }
}
