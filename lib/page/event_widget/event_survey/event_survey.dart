import 'package:flutter/material.dart';
import 'package:survey_kit/survey_kit.dart';


class EventSurvey extends StatelessWidget {
  EventSurvey({
    super.key,
    required this.title,
  });

  final String title;

  var task = OrderedTask(
    id: TaskIdentifier(),     // How to properly define the id?
    steps: [
      InstructionStep(
        title: 'Drinks',
        text: 'It is necessary to drink in order to have fun, '
            'or something like this',
        buttonText: 'Start survey',
      ),
      QuestionStep(
        title: 'Drinks',
        text: "Please select the drinks you'd like to have",
        answerFormat: const MultipleChoiceAnswerFormat(
          textChoices: [
            TextChoice(text: 'Spriz Aperol', value: 'Spriz Aperol'),
            TextChoice(text: 'Spriz Campari', value: 'Spriz Campari'),
            TextChoice(text: 'Americano', value: 'Americano'),
            TextChoice(text: 'Negroni', value: 'Negroni'),
          ],
        ),
      ),
      CompletionStep(
        stepIdentifier: StepIdentifier(id: '321'),  // What does this do?
        title: 'Drinks',
        text: 'Thanks for your opinion',
        buttonText: 'Submit survey',
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0))
      ),
      contentPadding: const EdgeInsets.only(top: 15.0,),
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SurveyKit(
            onResult: (SurveyResult result) {
              final jsonResult = result.toJson();
              print(jsonResult);

              // print the json-formatted results
              //debugPrint(jsonEncode(jsonResult));
              // or store them
              // yourDbHandler.store(jsonResult);

              Navigator.pop(context, true);         // Make this compatible with
              // with our navigation
            },
            task: task,
          ),
        ),
      ],
    );
  }
}

