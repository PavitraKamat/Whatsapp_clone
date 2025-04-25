import 'package:wtsp_clone/fireBasemodel/models/user_model.dart';

List<UserModel> filterContactsHelper(List<UserModel> contacts, String query) {
  query = query.toLowerCase();
  return contacts.where((user) {
    bool matchesName = user.firstName.toLowerCase().contains(query);
    bool matchesNumber = user.phone.replaceAll(RegExp(r'\D'), '').contains(query);
    return matchesName || matchesNumber;
  }).toList();
}
