part of app;

@Controller(selector: '[sign-in]', publishAs: 'ctrl')
class SignInController {
  final SessionService _sessionService;
  final Router _router;
  final MessageService _messageService;
  final NotificationService _notificationService;

  String identifier;
  String password;
  bool longLife = false;
  bool loaded = false;

  SignInController(this._sessionService, this._router, this._messageService, this._notificationService){
    _sessionService.checkSession().then((_) {
      if(_sessionService.session != null)
        _router.go('homepage', {});
      else {
        loaded = true;
        querySelector('html').classes.remove('wait');
      }
    });
  }

  void signIn() {
    _sessionService.establish(identifier, password, longLife).then((_) {
      _notificationService.loadNotifications();
      _messageService.prepareSuccess('Přihlášen.', 'Přihlášení proběhlo úspěšně.');
      _router.go('homepage', {});
    }).catchError((ApiError e) {
      switch (e.error) {
        case 'UNKNOWN_IDENTIFIER':
          _messageService.showError('Neznámý uživatel.', 'Bohužel neznáme žádného uživatele, který by měl zadaný email nebo uživatelské jméno.');
          break;

        case 'INVALID_CREDENTIAL':
          _messageService.showError('Chybné heslo.', 'Zkuste to prosím znovu.');
        break;
      }
    });
  }
}