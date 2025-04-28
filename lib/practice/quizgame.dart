import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flip Card Quiz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const QuizPage(),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with SingleTickerProviderStateMixin {
  // Sample quiz questions
  final List<Map<String, String>> quizQuestions = [
    {'question': 'What is the capital of France?', 'answer': 'Paris'},
    {'question': 'Which planet is known as the Red Planet?', 'answer': 'Mars'},
    {'question': 'What is the largest mammal?', 'answer': 'Blue Whale'},
    {'question': 'Who wrote "Romeo and Juliet"?', 'answer': 'William Shakespeare'},
    {'question': 'What is the chemical symbol for gold?', 'answer': 'Au'},
    {'question': 'Which country is home to the kangaroo?', 'answer': 'Australia'},
    {'question': 'What is the tallest mountain in the world?', 'answer': 'Mount Everest'},
    {'question': 'How many continents are there?', 'answer': 'Seven'},
    {'question': 'What is the largest organ in the human body?', 'answer': 'Skin'},
    {'question': 'Who painted the Mona Lisa?', 'answer': 'Leonardo da Vinci'},
    {'question': 'What is the hardest natural substance?', 'answer': 'Diamond'},
    {'question': 'Which element has the chemical symbol "O"?', 'answer': 'Oxygen'},
    {'question': 'What is the smallest prime number?', 'answer': '2'},
    {'question': 'Which country is known as the Land of the Rising Sun?', 'answer': 'Japan'},
    {'question': 'What is the main ingredient in guacamole?', 'answer': 'Avocado'},
  ];

  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  bool _isCardFlipped = false;
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  int _incorrectAnswers = 0;
  bool _isQuizComplete = false;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();

    // Shuffle questions for randomness
    quizQuestions.shuffle();

    // Initialize flip animation controller
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // Create flip animation
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_isAnimating) return;

    setState(() {
      _isAnimating = true;
    });

    if (_isCardFlipped) {
      _flipController.reverse().then((_) {
        setState(() {
          _isCardFlipped = false;
          _isAnimating = false;
        });
      });
    } else {
      _flipController.forward().then((_) {
        setState(() {
          _isCardFlipped = true;
          _isAnimating = false;
        });
      });
    }
  }

  void _handleAnswer(bool isCorrect) {
    if (_isAnimating || !_isCardFlipped) return;

    setState(() {
      _isAnimating = true;
    });

    if (isCorrect) {
      _correctAnswers++;
    } else {
      _incorrectAnswers++;
    }

    // Check if quiz is complete
    if (_correctAnswers + _incorrectAnswers >= 10) {
      setState(() {
        _isQuizComplete = true;
        _isAnimating = false;
      });
      return;
    }

    // Move to next question with slide animation
    _flipController.reverse().then((_) {
      setState(() {
        _isCardFlipped = false;
        _currentQuestionIndex = (_currentQuestionIndex + 1) % quizQuestions.length;
        _isAnimating = false;
      });
    });
  }

  void _restartQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _correctAnswers = 0;
      _incorrectAnswers = 0;
      _isQuizComplete = false;
      _isCardFlipped = false;
      quizQuestions.shuffle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flip Card Quiz'),
        centerTitle: true,
        backgroundColor: Colors.purple.shade100,
      ),
      body: _isQuizComplete ? _buildResultsScreen() : _buildQuizScreen(),
    );
  }

  Widget _buildQuizScreen() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Question ${_correctAnswers + _incorrectAnswers + 1} of 10',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: _flipCard,
              child: AnimatedBuilder(
                animation: _flipAnimation,
                builder: (context, child) {
                  final angle = _flipAnimation.value * pi;
                  final transform = Matrix4.identity()
                    ..setEntry(3, 2, 0.001) // Perspective
                    ..rotateY(angle);

                  return Transform(
                    transform: transform,
                    alignment: Alignment.center,
                    child: angle < pi / 2
                        ? _buildCardFront()
                        : Transform(
                      transform: Matrix4.identity()..rotateY(pi),
                      alignment: Alignment.center,
                      child: _buildCardBack(),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        if (_isCardFlipped)
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: Icons.close,
                  color: Colors.red,
                  onPressed: () => _handleAnswer(false),
                ),
                _buildActionButton(
                  icon: Icons.check,
                  color: Colors.green,
                  onPressed: () => _handleAnswer(true),
                ),
              ],
            ),
          ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildCardFront() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.purple.shade100, Colors.purple.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Question',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              quizQuestions[_currentQuestionIndex]['question']!,
              style: const TextStyle(fontSize: 22),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            const Text(
              'Tap to reveal answer',
              style: TextStyle(
                fontSize: 16,
                color: Colors.purple,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardBack() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.blue.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Answer',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              quizQuestions[_currentQuestionIndex]['answer']!,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            const Text(
              'Did you get it right?',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
      ),
      child: Icon(icon, size: 32),
    );
  }

  Widget _buildResultsScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Quiz Complete!',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          _buildResultItem(
            icon: Icons.check_circle,
            color: Colors.green,
            label: 'Correct Answers',
            count: _correctAnswers,
          ),
          const SizedBox(height: 20),
          _buildResultItem(
            icon: Icons.cancel,
            color: Colors.red,
            label: 'Incorrect Answers',
            count: _incorrectAnswers,
          ),
          const SizedBox(height: 40),
          Text(
            'Your Score: ${(_correctAnswers * 100 / 10).toStringAsFixed(0)}%',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: _restartQuiz,
            icon: const Icon(Icons.refresh),
            label: const Text('Start Again', style: TextStyle(fontSize: 18)),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultItem({
    required IconData icon,
    required Color color,
    required String label,
    required int count,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(width: 16),
        Text(
          '$label: $count',
          style: TextStyle(fontSize: 20, color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}