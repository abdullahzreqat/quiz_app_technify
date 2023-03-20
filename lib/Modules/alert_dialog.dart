import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_technify/Cubit/app_cubit.dart';
import 'package:quiz_app_technify/Cubit/app_states.dart';
import 'package:quiz_app_technify/Shared/components/constants.dart';

class AlertWidget extends StatelessWidget {
  final List questions;
  const AlertWidget({Key? key,required this.questions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..resultState(questions),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "RESULT",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              AppCubit.get(context).isPassed
                  ? Icon(
                Icons.check_circle_outline,
                color: kGreenColor,
              )
                  : Icon(
                Icons.close,
                color: kRedColor,
              )
            ],
          ),
          titleTextStyle: TextStyle(
            color: Colors.white,
          ),
          backgroundColor: kSecondaryColor,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(
                height: 0,
                color: Colors.white,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Grade: ${AppCubit.get(context).correctAnswers} \\ ${AppCubit.get(context).questions.length}.",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.white),
              ),
              !AppCubit.get(context).isPassed?
              Text("Failed!",style: TextStyle(color: kRedColor),):
              Text("Passed!",style: TextStyle(color: kGreenColor),)
            ],
          ),
        );
        },
      ),
    );
  }
}
