
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import '../helpers/shared_prefs.dart';
// import '../constants/offices.dart';

// class OfficesTable extends StatefulWidget {
//   const OfficesTable({Key? key}) : super(key: key);

//   @override
//   State<OfficesTable> createState() => _OfficesTableState();
// }

// class _OfficesTableState extends State<OfficesTable> {
//   // Add handlers to buttons later on
//   // For call and maps we can use url_launcher package.
//   // We can also create a turn-by-turn navigation for a particular restaurant.
//   // 🔥 Let's look at it in the next video!!

//   Widget cardButtons(IconData iconData, String label) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 10),
//       child: ElevatedButton(
//         onPressed: () {},
//         style: ElevatedButton.styleFrom(
//           padding: const EdgeInsets.all(5),
//           minimumSize: Size.zero,
//         ),
//         child: Row(
//           children: [
//             Icon(iconData, size: 16),
//             const SizedBox(width: 2),
//             Text(label)
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Office Table'),
//       ),
//       body: SafeArea(
//           child: SingleChildScrollView(
//         physics: const ScrollPhysics(),
//         child: Padding(
//           padding: const EdgeInsets.all(15),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const CupertinoTextField(
//                 prefix: Padding(
//                   padding: EdgeInsets.only(left: 15),
//                   child: Icon(Icons.search),
//                 ),
//                 padding: EdgeInsets.all(15),
//                 placeholder: 'Search Office or Facility name',
//                 style: TextStyle(color: Colors.white),
//                 decoration: BoxDecoration(
//                   color: Colors.black54,
//                   borderRadius: BorderRadius.all(Radius.circular(5)),
//                 ),
//               ),
//               const SizedBox(height: 5),
//               ListView.builder(
//                 physics: const NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 padding: EdgeInsets.zero,
//                 itemCount: offices.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return ClipRect(
//                     child: Card(

//                       clipBehavior: Clip.antiAlias,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20)),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           CachedNetworkImage(
//                             height: 155,
//                             width: 120,
//                             fit: BoxFit.cover,
//                             imageUrl: offices[index]['image'],
//                           ),
//                           Expanded(
//                             child: Container(
//                               height: 175,
                              
//                               padding: const EdgeInsets.all(15),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     offices[index]['name'],
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16),
//                                   ),
//                                   Text(offices[index]['items']),
//                                   const Spacer(),
//                                   //const Text('Waiting time: 2hrs'),
//                                   Text(
//                                     'Closes at 5PM',
//                                     style:
//                                         TextStyle(color: Colors.redAccent[100]),
//                                   ),
//                                   Expanded(
//                                     child: Row(
//                                       children: [
//                                         //cardButtons(Icons.call, 'Call'),
//                                         cardButtons(Icons.location_on, 'Map'),
//                                         const Spacer(),
//                                         Text(
//                                             '${(getDistanceFromSharedPrefs(index) / 1000).toStringAsFixed(2)}km'),
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       )),
//     );
//   }
// }
