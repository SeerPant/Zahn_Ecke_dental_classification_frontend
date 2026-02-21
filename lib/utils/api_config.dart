// API configuration and endpoints
// hitting through: src/route/auth/auth.route.js

class ApiConfig {
  static const String baseUrl = 'http://10.0.2.2:3000';
  //hitting register
  static const String register = '$baseUrl/api/auth/register';
  //hitting login
  static const String login = '$baseUrl/api/auth/login';
  //fetching profile
  static const String profile = '$baseUrl/api/auth/profile';
}
