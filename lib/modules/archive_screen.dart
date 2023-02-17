// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/shared/component/components.dart';
import 'package:todoapp/shared/cubit/cubit.dart';
import 'package:todoapp/shared/cubit/states.dart';

class archive_screen extends StatelessWidget {
  const archive_screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ListView.separated(
          itemBuilder: (context, index) =>
              buildTaskItem(AppCubit.get(context).archivetasks[index]),
          separatorBuilder: (context, index) => Padding(
            padding: const EdgeInsetsDirectional.only(start: 20.0),
            child: Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey,
            ),
          ),
          itemCount: AppCubit.get(context).archivetasks.length,
        );
      },
    );
  }
}
