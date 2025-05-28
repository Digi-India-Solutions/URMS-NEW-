// lib/constants/api_constants.dart

class ApiConstants {
  static const String baseUrl = 'https://api.zaikanuts.shop/api';

  // Auth
  static const String login = '$baseUrl/login-field-excutive';

  // Field Executive APIs
  static const String getAllFields = '$baseUrl/get-all-field';
  static const String getFieldById = '$baseUrl/get-field';
  static const String createField = '$baseUrl/create-field';

  // Task APIs
  static const String getAllTasks = '$baseUrl/get-all-task';
  static const String createTask = '$baseUrl/create-task';
  static const String updateTask = '$baseUrl/update-task';
  static const String deleteTask = '$baseUrl/delete-task';

  // Office APIs
  static const String getAllOffices = '$baseUrl/get-all-offices';
  static const String createOffice = '$baseUrl/create-office';
  static const String deleteOffice = '$baseUrl/delete-office';
}
