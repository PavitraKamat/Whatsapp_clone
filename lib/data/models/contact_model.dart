//import 'package:contacts_service/contacts_service.dart';

class ContactModel {
  final String name;
  final String phone;
  String image;
  String lastSeen;

  ContactModel(
      {required this.name,
      required this.phone,
      required this.image,
      required this.lastSeen});

  // factory ContactModel.fromJson(Map<String, dynamic> json) {
  //   return ContactModel(
  //     name: json['name'],
  //     phone: json['phone'],
  //     image: json['image'] ?? "",
  //     lastseen: :
  //   );
  // }
}

//   factory ContactModel.fromContact(Contact contact) {
//     return ContactModel(
//       name: contact.displayName ?? "Unknown",
//       phone: contact.phones!.isNotEmpty
//           ? contact.phones!.first.value!
//           : "No number",
//     );
//   }
// }
