import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_technify/Cubit/app_states.dart';
import 'package:quiz_app_technify/Shared/components/constants.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  List questions = [
    {
      "id": 1,
      "question":
          "Flutter is an open-source UI software development kit created by ______.",
      "options": [
        {
          "option_status": false,
          'text': 'Apple',
        },
        {'option_status': false, 'text': 'Google'},
        {'option_status': false, 'text': 'Facebook'},
        {'option_status': false, 'text': 'Microsoft'}
      ],
      "answer_index": 1,
    },
    {
      "id": 2,
      "question": "When google release Flutter.",
      "options": [
        {'option_status': false, 'text': 'Jun 2017'},
        {'option_status': false, 'text': 'Jun 2017'},
        {'option_status': false, 'text': 'May 2017'},
        {'option_status': false, 'text': 'May 2018'}
      ],
      "answer_index": 2,
    },
    {
      "id": 3,
      "question": "A memory location that holds a single letter or number.",
      "options": [
        {'option_status': false, 'text': 'Double'},
        {'option_status': false, 'text': 'Int'},
        {'option_status': false, 'text': 'Char'},
        {'option_status': false, 'text': 'Word'}
      ],
      "answer_index": 2,
    },
    {
      "id": 4,
      "question": "What command do you use to output data to the screen?",
      "options": [
        {'option_status': false, 'text': 'Cin'},
        {'option_status': false, 'text': 'Count>>'},
        {'option_status': false, 'text': 'Cout'},
        {'option_status': false, 'text': 'Output>>'}
      ],
      "answer_index": 2,
    },
  ];

  int question = 1;
  int correctAnswers = 0;
  bool isPassed = false;

  void changeQuestion({bool isForward = true}) {
    if (isForward) {
      question++;
      emit(ChangeQuestionState());
    } else {
      question--;
      emit(ChangeQuestionState());
    }
  }

  void optionClicked(index) {
    questions[question - 1]['options'][index]["option_status"] = true;
    print(questions);
    emit(ChangeOptionState());
  }

  bool isCorrect = false;

  void checkState(List options) {
    print(questions);
    for (int i = 0; i < options.length; i++) {
      if (options[i]['option_status'] == true) {
        if (i == questions[question - 1]['answer_index']) {
          correctAnswers++;
          emit(CheckState());
        }
      }
    }
    emit(CheckState());
  }

  void resultState(questions) {
    print(questions);

    correctAnswers = 0;
    for (var e in questions) {
      print(correctAnswers);
      for (int i = 0; i < e['options'].length; i++) {
        print(e['options'][i]['option_status']);
        if (e['options'][i]['option_status'] == true) {
          print(e['answer_index']);
          if (i == e['answer_index']) {
            correctAnswers++;
            if (correctAnswers > questions.length/2 -1) isPassed = true;
          }
        }
      }
    }
    emit(ResultState());
  }
}
