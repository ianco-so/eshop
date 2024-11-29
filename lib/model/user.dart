import 'dart:convert';

import '../utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class User with ChangeNotifier {

  UserDetails userDetails = UserDetails(
    id: '',
    username: '',
    password: '',
  );

  String get id => userDetails.id;
  String get username => userDetails.username;
  String get password => userDetails.password;

  set id(String id) {
    this.userDetails.id = id;
  }
  set username(String username) {
    this.userDetails.username = username;
  }
  set password(String password) {
    this.userDetails.password = password;
  }

  bool get isLoggedIn => this.userDetails.isLoggedIn;
  set isLoggedIn(bool isLoggedIn) {
    this.userDetails.isLoggedIn = isLoggedIn;
  }

  Future<void> changePassword(String newPassword) async {
    if (this.id.isEmpty) {
      return;
    }
    final response = await http.patch(
      Uri.parse('${Urls.BASE_URL}/users/$id.json'),
      body: jsonEncode({
        'password': newPassword,
      }),
    );
    if (response.statusCode != 200) {
      throw 'Failed to update password';
    }
    notifyListeners();
  }

  static Future<UserDetails> findByUsername(String username) async {
    final response = await http.get(Uri.parse('${Urls.BASE_URL}/users.json'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final users = data.entries.map((e) => UserDetails.fromJson(e.key, e.value)).toList();
      print (users);
      return users.firstWhere((userDetails) => userDetails.username == username, orElse: () => throw 'User not found');
    } else {
      throw 'Failed to load users';
    }
  }

  Future<User> createUser(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      throw 'Invalid user data';
    }
    try {
      await findByUsername(username);
      throw 'User already exists';
    } catch (error) {
      if (error.toString() != 'User not found') {
        rethrow;
      }
    }


    final response = await http.post(
      Uri.parse('${Urls.BASE_URL}/users.json'),
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      this.id = data['name'];
      _sync();
      // notifyListeners();
      return this;
    } else {
      throw 'Failed to create user';
    }
  }
  
  Future<void> _sync() async {
    final response = await http.patch(
      Uri.parse('${Urls.BASE_URL}/users/${this.id}.json'),
      body: jsonEncode({
        "id": this.id,
      }),
    );
    if (response.statusCode != 200) {
      throw 'Failed to sync user';
    }
  }

  Future<void> login() async {
    final response = await http.get(Uri.parse('${Urls.BASE_URL}/users.json'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final users = data.entries.map((e) => UserDetails.fromJson(e.key, e.value)).toList();
      final user = users.firstWhere(
        (user) => user.username == this.username && user.password == this.password, 
        orElse: () => UserDetails(
          id: '',
          username: '',
          password: '',
        )
      );
      if (user.username.isNotEmpty) {
        print('THis username ${this.username} and password ${this.password} is correct');
        this.isLoggedIn = true;
        notifyListeners();
      } else {
        throw 'Invalid username or password';
      }
    } else {
      throw 'Failed to load users';
    }
  }

  void logout() {
    this.isLoggedIn = false;
    notifyListeners();
  }
}

class UserDetails {
  
  bool isLoggedIn = false;
  String id;
  String username;
  String password;

  UserDetails({
    required this.id,
    required this.username,
    required this.password,
  });

  //Factory method to create a UserDitails instance from a JSON map
  factory UserDetails.fromJson(String id, Map<String, dynamic> json) {
    return UserDetails(
      id: id,
      username: json['username'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'username': username,
      'password': password,
    };
    return data;
  }

  @override
  String toString() {
    return '{id: $id, username: $username, password: $password}';
  }

}