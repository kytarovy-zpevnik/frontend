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
      var user = new User(response.data['user']['email'], response.data['user']['username']);
      return new Future.value(new Session(response.data['token'], longLife, user));
    });
  }

  /**
   * Deletes given session.
   */
  Future delete(Session session) {
    return _api.delete('sessions', data: {
        'token': session.token,
    }).then((_) {
      return new Future.value();
    });
  }
}
