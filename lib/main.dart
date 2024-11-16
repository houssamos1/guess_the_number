import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(GuessTheNumberApp());
}

class GuessTheNumberApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Devinez le Nombre',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontSize: 18.0, color: Colors.black87),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.indigo, // Couleur du texte du bouton
            textStyle: TextStyle(fontSize: 16),
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Devinez le Nombre'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GameScreen()),
            );
          },
          child: Text('Commencer une nouvelle partie'),
        ),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final TextEditingController _controller = TextEditingController();
  int _randomNumber = 0;
  int _attempts = 0;
  String _feedback = '';

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    _randomNumber = Random().nextInt(100) + 1;
    _attempts = 0;
    _feedback = '';
    _controller.clear();
    setState(() {});
  }

  void _checkGuess() {
    final guess = int.tryParse(_controller.text);
    if (guess == null) return;

    setState(() {
      _attempts++;
      if (guess < _randomNumber) {
        _feedback = 'Trop bas !';
      } else if (guess > _randomNumber) {
        _feedback = 'Trop haut !';
      } else {
        _feedback = 'Bravo ! Vous avez trouvé en $_attempts tentatives.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Partie en cours'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Essayez de deviner le nombre entre 1 et 100',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Entrez votre nombre',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkGuess,
              child: Text('Vérifier'),
            ),
            SizedBox(height: 20),
            Text(
              _feedback,
              style: TextStyle(fontSize: 24, color: Colors.indigo),
            ),
            SizedBox(height: 40),
            if (_feedback.contains('Bravo'))
              ElevatedButton(
                onPressed: _startNewGame,
                child: Text('Nouvelle partie'),
              ),
          ],
        ),
      ),
    );
  }
}
