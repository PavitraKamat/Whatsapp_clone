// import 'package:flutter/material.dart';
// import 'package:wtsp_clone/data/models/contact_model.dart';
// import 'package:wtsp_clone/presentation/screens/chats/individual_page.dart';

// class ContactTile extends StatelessWidget {
//   final ContactModel contact;

//   ContactTile({required this.contact});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//         onTap: () {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => IndividualPage(
//                         contact: contact,
//                       )));
//         },
//         child: Column(
//           children: [
//             ListTile(
//               leading: CircleAvatar(
//                 radius: 30,
//                 backgroundImage: contact.image.isNotEmpty
//                     ? AssetImage(contact.image)
//                     : AssetImage("assets/images/profile.jpg"),
//                 backgroundColor: Colors.grey[300],
//                 child: contact.image.isEmpty
//                     ? Icon(Icons.person, color: Colors.white, size: 30)
//                     : null,
//               ),
//               title: Text(
//                 contact.name,
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//               ),
//               subtitle: Text(
//                 contact.phone,
//                 style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//               ),
//             )
//           ],
//         ));
//   }
// }
