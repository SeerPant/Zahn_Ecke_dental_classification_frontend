// API configuration and endpoints
// hitting through: src/route/auth/auth.route.js

class ApiConfig {
  static const String baseUrl = 'http://10.0.2.2:3000/api';
  //hitting register
  static const String register = '$baseUrl/auth/register';
  //hitting login
  static const String login = '$baseUrl/auth/login';
  //fetching profile
  static const String profile = '$baseUrl/auth/profile';
}
