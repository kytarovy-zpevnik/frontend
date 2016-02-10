part of app;

@Injectable()
class UserResource {
  final Api _api;

  UserResource(this._api);

  /**
   * Creates new user.
   */
  Future<User> create(String username, String email, String password) {
    return _api.post('users', data: {
      'username': username,
      'email': email,
      'password': password
    }).then((HttpResponse response) {
      var role = new Role(response.data['role']['id'], response.data['role']['slug'], response.data['role']['name']);
      var user = new User(response.data['id'], response.data['username'], response.data['email'], role, response.data['lastLogin']);
      return new Future.value(user);
    });
  }

  /**
   * Reads all users.
   */
  Future<List<User>> readAll() {
    return _api.get('users').then((HttpResponse response) {
      var users = response.data.map((data) {
        var role = new Role(data['role']['id'], data['role']['slug'], data['role']['name']);
        var user = new User(data['id'], data['username'], data['email'], role, DateTime.parse(data['lastLogin']));
        return user;
      });

      return new Future.value(users);
    });
  }

  /**
   * Updates user.
   */
  Future update(User user) {
    return _api.put('users/' + user.id.toString(), data: {
      'role': {
        'slug': user.role.slug
      }
    }).then((HttpResponse response) {
      user.role.id   = response.data['role']['id'];
      user.role.slug = response.data['role']['slug'];
      user.role.name = response.data['role']['name'];
      return new Future.value(user);
    });
  }

  /**
   * Reads user by username.
   */
  Future<User> read(String userName) {
    return _api.get('users?username=' + userName).then((HttpResponse response) {
      var role = new Role(response.data['role']['id'], response.data['role']['slug'], response.data['role']['name']);
      return new User(response.data['id'], response.data['username'], response.data['email'], role, response.data['lastLogin']);
    });
  }

}


