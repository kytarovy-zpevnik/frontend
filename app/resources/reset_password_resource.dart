part of app;

@Injectable()
class ResetPasswordResource{
  final Api _api;

  ResetPasswordResource(this._api);

  /**
   * Reset user's password.
   */
  Future reset(String indentifier) {
    return _api.post('passwordreset', data:{
      'user': {"identifier": indentifier}
    }).then((_) {
      return new Future.value();
    });
  }

  /**
   * Sets new user's password.
   */
  Future setNewPassword(String token, String password) {
    return _api.put('users?token=' + token, data: {
      'password': password
    }).then((HttpResponse response) {

    });
  }
}