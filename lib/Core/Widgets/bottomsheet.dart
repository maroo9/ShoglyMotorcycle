// import 'package:flutter/material.dart';
//
// import '../ColorsManger/Colorsmanger.dart';
//
// class Show{
// void showAddMotorcycleSheet() {
//
//   //clearForm();
//   showModalBottomSheet(
//       // context: context,
//       isScrollControlled: true,
//       backgroundColor: Colorsmanger.White,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: EdgeInsets.only(
//             left: 16,
//             right: 16,
//             top: 16,
//             bottom: MediaQuery.of(context).viewInsets.bottom + 16,
//           ),
//           child: Form(
//             key: _formKey,
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//               Row(
//               children: [
//               const Expanded(
//               child: Text(
//                 "Add Motorcycle",
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ),
//             IconButton(
//               onPressed: () => Navigator.pop(context),
//               icon: const Icon(Icons.close),
//             ),
//             ],
//           ),
//           ],
//         )
//             ),
//           ),
//         );
//             }
//       }
// }