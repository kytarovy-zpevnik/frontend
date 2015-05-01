part of app;

@Controller(selector: '[songbook]', publishAs: 'ctrl')
class SongbookController {
  SongbooksResource _songbooksResource;
  MessageService _messageService;
  final SessionService _sessionService;
  RouteProvider _routeProvider;
  Router _router;

  Songbook songbook;
  User user;
  bool create;

  SongbookController(this._sessionService, this._songbooksResource, this._messageService, this._routeProvider, this._router) {

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
    User currentUser = _sessionService.session.user;
    this.user = new User(currentUser.id, currentUser.username, currentUser.email, currentUser.role, currentUser.lastLogin);
    if(create) {
      this.songbook = new Songbook('','','', public: false);
      querySelector('html').classes.remove('wait');
    }
    else {
      _songbooksResource.read(_routeProvider.parameters['id']).then((Songbook songbook) {
        List songs = [];
        List row;
        var index = 0;

        this.songbook = songbook;
        songbook.songs.forEach((Song song) {
          if (index % 4 == 0) {
            row = [];
            row.add(song);
            songs.add(row);
          }
          else {
            row.add(song);
          }
          index++;
        });
        this.songbook.songs = songs;
        querySelector('html').classes.remove('wait');

      });
    }
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

  void delete(){
    _songbooksResource.delete(songbook).then((_){
      _messageService.prepareSuccess('Smazáno.', 'Zpěvník byl úspěšně smazán.');
      _router.go('songbooks', {});
    });
  }
}