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
  }) => _http.get(_getResourceUrl(resource), params: params, headers: headers).then(_success).catchError(_error);

  /**
   * Sends a http post request to given resource.
   */
  Future post(String resource, {
    Map<String, dynamic> data, Map<String, dynamic> params, Map<String, dynamic> headers
  }) => _http.post(_getResourceUrl(resource), JSON.encode(data), params: params, headers: headers).then(_success).catchError(_error);

  /**
   * Sends a http put request to given resource.
   */
  Future put(String resource, {
  Map<String, dynamic> data, Map<String, dynamic> params, Map<String, dynamic> headers
  }) => _http.put(_getResourceUrl(resource), JSON.encode(data), params: params, headers: headers).then(_success).catchError(_error);

  /**
   * Sends a http delete request to given resource.
   */
  Future delete(String resource, {
    Map<String, dynamic> data, Map<String, dynamic> params, Map<String, dynamic> headers
  }) => _http.delete(_getResourceUrl(resource), data: JSON.encode(data), params: params, headers: headers).then(_success).catchError(_error);

  /**
   * Returns resource's url.
   */
  String _getResourceUrl(String resource) => _apiHost.apiHost + '/' + resource;

  /**
   * Converts response body to JSON.
   */
  Future<HttpResponse> _success(HttpResponse response)
    => new Future.value(response);

  /**
   * Returns error object.
   */
  Future<ServerError> _error(HttpResponse response) {
    if (response.data.length == 0) {
      return new Future.error(new ServerError(response.status));
    } else {
      var data = JSON.decode(response.data);
      return new Future.error(new ApiError(data['error'], data['message'], response.status));
    }
  }
}
