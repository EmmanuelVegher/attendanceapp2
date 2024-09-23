// import 'package:flutter/material.dart';
// import 'offices_map.dart';
// import 'offices_table.dart';

// class OfficeManagement extends StatefulWidget {
//   const OfficeManagement({Key? key}) : super(key: key);

//   @override
//   State<OfficeManagement> createState() => _OfficeManagementState();
// }



// class _OfficeManagementState extends State<OfficeManagement> {
//   final List<Widget> _pages = [
//     const OfficesMap(),
//     const OfficesTable()
//   ];
//   int _index = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_index],
//       bottomNavigationBar: BottomNavigationBar(
//         onTap: (selectedIndex) {
//           setState(() {
//             _index = selectedIndex;
//           });
//         },
//         currentIndex: _index,
//         items: const [
//           BottomNavigationBarItem(
//               icon: Icon(Icons.map), label: 'Office Maps'),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.local_post_office), label: 'Office Table'),
//         ],
//       ),
//     );
//   }
// }
