//Authentication service for API calls
//Backend service: src/service/auth.service.js
//Backend controller: src/controller/auth/auth.controller.js

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';
import '../utils/api_config.dart';

class AuthService extends ChangeNotifier {
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
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    //POSt request
    try {
      final response = await http
          .post(
        Uri.parse(ApiConfig.register),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          if (name != null) 'name': name,
        }),
      )
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Connection timeout');
        },
      );

      dynamic data;
      try {
        data = json.decode(response.body);
      } catch (e) {
        _errorMessage = 'Server error. Please try again later.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (response.statusCode == 201 && data['success']) {
        _token = data['data']['token'];
        _currentUser = User.fromJson(data['data']['user']);

        await _storage.write(key: 'auth_token', value: _token);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = data['message'] ?? 'Registration failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Network error: Unable to connect to server';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  //login user
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http
          .post(
        Uri.parse(ApiConfig.login),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      )
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Connection timeout');
        },
      );

      dynamic data;
      try {
        data = json.decode(response.body);
      } catch (e) {
        _errorMessage = 'Please re-enter your email or password';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (response.statusCode == 200 && data['success']) {
        _token = data['data']['token'];
        _currentUser = User.fromJson(data['data']['user']);

        await _storage.write(key: 'auth_token', value: _token);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        //error handling
        if (response.statusCode == 401 || response.statusCode == 400) {
          _errorMessage = 'Please reenter your email or password';
        } else {
          _errorMessage =
              data['message'] ?? 'Please reenter your email or password';
        }
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Please reenter your email or password';
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

  //load saved token for auto-login
  Future<void> loadToken() async {
    _token = await _storage.read(key: 'auth_token');
    notifyListeners();
  }
}
