import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final timeController = TextEditingController();
  final dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (BuildContext context, AppStates state) {
        if (state is AppInsertDatabaseState) {
          Navigator.pop(context);
        }
      }, builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(cubit.title[cubit.currentIndex]),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (cubit.isBottomSheetShown &&
                  formKey.currentState!.validate()) {
                cubit.insertToDatabase(
                    title: titleController.text,
                    time: timeController.text,
                    date: dateController.text);
              } else {
                scaffoldKey.currentState!
                    .showBottomSheet(
                      (context) => Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(10),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: titleController,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'title must not be empty';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    labelText: "New Task",
                                    prefixIcon: Icon(Icons.title)),
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                onTap: () {
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  ).then((value) {
                                    timeController.text =
                                        value!.format(context).toString();
                                  });
                                },
                                controller: timeController,
                                keyboardType: TextInputType.datetime,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'time must not be empty';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    labelText: "Task Time",
                                    prefixIcon:
                                        Icon(Icons.watch_later_outlined)),
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                onTap: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2024, 1, 1),
                                  ).then((value) {
                                    dateController.text =
                                        DateFormat.yMMMd().format(value!);
                                  });
                                },
                                controller: dateController,
                                keyboardType: TextInputType.datetime,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'date must not be empty';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    labelText: "Task Date",
                                    prefixIcon:
                                        Icon(Icons.calendar_today_outlined)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      elevation: 20,
                    )
                    .closed
                    .then((value) {
                  cubit.changeBottomSheetState(isShow: false, icon: Icons.add);
                });
                cubit.changeBottomSheetState(isShow: true, icon: Icons.edit);
              }
            },
            child: Icon(cubit.fabIcon),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeIndex(index);
            },
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                label: "Tasks",
                icon: Icon(Icons.menu),
              ),
              BottomNavigationBarItem(
                label: "Done",
                icon: Icon(Icons.check_circle_outline),
              ),
              BottomNavigationBarItem(
                label: "Archived",
                icon: Icon(Icons.archive_outlined),
              ),
            ],
          ),
          body: state is! AppGetDatabaseLoadingState
              ? cubit.screens[cubit.currentIndex]
              : Center(child: CircularProgressIndicator()),
        );
      }),
    );
  }
}
