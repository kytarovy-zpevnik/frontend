part of app;

@Injectable()
class SessionService {
  final SessionResource _sessionResource;
  final SessionToken _sessionToken;
  Completer _completer = new Completer();

  Future get initialized => _completer.future;

  Session _session;

  SessionService(this._sessionResource, this._sessionToken) {
    if (_sessionToken.sessionToken != null) {
      _sessionResource.get(_sessionToken.sessionToken).then((Session session) {
        _session = session;
        _completer.complete();
      }).catchError((ApiError error) {
        if (error.code == 400)
          _completer.complete();
        });
    }
  }

  Session get session => _session;

  /**
   * Establishes new session.
   */
  Future establish(String identifier, String password, bool longLife) {
    if (_session != null) {
      throw new StateError('Session already established.');
    }

    return _sessionResource.create(identifier, password, longLife).then((Session session) {
      _session = session;
      _sessionToken.sessionToken = session.token;
      return new Future.value();
    });
  }

  /**
   * Terminates current session.
   */
  Future terminate() {
    if (_session == null) {
      throw new StateError('No active session to terminate.');
    }

    return _sessionResource.deleteActive(_session).then((_) {
      _session = null;
      return new Future.value();
    });
  }
}
