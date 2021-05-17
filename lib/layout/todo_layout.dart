import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_flutter/modules/archive_tasks/archive_tasks_screen.dart';
import 'package:udemy_flutter/modules/done_tasks/done_tasks_screen.dart';
import 'package:udemy_flutter/modules/new_tasks/new_tasks_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:udemy_flutter/shared/components/components.dart';
import 'package:intl/intl.dart';
import 'package:udemy_flutter/shared/components/constants.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:udemy_flutter/shared/cubit/cubit.dart';
import 'package:udemy_flutter/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: Text(cubit.titles[cubit.currentIndex]),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  if (cubit.isButtonSheetShown) {
                    if (formKey.currentState.validate()) {
                      cubit.insertToDatabase(
                          title: titleController.text,
                          time: timeController.text,
                          date: dateController.text);
                      // insertToDatabase(
                      //   time: timeController.text,
                      //   title: titleController.text,
                      //   date: dateController.text,
                      // ).then((value) => {
                      //       getDataFromDatabase(database).then((value) => {
                      //             Navigator.pop(context),
                      //             // setState(() {
                      //             // isButtonSheetShown = false;
                      //             // fabIcon = Icons.edit;
                      //             // tasks = value;
                      //             // }),
                      //           }),
                      //     });
                    }
                  } else {
                    scaffoldKey.currentState
                        .showBottomSheet(
                            (context) => Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.all(20.0),
                                  child: Form(
                                    key: formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        defaultFormField(
                                            controller: titleController,
                                            type: TextInputType.text,
                                            validate: (String value) {
                                              if (value.isEmpty) {
                                                return 'Title Must Not Be Empty';
                                              }
                                              return null;
                                            },
                                            label: 'Task Title',
                                            prefix: Icons.title),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        defaultFormField(
                                            controller: timeController,
                                            type: TextInputType.datetime,
                                            onTap: () {
                                              showTimePicker(
                                                      context: context,
                                                      initialTime:
                                                          TimeOfDay.now())
                                                  .then((value) => {
                                                        timeController.text =
                                                            value
                                                                .format(context)
                                                                .toString(),
                                                        print(value.toString())
                                                      });
                                            },
                                            validate: (String value) {
                                              if (value.isEmpty) {
                                                return 'Time Must Not Be Empty';
                                              }
                                              return null;
                                            },
                                            label: 'Task Time',
                                            prefix: Icons.timer),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        defaultFormField(
                                            controller: dateController,
                                            type: TextInputType.datetime,
                                            onTap: () {
                                              showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime.now(),
                                                      lastDate: DateTime.parse(
                                                          '2021-06-03'))
                                                  .then((value) => {
                                                        dateController.text =
                                                            DateFormat.yMMMd()
                                                                .format(value)
                                                      });
                                            },
                                            validate: (String value) {
                                              if (value.isEmpty) {
                                                return 'Date Must Not Be Empty';
                                              }
                                              return null;
                                            },
                                            label: 'Task Date',
                                            prefix: Icons.calendar_today),
                                      ],
                                    ),
                                  ),
                                ),
                            elevation: 20.0)
                        .closed
                        .then((value) => {
                              cubit.changeBottomSheetState(
                                  isShow: false, icon: Icons.edit)
                            });
                    cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                  }
                },
                child: Icon(cubit.fabIcon),
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.currentIndex,
                onTap: (index) {
                  cubit.changeIndex(index);
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.menu), label: 'Tasks'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.check_box), label: 'Done'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive_outlined), label: 'Archived'),
                ],
              ),
              body: ConditionalBuilder(
                condition: state is! AppGetDatabaseLoadingState,
                builder: (context) => cubit.screens[cubit.currentIndex],
                fallback: (context) =>
                    Center(child: CircularProgressIndicator()),
              ));
        },
      ),
    );
  }
}
