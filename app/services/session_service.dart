part of app;

@Injectable()
class SessionService {
  final SessionResource _sessionResource;
  Session _session;

  SessionService(this._sessionResource);

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

    return _sessionResource.delete(_session).then((_) {
      _session = null;
      return new Future.value();
    });
  }
}
