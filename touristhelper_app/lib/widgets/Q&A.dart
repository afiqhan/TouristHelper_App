import 'dart:math';
import 'package:flutter/material.dart';

class TouristQAPage extends StatefulWidget {
  @override
  _TouristQAPageState createState() => _TouristQAPageState();
}

class _TouristQAPageState extends State<TouristQAPage> {
  List<String> questions = [
    'What are the must-visit attractions in the area?',
    'What is the best time to visit?',
    'You know how to travel between cities in Malaysia?',
    'Whats the best way to experience Malaysian culture and traditions?',
    'What are some traditional Malaysian dishes I must try?',
    // Add more questions as needed
  ];

  int currentQuestionIndex = 0;
  String currentQuestion = '';

  List<Map<String, String>> qaList = [];
  TextEditingController answerController = TextEditingController();

  String getQuestion() {
    if (currentQuestionIndex < questions.length) {
      currentQuestion = questions[currentQuestionIndex++];
      return currentQuestion;
    } else {
      return 'No more questions available.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Q&A Page'),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/user.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Question:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextField(
                  controller: answerController,
                  decoration: InputDecoration(
                    labelText: 'Your Answer',
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Validate and add the Q&A to the list
                    if (answerController.text.isNotEmpty) {
                      setState(() {
                        qaList.add({
                          'question': currentQuestion,
                          'answer': answerController.text,
                        });
                        // Clear the text field
                        answerController.clear();
                      });
                    } else {
                      // Show an error message
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text('Please fill out the answer.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text('Submit Answer'),
                ),
                SizedBox(height: 16),
                Text(
                  'Your Q&A List:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: qaList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('Q: ${qaList[index]['question']}'),
                        subtitle: Text('A: ${qaList[index]['answer']}'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

