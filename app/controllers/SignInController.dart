import 'package:angular/angular.dart';
import '../services/SignInService.dart';
import 'dart:async';

@NgController(selector: '[sign-in]', publishAs: 'ctrl')
class SignInController {
  final SignInService _signInService;

  String email;
  String password;
  bool longLife;
  List messages = [];

  SignInController(this._signInService);

  void signIn() {
    Future signIn = _signInService.signIn(email, password, longLife);

    signIn.then((HttpResponse) {
      addMessage('success', 'Přihlášení proběhlo úspěšně.');
    });
  }

  void addMessage(String type, String text) {
    messages.add({'type': type, 'text': text});
  }
}