part of app;

@Controller(selector: '[sign-in]', publishAs: 'ctrl')
class SignInController {
  final SessionService _sessionService;
  final Router _router;

  List messages = [];

  SignInController(this._sessionService, this._router);

  void signIn(String identifier, String password, bool longLife) {
    _sessionService.establish(identifier, password, longLife).then((_) {
      addMessage('success', 'Přihlášení proběhlo úspěšně.');
      _router.go('homepage', {});
    }).catchError((ServerException e) {
      print(e.toString());
    });
  }

  void addMessage(String type, String text) {
    messages.add({'type': type, 'text': text});
  }
}