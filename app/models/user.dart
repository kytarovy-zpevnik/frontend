part of app;

/**
 * User model.
 */
class User {
  final int id;
  final String username;
  final String email;
  final Role role;
  final String lastLogin;

  User(this.id, this.username, this.email, this.role, this.lastLogin);
}
