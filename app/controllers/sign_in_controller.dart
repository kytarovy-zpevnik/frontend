part of app;

@Controller(selector: '[sign-in]', publishAs: 'ctrl')
class SignInController {
  final SessionService _sessionService;
  final Router _router;
  final MessageService _messageService;

  String identifier;
  String password;
  bool longLife = false;

  SignInController(this._sessionService, this._router, this._messageService);

  void signIn() {
    _sessionService.establish(identifier, password, longLife).then((_) {
      _messageService.addSuccess('Přihlášen.', 'Přihlášení proběhlo úspěšně.');
      _router.go('homepage', {});
    }).catchError((ApiError e) {
      switch (e.error) {
        case 'UNKNOWN_IDENTIFIER':
          _messageService.addError('Neznámý uživatel.', 'Bohužel neznáme žádného uživatele, který by měl zadaný email nebo uživatelské jméno.');
          break;

        case 'INVALID_CREDENTIAL':
          _messageService.addError('Chybné heslo.', 'Zkuste to prosím znovu.');
        break;
      }
    });
  }
}