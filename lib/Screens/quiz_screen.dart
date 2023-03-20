import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quiz_app_technify/Cubit/app_cubit.dart';
import 'package:quiz_app_technify/Cubit/app_states.dart';
import 'package:quiz_app_technify/Modules/alert_dialog.dart';
import 'package:quiz_app_technify/Shared/components/constants.dart';

class QuizScreen extends StatelessWidget {
  final String userName;

  const QuizScreen(this.userName);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var questionController = PageController();
         // List questions = AppCubit.get(context).questions;
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              titleSpacing: 0,
              title: Text(userName),
              backgroundColor: Colors.transparent,
              elevation: 0,
              systemOverlayStyle:
                  SystemUiOverlayStyle(statusBarColor: Colors.transparent),
              actions: [
                if (cubit.question != cubit.questions.length)
                  TextButton(
                      onPressed: () {
                        cubit.changeQuestion();
                      },
                      child: Text(
                        "SKIP",
                        style: TextStyle(color: Colors.white),
                      ))
              ],
            ),
            body: Stack(
              children: [
                SvgPicture.asset(
                  "assets/icons/bg.svg",
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
                SafeArea(
                    child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                            text: "Question ${cubit.question}",
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(color: kSecondaryColor),
                            children: [
                              TextSpan(
                                text: "/${cubit.questions.length}",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(color: kSecondaryColor),
                              )
                            ]),
                      ),
                      Divider(thickness: 1.5),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: kDefaultPadding),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)),
                            child: Padding(
                              padding: const EdgeInsets.all(kDefaultPadding),
                              child: PageView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                controller: questionController,
                                itemBuilder: (context, index) =>
                                    SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Text(
                                        "${cubit.questions[cubit.question - 1]['question']}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(color: kBlackColor),
                                      ),
                                      ...List.generate(
                                          cubit.questions[cubit.question - 1]
                                                  ['options']
                                              .length,
                                          (i) => buildAnswers(
                                              context,
                                              cubit.questions[cubit.question - 1]
                                                  ['options'][i],
                                              i)),
                                      SizedBox(
                                        height: kDefaultPadding,
                                      ),
                                      Row(
                                        children: [
                                          Spacer(),
                                          if (cubit.question != 1)
                                            IconButton(
                                                onPressed: () =>
                                                    cubit.changeQuestion(
                                                        isForward: false),
                                                icon: Icon(
                                                  Icons.navigate_before,
                                                  size: 30,
                                                  color: kBlackColor,
                                                )),
                                          if (cubit.question < cubit.questions.length)
                                            IconButton(
                                                onPressed: () =>
                                                    cubit.changeQuestion(),
                                                icon: Icon(
                                                  Icons.navigate_next,
                                                  size: 30,
                                                  color: kBlackColor,
                                                ))
                                          else
                                            SizedBox(
                                              width: 48,
                                            )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      if (cubit.question ==
                                          cubit.questions.length)
                                        Container(
                                            width: double.infinity,
                                            child: MaterialButton(
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertWidget(questions: cubit.questions);
                                                    });
                                              },
                                              height: 45,
                                              color: kSecondaryColor,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25)),
                                              child: Text("Submit Quiz"),
                                            ))
                                    ],
                                  ),
                                ),
                                itemCount: cubit.questions.length,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ))
              ],
            ),
          );
        },
      ),
    );
  }


  Widget buildAnswers(context, option, int index) {
    return InkWell(
      onTap: () {
        AppCubit.get(context)
            .questions[AppCubit.get(context).question - 1]['options']
            .forEach((e) => e['option_status'] = false);
        AppCubit.get(context).optionClicked(index);
      },
      child: Container(
        margin: EdgeInsets.only(top: kDefaultPadding),
        decoration: BoxDecoration(
          border: Border.all(
              color: option['option_status'] ? kBlackColor : kGrayColor),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${index + 1}. ${option['text']}",
                style: TextStyle(
                    color: option['option_status'] ? kBlackColor : kGrayColor,
                    fontSize: 16),
              ),
              Icon(
                Icons.circle_outlined,
                size: 25,
                color: option['option_status'] ? kBlackColor : kGrayColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}

