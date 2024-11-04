import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserModel with ChangeNotifier {
  String _id = '';
  String _name = '';
  String _email = '';
  String _phone = '';
  String _bio = '';

  String get id => _id;
  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get bio => _bio;

  Future<void> setUserDetails(
      String id, String name, String email, String phone,
      {String bio = ''}) async {
    _id = id;
    _name = name;
    _email = email;
    _phone = phone;
    _bio = bio;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', _id);
    await prefs.setString('name', _name);
    await prefs.setString('email', _email);
    await prefs.setString('phone', _phone);
    await prefs.setString('bio', _bio);

    notifyListeners();
  }

  Future<void> loadUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _id = prefs.getString('id') ?? '';
    _name = prefs.getString('name') ?? '';
    _email = prefs.getString('email') ?? '';
    _phone = prefs.getString('phone') ?? '';
    _bio = prefs.getString('bio') ?? '';

    notifyListeners();
  }

  Future<void> clearUserDetails() async {
    _id = '';
    _name = '';
    _email = '';
    _phone = '';
    _bio = '';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('id');
    await prefs.remove('name');
    await prefs.remove('email');
    await prefs.remove('phone');
    await prefs.remove('bio');

    notifyListeners();
  }

  set bio(String value) {
    _bio = value;
    notifyListeners();
  }

  Future<void> saveBio() async {
    final url = Uri.parse(
        'http://10.0.2.2:3000/users/$_id');
    final response = await http.patch(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({'bio': _bio}),
    );

    if (response.statusCode == 200) {
      print('Bio berhasil disimpan: $_bio');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('bio', _bio);
      notifyListeners();
    } else {
      print('Error: ${response.body}');
      throw Exception(
          'Gagal menyimpan bio: ${response.statusCode}');
    }
  }
}
