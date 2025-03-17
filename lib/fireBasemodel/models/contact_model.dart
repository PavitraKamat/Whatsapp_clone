//import 'package:contacts_service/contacts_service.dart';

class ContactModel {
  final String id;
  final String name;
  final String phone;
  String image;
  String lastSeen;

  ContactModel(
      {required this.id,
      required this.name,
      required this.phone,
      required this.image,
      required this.lastSeen});
}
