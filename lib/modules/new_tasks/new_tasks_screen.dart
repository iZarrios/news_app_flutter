import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class NewTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      builder: (context, state) {
        var tasks = AppCubit.get(context).newTasks;
        return
          tasks.length > 0 ?  ListView.separated(
              itemBuilder: (context, index) =>
                  buildTaskItem(tasks[index], context),
              separatorBuilder: (context, index) => Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[300],
              ),
              itemCount: tasks.length,
            ) : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.menu),
                  Text("No Tasks Yet, Please Add some Tasks"),
                ],
          ),
            );
      },
      listener: (context, state) {},
    );
  }
}
