part of app;

@Controller(selector: '[wish]', publishAs: 'ctrl')
class WishController {
  WishesResource _wishesResource;
  final SongsResource _songResource;
  MessageService _messageService;
  SessionService _sessionService;
  RouteProvider _routeProvider;
  Router _router;

  Wish wish;
  bool create;
  User user;

  List songs = [];

  var formatter = new DateFormat('d.M.yyyy HH:mm');

  WishController(this._sessionService, this._wishesResource, this._songResource, this._messageService, this._routeProvider, this._router) {
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
    this.songs.clear();

    if(create) {
      this.wish = new Wish();
      querySelector('html').classes.remove('wait');
    }
    else {
      _wishesResource.read(_routeProvider.parameters['id']).then((Wish wish) {
        this.wish = wish;
        if(_routeProvider.routeName == "edit")
          querySelector('html').classes.remove('wait');
        else {
          Map filters = {'title': wish.name, 'author': wish.interpret};
          _songResource.readAll(0, null, null, public: true, filters: filters).then((List<Song> songs){
            _processSongs(songs);
            querySelector('html').classes.remove('wait');
          });
        }
      });
    }
  }

  _processSongs(List<Song> songs) {
    songs.forEach((Song song) {
      if (song.username != this.user.username)
        this.songs.add(song);
    });
  }

  void save() {
    if (create) {
      _wishesResource.create(wish).then((_){
        _messageService.prepareSuccess('Vytvořeno.', 'Nové přání bylo úspěšně vytvořeno.');
        _router.go('wish.view', {'id': wish.id});
      });
    }
    else {
      _wishesResource.update(wish).then((_){
        _messageService.prepareSuccess('Upraveno.', 'Přání bylo úspěšně upraveno.');
        _router.go('wish.view', {'id': wish.id});
      });
    }
  }

  void delete(){
    _wishesResource.delete(wish).then((_){
      _messageService.prepareSuccess('Smazáno.', 'Přání bylo úspěšně smazáno.');
      _router.go('wishes', {});
    });
  }

}