part of app;

@Injectable()
class SessionResource {
  final Api _api;

  SessionResource(this._api);

  /**
   * Creates new session.
   */
  Future<Session> create(String identifier, String password, bool longLife) {
    return _api.post('sessions', data: {
        'user': {
            'identifier': identifier,
            'password': password
        },
        'longLife': longLife
    }).then((HttpResponse response) {
      var role = new Role(response.data['user']['role']['id'], response.data['user']['role']['slug'], response.data['user']['role']['name']);
      var user = new User(response.data['user']['id'], response.data['user']['username'], response.data['user']['email'], role, response.data['user']['lastLogin']);
      return new Future.value(new Session(response.data['token'], longLife, user));
    });
  }

  /**
   * Deletes given session.
   */
  Future deleteActive(Session session) {
    return _api.delete('sessions/active').then((_) {
      return new Future.value();
    });
  }
}
