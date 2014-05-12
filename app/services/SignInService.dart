import 'package:angular/angular.dart';
import 'dart:async';
import 'dart:convert';
import '../FrontendModule.dart';
import 'package:crypto/crypto.dart';

@NgInjectableService()
class SignInService {
  final Http _http;

  SignInService(this._http);

  Future signIn(String email, String password, bool longLife) {
    return _http.post(FrontendModule.API_HOST + '/sessions', JSON.encode({'email': email, 'longLife': longLife}))
    .then((HttpResponse response) {
      if (response.status == 200) {
        var passwordHmac = new HMAC(new SHA1(), password.codeUnits);
        passwordHmac.add(email.codeUnits);
        var passwordHash = CryptoUtils.bytesToHex(passwordHmac.close());

        var tokenHmac = new HMAC(new SHA1(), passwordHash.codeUnits);
        tokenHmac.add(response.data['token'].codeUnits);

        var credential = CryptoUtils.bytesToHex(tokenHmac.close());
        return _http.put(FrontendModule.API_HOST + '/sessions', JSON.encode({'credential': credential}), headers: {'X-Session-Id': response.data['id']});
      }
    })
    .catchError((error) {
      print('Could not read data from the JSON file: $error');
    });
  }
}