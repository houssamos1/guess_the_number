import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(GuessTheNumberApp());
}

class GuessTheNumberApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Devinez le Nombre',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

// Classe pour gérer les scores
class ScoreManager {
  static List<int> scores = [];

  // Ajoute un score à la liste et trie pour garder les meilleurs
  static void addScore(int score) {
    scores.add(score);
    scores.sort();
    if (scores.length > 10) {
      scores = scores.sublist(0, 10); // Garder les 10 meilleurs scores
    }
  }

  // Retourne les 10 meilleurs scores
  static List<int> getTopScores() {
    return scores;
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF003366), // Fond bleu roi
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Titre du jeu
            Text(
              'Devinez le Nombre',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                decoration: TextDecoration.underline,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            // Slogan
            Text(
              'Choisissez votre niveau et montrez vos talents!',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            // Bandeau avec icônes et 10 meilleurs scores
            Container(
              color: Colors.white30,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.yellow, size: 30),
                  Text(
                    'Top 10 Scores',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Icon(Icons.star, color: Colors.yellow, size: 30),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Bouton de démarrage
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LevelSelectionPage()),
                );
              },
              child: Text(
                'Commencer',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LevelSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF003366), // Fond bleu roi
      appBar: AppBar(
        title: Text('Choisissez le Niveau'),
        backgroundColor: Colors.blue,
        actions: [
          // Icône d'information en haut à droite
          IconButton(
            icon: Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {
              _showLevelDescription(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Boutons de niveaux
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GamePage(maxNumber: 10),
                  ),
                );
              },
              child: Text('Facile (1-10)', style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GamePage(maxNumber: 50),
                  ),
                );
              },
              child: Text('Moyen (1-50)', style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GamePage(maxNumber: 100),
                  ),
                );
              },
              child: Text('Difficile (1-100)', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  void _showLevelDescription(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Description du Niveau'),
          content: Text('Choisissez un niveau de difficulté:\n1-10: Facile\n1-50: Moyen\n1-100: Difficile'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fermer'),
            ),
          ],
        );
      },
    );
  }
}

class GamePage extends StatefulWidget {
  final int maxNumber;
  GamePage({required this.maxNumber});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final TextEditingController _controller = TextEditingController();
  late int _randomNumber;
  late int _highScore;
  String _feedbackMessage = '';
  int _attempts = 0;
  late DateTime _startTime;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _generateNewNumber();
    _highScore = 9999;
  }

  // Fonction pour générer un nombre aléatoire en fonction du niveau
  void _generateNewNumber() {
    setState(() {
      _randomNumber = Random().nextInt(widget.maxNumber) + 1;
      _feedbackMessage = '';
      _errorMessage = '';
      _attempts = 0;
      _startTime = DateTime.now();
    });
  }

  void _checkGuess() {
    setState(() {
      int guess = int.tryParse(_controller.text) ?? 0;

      // Vérification si la valeur est supérieure au niveau
      if (guess > widget.maxNumber) {
        _errorMessage = 'Erreur : Entrez un nombre inférieur ou égal à ${widget.maxNumber}';
        return;
      }

      _attempts++;

      if (guess < _randomNumber) {
        _feedbackMessage = '🔽'; // Plus grand
      } else if (guess > _randomNumber) {
        _feedbackMessage = '🔼'; // Plus petit
      } else {
        _feedbackMessage = '🎉'; // Correct
        Duration elapsedTime = DateTime.now().difference(_startTime);
        int score = elapsedTime.inSeconds;

        if (score < _highScore) {
          _highScore = score;
        }

        // Ajoute le score au classement et affiche le message de fin
        ScoreManager.addScore(score);
        _showGameOverDialog(context, score);
      }
      _controller.clear();
    });
  }

  void _showGameOverDialog(BuildContext context, int score) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Jeu terminé'),
          content: Text('Félicitations! Vous avez gagné en $score secondes.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FinalRankingPage(score: score),
                  ),
                );
              },
              child: Text('Voir le classement'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF003366),
      appBar: AppBar(
        title: Text('Devinez le Nombre'),
        backgroundColor: Colors.blue,
        actions: [
          // Icône d'information en haut à droite
          IconButton(
            icon: Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {
              _showLevelDescription(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Message d'erreur
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              ),
            // Affichage du meilleur score
            Text(
              'Meilleur score: ${_highScore}s',
              style: TextStyle(fontSize: 20, color: Colors.white70),
            ),
            SizedBox(height: 20),
            // Instruction avec emoji
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.help_outline, color: Colors.white, size: 30),
                SizedBox(width: 10),
                Text(
                  'Entrez un nombre entre 1 et ${widget.maxNumber}:',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Champ de saisie
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 20, color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: 'Votre devinette',
                hintStyle: TextStyle(color: Colors.black54),
              ),
            ),
            SizedBox(height: 30),
            // Bouton vérifier
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              ),
              onPressed: _checkGuess,
              child: Text(
                'Vérifier',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Feedback avec emoji
            Text(
              _feedbackMessage,
              style: TextStyle(
                fontSize: 50,
                color: Colors.orangeAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLevelDescription(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Description du Niveau'),
          content: Text('Choisissez un niveau de difficulté:\n1-10: Facile\n1-50: Moyen\n1-100: Difficile'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fermer'),
            ),
          ],
        );
      },
    );
  }
}

class FinalRankingPage extends StatelessWidget {
  final int score;

  FinalRankingPage({required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF003366),
      appBar: AppBar(
        title: Text('Classement Final'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Votre Score: $score secondes',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            SizedBox(height: 20),
            // Affichage des meilleurs scores dynamiques
            Text(
              'Top 10 des scores :',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            SizedBox(height: 10),
            // Liste des scores
            ...ScoreManager.getTopScores().asMap().entries.map((entry) {
              int rank = entry.key + 1;
              int score = entry.value;
              return Text(
                '$rank. $score secondes',
                style: TextStyle(fontSize: 18, color: Colors.white70),
              );
            }).toList(),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: Text('Retour à l\'accueil'),
            ),
          ],
        ),
      ),
    );
  }
}
