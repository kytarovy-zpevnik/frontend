part of app;

/**
 * Api host value class.
 */
class ApiHost {
  final String apiHost;
  ApiHost(String this.apiHost);
}

class SessionToken {
  BrowserCookies _browserCookies;

  String _sessionToken;

  SessionToken(this._browserCookies) {
    _sessionToken = _browserCookies['sessionToken'];
  }

  get sessionToken => _sessionToken;

  set sessionToken(sessionToken) {
    _browserCookies['sessionToken'] = _sessionToken = sessionToken;
  }
}
