// API configuration and endpoints
// hitting through: src/route/auth/auth.route.js

class ApiConfig {
  //static const String baseUrl = 'http://192.168.1.66:3000';
  static const String baseUrl = 'http://172.20.10.3:3000';
  //hitting register
  static const String register = '$baseUrl/api/auth/register';
  //hitting login
  static const String login = '$baseUrl/api/auth/login';
  //fetching profile
  static const String profile = '$baseUrl/api/auth/profile';

  //prediction
  static const String predict = '$baseUrl/api/predict';
  //report
  static const String reports = '$baseUrl/api/predict/reports';
  //recommendation
  static const String recommendations = '$baseUrl/api/predict/recommendations';
}
