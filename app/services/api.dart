part of app;

/**
 * Provides interface to querying api resources.
 */
@Injectable()
class Api {
  static const HTTP_OK = 200;
  static const HTTP_FORBIDDEN = 304;

  final Http _http;
  final ApiHost _apiHost;
  final SessionToken _sessionToken;
  final Router _router;
  final MessageService _messageService;

  Api(this._http, this._apiHost, this._sessionToken, this._router, this._messageService);

  /**
   * Sends a http get request to given resource.
   */
  Future get(String resource, {
    Map<String, dynamic> params, Map<String, dynamic> headers
  }) => _http.get(_getResourceUrl(resource), params: params, headers: _addSessionTokenHeader(headers)).then(_success).catchError(_error);

  /**
   * Sends a http post request to given resource.
   */
  Future post(String resource, {
    Map<String, dynamic> data, Map<String, dynamic> params, Map<String, dynamic> headers
  }) => _http.post(_getResourceUrl(resource), JSON.encode(data), params: params, headers: _addSessionTokenHeader(headers)).then(_success).catchError(_error);

  /**
   * Sends a http put request to given resource.
   */
  Future put(String resource, {
  Map<String, dynamic> data, Map<String, dynamic> params, Map<String, dynamic> headers
  }) => _http.put(_getResourceUrl(resource), JSON.encode(data), params: params, headers: _addSessionTokenHeader(headers)).then(_success).catchError(_error);

  /**
   * Sends a http delete request to given resource.
   */
  Future delete(String resource, {
    Map<String, dynamic> data, Map<String, dynamic> params, Map<String, dynamic> headers
  }) => _http.delete(_getResourceUrl(resource), data: JSON.encode(data), params: params, headers: _addSessionTokenHeader(headers)).then(_success).catchError(_error);

  /**
   * Returns resource's url.
   */
  String _getResourceUrl(String resource) => _apiHost.apiHost + '/' + resource;

  /**
   * Adds session token to headers.
   */
  Map<String, dynamic> _addSessionTokenHeader(Map<String, dynamic> headers) {
    if (headers == null) {
      headers = {};
    }

    if (_sessionToken.sessionToken != null) {
      headers['X-Session-Token'] = _sessionToken.sessionToken;
    }
    return headers;
  }

  /**
   * Converts response body to JSON.
   */
  Future<HttpResponse> _success(HttpResponse response)
    => new Future.value(response);

  /**
   * Returns error object.
   */
  Future<ServerError> _error(HttpResponse response) {
    if (response.status == 401) {
      _messageService.addInfo('Nepřihlášen.', 'Přihlaste se prosím a opakujte akci znovu.');
      _router.go('sign', {});
      return null;

    } else if (response.data.length == 0) {
      return new Future.error(new ServerError(response.status));

    } else {
      var data = JSON.decode(response.data);
      return new Future.error(new ApiError(data['error'], data['message'], response.status));
    }
  }
}
