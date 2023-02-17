import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/shared/cubit/cubit.dart';
import 'package:todoapp/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  HomeLayout({Key? key}) : super(key: key);

  var dateController = TextEditingController();

  var formkey = GlobalKey<FormState>();
  var scaffoldkey = GlobalKey<ScaffoldState>();

  var timeController = TextEditingController();
  var titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(AppInitialState())..createDataBase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) => {
          if (state is AppInsertDataBaseState)
            {
              Navigator.pop(context),
            }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldkey,
            appBar: AppBar(
              title: Text(
                cubit.titles[cubit.currentIndex],
              ),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDataBaseLoaderState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.fabtoggle) {
                  if (formkey.currentState!.validate()) {
                    cubit
                        .insertToDataBase(
                      title: titleController.text,
                      date: dateController.text,
                      time: timeController.text,
                    )
                        .then((value) {
                      titleController.clear();
                      timeController.clear();
                      dateController.clear();

                      cubit.changeBottomSheet(
                        isshow: false,
                        icon: Icons.edit,
                      );
                    });
                  }
                } else {
                  scaffoldkey.currentState
                      ?.showBottomSheet(
                        (context) => Container(
                          padding: const EdgeInsets.all(20.0),
                          color: Colors.grey[100],
                          child: Form(
                            key: formkey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: titleController,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    labelText: 'Title',
                                    icon: const Icon(Icons.title),
                                    suffixIcon: IconButton(
                                      onPressed: titleController.clear,
                                      icon: const Icon(Icons.clear),
                                    ),
                                  ),
                                  validator: (value) {
                                    return (value!.isEmpty)
                                        ? 'Title must not be empty'
                                        : null;
                                  },
                                ),
                                TextFormField(
                                  controller: timeController,
                                  keyboardType: TextInputType.text,
                                  onTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      timeController.text =
                                          value!.format(context);
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Time',
                                    icon:
                                        const Icon(Icons.watch_later_outlined),
                                    suffixIcon: IconButton(
                                      onPressed: titleController.clear,
                                      icon: const Icon(Icons.clear),
                                    ),
                                  ),
                                  validator: (value) {
                                    return (value!.isEmpty)
                                        ? 'Time must not be empty'
                                        : null;
                                  },
                                ),
                                TextFormField(
                                  controller: dateController,
                                  keyboardType: TextInputType.datetime,
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2100, 01, 01),
                                    ).then((value) {
                                      dateController.text =
                                          DateFormat.yMMMd().format(value!);
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Date',
                                    icon: const Icon(
                                        Icons.calendar_today_outlined),
                                    suffixIcon: IconButton(
                                      onPressed: titleController.clear,
                                      icon: const Icon(Icons.clear),
                                    ),
                                  ),
                                  validator: (value) {
                                    return (value!.isEmpty)
                                        ? 'Date must not be empty'
                                        : null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheet(
                      isshow: false,
                      icon: Icons.edit,
                    );
                  });
                  cubit.changeBottomSheet(
                    isshow: true,
                    icon: Icons.add,
                  );
                }
              },
              child: Icon(
                cubit.fabicon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.currentIndex,
                onTap: (index) {
                  cubit.changeIndex(index);
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.menu,
                    ),
                    label: "Task",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.check_circle,
                    ),
                    label: "Done",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.archive_outlined,
                    ),
                    label: "Archive",
                  ),
                ]),
          );
        },
      ),
    );
  }
}
