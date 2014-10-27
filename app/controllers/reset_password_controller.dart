part of app;

@Controller(selector: '[reset-password]', publishAs: 'ctrl')
class ResetPasswordController {
  final Router _router;
  final MessageService _messageService;
  final ResetPasswordResource _resetPasswordResource;
  final RouteProvider _routeProvider;
  
  String identifier;
  String password;
  String passwordCheck;
  
  ResetPasswordController(this._router, this._messageService, this._resetPasswordResource, this._routeProvider);
  
  void reset() {
    _resetPasswordResource.reset(identifier).then((_) {
      _messageService.showSuccess('Úspěch.', 'Zaslali jsme Vám email pro nastavení hesla.');
    }).catchError((ApiError e){
      switch(e.error) {
        case 'UNKNOWN_IDENTIFIER':
          _messageService.showError('Nespech.', 'Uživatel ' + identifier + ' nenalezen');
          break;

        case 'ALREADY_SENT':
          _messageService.showError('Neúspěch.', 'V posledních 24 hodinách byl již požadavek na změnu hesla zaslán. Zkuste to prosím později.');
          break;
      }
    });
  }

  void setNewPassword() {
    String token = _routeProvider.parameters['token'];
    if(password == passwordCheck) {
      _resetPasswordResource.setNewPassword(token, password).then((_) {
        _messageService.prepareSuccess('Úspěch.', 'Heslo bylo úspěšně změněno.');
        _router.go('homepage', {});
      }).catchError((ApiError e) {
        if (e.error == 'TOKEN_EXPIRATED') {
          _messageService.showError('Chyba.', 'Platnost tokenu vypršela, zažádejte o obnovu hesla znovu.');
          return new Future.value();
        }
      });
    }
    else {
      _messageService.showError('Překlep.', 'Zadaná hesla se neshodují.');
      password = passwordCheck = '';
    }
  }
}