import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_app/modules/new_tasks/new_tasks_screen.dart';
import 'package:todo_app/shared/cubit/states.dart';
import 'package:todo_app/shared/network/local/cache_helper.dart';

class AppCubit extends Cubit<AppStates> {
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  late Database database;

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<String> title = [
    "New Tasks",
    "Done Tasks",
    "Archived Tasks",
  ];
  int currentIndex = 0;

  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDatabase() {
    openDatabase(
      //will result in a "database"
      'todo.db',
      version: 1,
      onCreate: (Database db, int version) {
        print("created");
        db.execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)');
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print("db opened");
      },
    ).then((value) {
      database = value; //changed value then we need ot emit the change
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase(
      {required String title,
      required String time,
      required String date}) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time, status) VALUES("$title","$date","$time","new")')
          .then((value) {
        print("$value inserted successfully");
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error) {
        print("error cubit.dart inserting to db  $error");
      });
    });
  }

  void getDataFromDatabase(database) {
    //if we dont reset the Lists it will duplicate the results
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else if (element['status'] == 'archive') {
          archivedTasks.add(element);
        } else {
          print("ERROR status unknown");
        }
      });
      emit(AppGetDatabaseState());
    });
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    fabIcon = icon;
    isBottomSheetShown = isShow;
    emit(ChangeBottomSheetState());
  }

  void updateDatabase({required String status, required int id}) async {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteFromDatabase({required int id}) async {
    database.rawDelete('DELETE FROM tasks  WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  bool isDark = true;

  void changeAppMode() {
    isDark = !isDark;
    CacheHelper.putBool(key: "isDark", value: isDark).then(
      (value) {
        emit(ChangeAppThemeState());
      },
    );
  }
}
