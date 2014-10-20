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
      _messageService.addSuccess('Uspech', 'Zaslali jsme ti na email odkaz pro obnoveni hesla.');
    }).catchError((ApiError e){
      switch(e.error) {
        case 'UNKNOWN_IDENTIFIER':
          _messageService.addError('Neuspech', 'Uzivatel ' + identifier + 'nenalezen');
          break;

        case 'ALREADY_SENT':
          _messageService.addError('Neuspech', 'Uz bylo odeslano');
          break;
      }
    });
  }

  void setNewPassword() {
    String token = _routeProvider.parameters['token'];
    if(password == passwordCheck) {
      _resetPasswordResource.setNewPassword(token, password).then((_) {
        _messageService.addSuccess('Uspech', 'Heslo zmemeno');
      });
    }
    else {
      _messageService.addError('Hesla nesedi', 'Heslo pro kontrolu neodpovida prvnimu heslu');
      password = passwordCheck = '';
    }
  }
}