import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_constants.dart';
import 'models/contact_model.dart';

class ContactService {
  Future<List<ContactModel>> getContacts() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.usersEndpoint}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => ContactModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load contacts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching contacts: $e');
    }
  }

  Future<ContactModel> addContact(ContactModel contact) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.usersEndpoint}'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(contact.toJson()),
      );

      if (response.statusCode == 201) {
        return ContactModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to add contact: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding contact: $e');
    }
  }

  Future<ContactModel> updatePhone(int id, String newPhone) async {
    try {
      final response = await http.patch(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.usersEndpoint}/$id'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'phone': newPhone}),
      );

      if (response.statusCode == 200) {
        return ContactModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update phone: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating phone: $e');
    }
  }
}
