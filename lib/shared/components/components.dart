import 'package:flutter/material.dart';
import 'package:todo_app/modules/webview/web_view_screen.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key('${model['id']}'),
      onDismissed: (direction) {
        AppCubit.get(context).deleteFromDatabase(id: model['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text("${model['time']}"),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${model['title']}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${model['date']}",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            IconButton(
              onPressed: () {
                AppCubit.get(context).updateDatabase(
                  status: "done",
                  id: model['id'],
                );
              },
              icon: Icon(Icons.done),
              color: Colors.green,
            ),
            SizedBox(width: 10),
            IconButton(
                onPressed: () {
                  AppCubit.get(context).updateDatabase(
                    status: "archive",
                    id: model['id'],
                  );
                },
                icon: Icon(
                  Icons.archive_outlined,
                  color: Colors.black45,
                )),
          ],
        ),
      ),
    );

Widget buildArticleItem(article, context) => InkWell(
      onTap: () {
        print(article["url"]);
        navigateTo(context, WebViewScreen(url: article["url"]));
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage("${article["urlToImage"]}"),
                    fit: BoxFit.cover,
                  )),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Container(
                height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        "${article["title"]}",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      "${article["publishedAt"]}",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function? onSubmit,
  Function? onChange,
  Function? onTap,
  bool isPassword = false,
  required Function validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  Function? suffixPressed,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: onSubmit as void Function(String)?,
      onChanged: onChange as void Function(String)?,
      onTap: onTap as void Function()?,
      validator: validate as String? Function(String?)?,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: suffixPressed as void Function()?,
                icon: Icon(
                  suffix,
                ),
              )
            : null,
        border: OutlineInputBorder(),
      ),
    );

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

Widget articleBuilder(list, context, {isSearch = false}) {
  return list.length > 0
      ? ListView.separated(
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) =>
              buildArticleItem(list[index], context),
          separatorBuilder: (context, index) => SizedBox(height: 10),
          itemCount: list.length)
      : isSearch
          ? Container()
          : Center(child: CircularProgressIndicator());
}
