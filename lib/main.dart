import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/material.dart';
import 'quiz_brain.dart';

QuizBrain quizBrain = QuizBrain();

void main() {
  runApp(const Quizzy());
}

class Quizzy extends StatelessWidget {
  const Quizzy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> scoreKeeper = [];

  void restartApp() {
    setState(() {
      quizBrain.resetQuiz();
      scoreKeeper.clear();
    });
  }

  Icon getCorrectIcon() => const Icon(
        Icons.check,
        color: Colors.green,
      );

  Icon getIncorrectIcon() => const Icon(
        Icons.close,
        color: Colors.red,
      );

  void questionSubmitted(bool answer) {
    if (quizBrain.isQuizOver()) {
      Alert(
        context: context,
        title: "FINISHED!",
        desc: "You have reached the end of quiz.",
        buttons: [
          DialogButton(
            child: const Text("RESTART"),
            onPressed: () {
              restartApp();
              Navigator.pop(context);
            },
          )
        ],
      ).show();
    } else {
      if (answer == quizBrain.getAnswer()) {
        scoreKeeper.add(getCorrectIcon());
      } else {
        scoreKeeper.add(getIncorrectIcon());
      }
    }
  }

  Expanded generateButton(bool answer) {
    String text = answer == true ? 'True' : 'False';
    MaterialColor color = answer == true ? Colors.green : Colors.red;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: TextButton(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(color),
          ),
          onPressed: () => setState(() {
            questionSubmitted(answer);
            quizBrain.nextQuestion();
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestion(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        generateButton(true),
        generateButton(false),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: scoreKeeper,
          ),
        ),
      ],
    );
  }
}
