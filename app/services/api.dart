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

  Api(this._http, this._apiHost);

  /**
   * Sends a http get request to given resource.
   */
  Future get(String resource, {
    Map<String, dynamic> params, Map<String, dynamic> headers
  }) => _http.get(_getResourceUrl(resource), params: params, headers: headers).then(onResponse).catchError(onResponse);

  /**
   * Sends a http post request to given resource.
   */
  Future post(String resource, {
    Map<String, dynamic> data, Map<String, dynamic> params, Map<String, dynamic> headers
  }) => _http.post(_getResourceUrl(resource), JSON.encode(data), params: params, headers: headers).then(onResponse).catchError(onResponse);

  /**
   * Sends a http put request to given resource.
   */
  Future put(String resource, {
  Map<String, dynamic> data, Map<String, dynamic> params, Map<String, dynamic> headers
  }) => _http.put(_getResourceUrl(resource), JSON.encode(data), params: params, headers: headers).then(onResponse).catchError(onResponse);

  /**
   * Sends a http delete request to given resource.
   */
  Future delete(String resource, {
    Map<String, dynamic> data, Map<String, dynamic> params, Map<String, dynamic> headers
  }) => _http.delete(_getResourceUrl(resource), data: JSON.encode(data), params: params, headers: headers).then(onResponse).catchError(onResponse);

  /**
   * Returns resource's url.
   */
  String _getResourceUrl(String resource) => _apiHost.apiHost + '/' + resource;

  /**
   * Checks response status code, throws an exception if other than 2xx sent.
   */
  Future<HttpResponse> onResponse(HttpResponse response) {
    if (response.status >= 200 && response.status < 300) {
      return new Future.value(response);
    } else {
      if (response.data['error']) {
        return new Future.error(new ApiException(response.data['error'], response.data['message'], response.status));
      } else {
        return new Future.error(new ServerException(response.status));
      }
    }
  }
}

/**
 * Thrown when response code is other than 2xx and api does not supply error.
 */
class ServerException {
  final int code;

  ServerException(this.code);

  String toString() => 'ServerException: received HTTP status code ${code.toString()}.';
}

/**
 * Thrown when api returns error.
 */
class ApiException extends ServerException {
  final String error;
  final String message;

  ApiException(this.error, this.message, code): super(code);

  String toString() => 'ApiException: received api error $error with message "$message", HTTP status code ${code.toString()}.';
}
