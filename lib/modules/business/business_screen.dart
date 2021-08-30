import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/layout/cubit/cubit.dart';
import 'package:todo_app/layout/cubit/states.dart';
import 'package:todo_app/shared/components/components.dart';

class BusinessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cubit = NewsCubit.get(context);
    return BlocConsumer<NewsCubit, NewsStates>(
        builder: (context, state) {
          var cubit = NewsCubit.get(context);
          return articleBuilder(cubit.business, context);
        },
        listener: (context, state) {});
  }
}

// {
// "title":
// "مدير شركة أبل يحصل على مكافأة قيمتها 750 مليون دولار - BBC Arabic",
// "urlToImage":
// "https://ichef.bbci.co.uk/news/1024/branded_arabic/866A/production/_120301443_18e55a34-5cae-4cef-8f4e-cfc3eb25574a.jpg",
// "publishedAt": "2021-08-27T08:25:47Z",
// }
