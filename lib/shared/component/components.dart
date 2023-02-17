// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/shared/cubit/cubit.dart';
import 'package:todoapp/shared/cubit/states.dart';

Widget buildTaskItem(Map modelTask) => BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Dismissible(
          key: Key(modelTask['id'].toString()),
          onDismissed: (direction) {
            cubit.delDataBase(id: modelTask['id']);
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40.0,
                  child: Text(
                    '${modelTask['Time']}',
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${modelTask['Title']}',
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${modelTask['Date']}',
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                IconButton(
                    onPressed: () {
                      cubit.upgdateDataBase(
                        Status: 'done',
                        id: modelTask['id'],
                      );
                    },
                    icon: const Icon(
                      Icons.check_box,
                      color: Colors.green,
                    )),
                IconButton(
                    onPressed: () {
                      cubit.upgdateDataBase(
                        Status: 'archive',
                        id: modelTask['id'],
                      );
                    },
                    icon: const Icon(
                      Icons.archive_outlined,
                      color: Colors.black45,
                    )),
              ],
            ),
          ),
        );
      },
    );
