part of app;

@Controller(selector: '[songbook]', publishAs: 'ctrl')
class SongbookController {
  final SongbooksResource _songbooksResource;
  final UserResource _userResource;
  final MessageService _messageService;
  final SessionService _sessionService;
  final RouteProvider _routeProvider;
  final Router _router;

  Songbook songbook;
  User user;
  bool create;

  String targetUser = '';

  SongbookController(this._sessionService, this._songbooksResource, this._userResource, this._messageService, this._routeProvider, this._router) {
    create = !_routeProvider.parameters.containsKey('id');

      querySelector('html').classes.add('wait');
      if (_sessionService.session == null) {  // analogicky u dalších controllerů
        _sessionService.initialized.then((_) {
          _initialize();
        });
      } else {
        _initialize();
      }
  }

  _initialize(){
    if(_sessionService.session != null) {
      User currentUser = _sessionService.session.user;
      this.user = new User(currentUser.id, currentUser.username, currentUser.email, currentUser.role, currentUser.lastLogin);
    }

    if(create) {
      this.songbook = new Songbook('','', public: false);
      querySelector('html').classes.remove('wait');
    }
    else {
      _songbooksResource.read(_routeProvider.parameters['id']).then((Songbook songbook) {
        this.songbook = songbook;
        querySelector('html').classes.remove('wait');
      });
    }
  }

  void addTags(){
    _songbooksResource.update(songbook, 'tags').then((_) {
      _messageService.prepareSuccess('Uloženo.', 'Tagy byly ke zpěvníku úspěšně přidány.');
      _router.go('songbook.view', {'id': songbook.id});
    });
  }

  void save() {
    if (create) {
      _songbooksResource.create(songbook).then((_){
        _messageService.prepareSuccess('Vytvořeno.', 'Nový zpěvník byl úspěšně vytvořen.');
        _router.go('songbook.view', {'id': songbook.id});
      });
    }
    else {
      _songbooksResource.update(songbook).then((_){
        _messageService.prepareSuccess('Uloženo.', 'Zpěvník byl úspěšně uložen.');
        _router.go('songbook.view', {'id': songbook.id});
      });
    }
  }

  void share(){
    _userResource.read(targetUser).then((User user){
      _songbooksResource.shareSongbook(songbook.id, user.id).then((_) {
        _messageService.showSuccess('Uloženo.', 'Zpěvník byl úspěšně nasdílen.');
      }).catchError((ApiError e) {
        switch (e.error) {
          case 'DUPLICATE_SHARING':
            _messageService.showError('Opakované sdílení.', 'S tímto uživatelem zpěvník ' + songbook.name + ' již sdílíte.');
            break;
        }
      });
    }).catchError((ApiError e) {
      switch (e.error) {
        case 'UNKNOWN_IDENTIFIER':
          _messageService.showError('Neznámý uživatel.', 'Bohužel neznáme žádného uživatele, který by měl zadané uživatelské jméno.');
          break;
      }
    });
  }

  void delete(){
    _songbooksResource.delete(songbook).then((_){
      _messageService.prepareSuccess('Smazáno.', 'Zpěvník byl úspěšně smazán.');
      _router.go('songbooks', {});
    });
  }
}