part of app;

@Controller(selector: '[register]', publishAs: 'ctrl')
class RegisterController {
  final SessionService _sessionService;
  final Router _router;
  final MessageService _messageService;
  final UserResource _userResource;

  String username;
  String email;
  String password;
  String passwordCheck;
  bool loaded = false;

  RegisterController(this._sessionService, this._router, this._messageService, this._userResource){
    _sessionService.checkSession().then((_) {
      if(_sessionService.session != null)
        _router.go('homepage', {});
      else {
        loaded = true;
        querySelector('html').classes.remove('wait');
      }
    });
  }

  void register() {
    if(password != passwordCheck){
      _messageService.showError('Překlep.', 'Zadaná hesla se neshodují.');
      password = passwordCheck = '';
    }
    else {
      _userResource.create(username, email, password).then((_) {
        _messageService.prepareSuccess('Zaregistrován.', 'Registrace nového uživatele byla úspěšná, nyní se můžete přihlásit.');
        _router.go('homepage', {
        });
      }).catchError((ApiError e) {
        switch (e.error) {
          case 'DUPLICATE_USERNAME':
            _messageService.showError('Uživatelské jméno obsazeno.', 'Uživatel se zadaným uživatelským jménem je již registrován.');
            break;

          case 'DUPLICATE_EMAIL':
            _messageService.showError('Email zaregistrován.', 'Uživatel se zadaným emailem je již registrován.');
            break;
        }
      });
    }
  }
}