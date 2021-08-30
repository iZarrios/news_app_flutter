// import 'package:flutter/material.dart';
// import 'package:todo_app/shared/components/components.dart';
//
// class SettingsScreen extends StatelessWidget {
//   var searchControlller = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Column(
//         children: [
//           defaultFormField(
//               controller: searchControlller,
//               type: TextInputType.text,
//               validate: (String? value) {
//                 if (value!.isEmpty) {
//                   return "Search can not be empty!";
//                 }
//                 return null;
//               },
//               label: "Search",
//               prefix: Icons.search),
//           Expanded(
//             child: Text(
//               "HI",
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
