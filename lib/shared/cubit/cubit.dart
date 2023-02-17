import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/modules/archive_screen.dart';
import 'package:todoapp/modules/done_screen.dart';
import 'package:todoapp/modules/task_screen.dart';
import 'package:todoapp/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit(AppStates initialState) : super(initialState);

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screens = [
    const tasks_screen(),
    const done_screen(),
    const archive_screen(),
  ];

  List<String> titles = [
    "Tasks",
    "Done Tasks",
    "Archived Tasks",
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  late Database database;

  late List<Map> newtasks = [];
  late List<Map> donetasks = [];
  late List<Map> archivetasks = [];

  void createDataBase() {
    openDatabase(
      'todo.db',
      version: 2,
      onCreate: (database, version) {
        debugPrint('database created');
        database
            .execute(
                'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, Title TEXT, Date TEXT, Time TEXT, Status TEXT);')
            .then((value) {
          debugPrint('table created');
        }).catchError((error) {
          debugPrint('error when create table${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataBase(database);
        debugPrint('database opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDataBaseState());
    });
  }

  Future insertToDataBase({
    @required title,
    @required date,
    @required time,
  }) {
    return database.transaction((txn) {
      return txn
          .rawInsert(
        'INSERT INTO Tasks (Title, Date, Time, Status) VALUES ("$title", "$date", "$time", "new")',
      )
          .then((value) {
        debugPrint('$value inserted successfully');
        emit(AppInsertDataBaseState());

        getDataBase(database);
      }).catchError((error) {
        debugPrint('error when creating new row ${error.toString()}');
      });
    });
  }

  void getDataBase(database) {
    newtasks = [];
    archivetasks = [];
    donetasks = [];
    emit(AppGetDataBaseLoaderState());
    database.rawQuery('SELECT * FROM Tasks').then((value) {
      value.forEach((element) {
        if (element['Status'] == 'new') {
          newtasks.add(element);
        } else if (element['Status'] == 'done') {
          donetasks.add(element);
        } else {
          archivetasks.add(element);
        }
      });
      emit(AppGetDataBaseState());
    });
  }

  void upgdateDataBase({
    @required String? Status,
    @required int? id,
  }) {
    database.rawUpdate('UPDATE Tasks SET Status = ? WHERE id = ?',
        ['$Status', id]).then((value) {
      getDataBase(database);
      emit(AppUpdateDataBaseState());
    });
  }

  void delDataBase({
    @required int? id,
  }) {
    database.rawDelete('DELETE FROM Tasks WHERE id = ?', [id]);
    {
      getDataBase(database);
      emit(AppDeleteDataBaseState());
    }
  }

  IconData fabicon = Icons.edit;
  bool fabtoggle = false;

  void changeBottomSheet({
    @required isshow,
    @required icon,
  }) {
    fabtoggle = isshow;
    fabicon = icon;
    emit(AppChangeBottomSheetState());
  }
}
