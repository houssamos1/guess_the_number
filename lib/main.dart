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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Description des niveaux avec pop-up
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
              ),
              onPressed: () {
                _showLevelDescription(context);
              },
              child: Text('Description du Niveau'),
            ),
            SizedBox(height: 20),
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
  late Stopwatch _stopwatch;

  @override
  void initState() {
    super.initState();
    _randomNumber = Random().nextInt(widget.maxNumber) + 1;
    _highScore = 9999;
    _stopwatch = Stopwatch();
    _stopwatch.start();
  }

  void _checkGuess() {
    setState(() {
      int guess = int.tryParse(_controller.text) ?? 0;

      // Vérification si la valeur est supérieure au niveau
      if (guess > widget.maxNumber) {
        _showInputErrorDialog(context);
        return;
      }

      _attempts++;

      if (guess < _randomNumber) {
        _feedbackMessage = '🔽'; // Plus grand
      } else if (guess > _randomNumber) {
        _feedbackMessage = '🔼'; // Plus petit
      } else {
        _feedbackMessage = '🎉'; // Correct
        _stopwatch.stop();
        int score = _stopwatch.elapsed.inSeconds;
        if (score < _highScore) {
          _highScore = score;
        }
        // Redirection vers la page de classement
        _showGameOverDialog(context, score);
      }
      _controller.clear();
    });
  }

  void _showInputErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erreur de saisie'),
          content: Text('Veuillez entrer un nombre inférieur ou égal à ${widget.maxNumber}.'),
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
                  MaterialPageRoute(builder: (context) => FinalRankingPage(score: score)),
                );
              },
              child: Text('Voir le classement'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: Text('Retour à l\'accueil'),
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            // Affichage du meilleur score et timer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '🏆 ${_highScore == 9999 ? "--" : "${_highScore}s"}',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  '⏱ ${_stopwatch.elapsed.inSeconds}s',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            // Instruction avec emoji
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Entrez un nombre entre 1 et ${widget.maxNumber}:',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 10),
                Icon(Icons.help_outline, color: Colors.white, size: 30),
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
            // Affichage des meilleurs scores (fictifs ici)
            Text(
              'Top 10 des scores :\n1. 10s\n2. 12s\n3. 15s\n4. 20s\n5. 22s\n6. 30s\n7. 35s\n8. 40s\n9. 45s\n10. 50s',
              style: TextStyle(fontSize: 18, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
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
