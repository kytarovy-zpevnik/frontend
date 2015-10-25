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
        var user = new User(data['id'], data['username'], data['email'], role, data['lastLogin']);
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

  /**
   * Reads all shared songbooks.
   */
  Future<List<Songbook>> readAllSharedSongbooks(int userId) {
    return _api.get('users/' + userId.toString() + '/sharing?subject=songbook').then((HttpResponse response) {
      var songbooks = response.data.map((data) {
        var tags = [];
        for (int i = 0; i < data['tags'].length; i++) {
          tags.add(new SongbookTag(data['tags'][i]['tag'], data['tags'][i]['public']));
        }
        return new Songbook(data['id'], data['name'], note: data['note'], public: data['public'], username: data['username'], tags: tags, numberOfSongs: data['songs']);
      });

      return new Future.value(songbooks);
    });
  }

  /**
   * Reads all shared songs.
   */
  Future<List<Song>> readAllSharedSongs(int userId) {
    return _api.get('users/' + userId.toString() + '/sharing?subject=song').then((HttpResponse response) {
      var songs = response.data.map((data) {
        var tags = [];
        for (var i = 0; i < data['tags'].length; i++) {
          tags.add(new SongTag(data['tags'][i]['tag'], data['tags'][i]['public']));
        }
        return new Song(data['title'], data['album'], data['author'], data['year'], data['public'], id: data['id'], username: data['username'], tags: tags);
      });

      return new Future.value(songs);
    });
  }

}


