part of app;

/**
 * Session model.
 */
class Session {
  final String token;
  final bool longLife;
  final User user;

  Session(this.token, this.longLife, this.user);
}
