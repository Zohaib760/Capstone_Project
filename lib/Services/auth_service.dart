import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'db_helper.dart';

class AuthService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<Map<String, dynamic>> signUp(
      String email, String username, String password) async {
    // Check if email already exists
    if (await _dbHelper.getUserByEmail(email) != null) {
      throw Exception('Email already exists');
    }

    // Check if username already exists
    if (await _dbHelper.getUserByUsername(username) != null) {
      throw Exception('Username already exists');
    }

    // Hash password
    String hashedPassword = _hashPassword(password);

    // Insert new user
    int userId = await _dbHelper.insertUser({
      'email': email,
      'username': username,
      'password': hashedPassword,
      'created_at': DateTime.now().toIso8601String(),
    });

    return {
      'id': userId,
      'email': email,
      'username': username,
    };
  }

  Future<Map<String, dynamic>> login(String identifier, String password) async {
    // Hash password
    String hashedPassword = _hashPassword(password);

    // Check if identifier is email or username
    Map<String, dynamic>? user;
    if (identifier.contains('@')) {
      user = await _dbHelper.getUserByEmail(identifier);
    } else {
      user = await _dbHelper.getUserByUsername(identifier);
    }

    if (user == null) {
      throw Exception('User not found');
    }

    if (user['password'] != hashedPassword) {
      throw Exception('Invalid password');
    }

    return {
      'id': user['id'],
      'email': user['email'],
      'username': user['username'],
    };
  }

  Future<bool> emailExists(String email) async {
    return await _dbHelper.getUserByEmail(email) != null;
  }

  Future<bool> usernameExists(String username) async {
    return await _dbHelper.getUserByUsername(username) != null;
  }
}