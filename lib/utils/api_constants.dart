/// Static variables for all urls used in the app
class ApiConstants {
  static String baseUrl = "http://127.0.0.1:3000/api/v1/";
  static String imageBaseaseUrl = "http://192.168.10.65:3000/public/";
  static String loginUrl = baseUrl + "users/login";
  static String signupUrl = baseUrl + "users/signup";
  static String forgotPassword = baseUrl + "users/forgotPassword";
  static String changePassword = baseUrl + "users/verifyCode";
  static String createTransaction = baseUrl + "expense/create";
  static String getTransaction = baseUrl + "expense/";
  static String createBudget = baseUrl + "budget/create";
  static String getBudgets = baseUrl + "budget";
}
