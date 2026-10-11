
class Session {
  Session._();

  static int? userId;

  static bool get isLoggedIn => userId != null;

  static void clear() => userId = null;
}
