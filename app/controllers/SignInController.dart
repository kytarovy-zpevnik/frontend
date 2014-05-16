import 'package:angular/angular.dart';
import '../services/SignInService.dart';
import 'dart:async';

@NgController(selector: '[sign-in]', publishAs: 'ctrl')
class SignInController {
  final SignInService _signInService;
  final Router _router;

  String email;
  String password;
  bool longLife;
  List messages = [];

  SignInController(this._signInService, this._router);

  void signIn() {
    Future signIn = _signInService.signIn(email, password, longLife);

    signIn.then((HttpResponse) {
      addMessage('success', 'Přihlášení proběhlo úspěšně.');
      _router.go('homepage', {});
    });
  }

  void addMessage(String type, String text) {
    messages.add({'type': type, 'text': text});
  }
}