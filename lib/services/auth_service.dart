// Authentication service for API calls
// Backend service: src/service/auth.service.js
// Backend controller: src/controller/auth/auth.controller.js

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';
import '../utils/api_config.dart';

class AuthService extends ChangeNotifier {
  //the secure storage is private to this class
  final _storage = const FlutterSecureStorage();
  User? _currentUser;
  String? _token;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _token != null;

  //register user
  Future<bool> register({
    required String email,
    required String password,
    String? name,
  }) async {
    //loading state
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    //POSt request
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.register),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          if (name != null) 'name': name,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 201 && data['success']) {
        _token = data['data']['token'];
        _currentUser = User.fromJson(data['data']['user']);

        //for persistent login
        await _storage.write(key: 'auth_token', value: _token);

        _isLoading = false;
        notifyListeners();
        return true;
      }
      //handling failures
      else {
        _errorMessage = data['message'] ?? 'Registration failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Network error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  //user login
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.login),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success']) {
        _token = data['data']['token'];
        _currentUser = User.fromJson(data['data']['user']);

        await _storage.write(key: 'auth_token', value: _token);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = data['message'] ?? 'Login failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Network error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  //user logout
  Future<void> logout() async {
    _token = null;
    _currentUser = null;
    await _storage.delete(key: 'auth_token');
    notifyListeners();
  }

  //for auto login
  Future<void> loadToken() async {
    _token = await _storage.read(key: 'auth_token');
    notifyListeners();
  }
}
