part of app;

@Controller(selector: '[wish]', publishAs: 'ctrl')
class WishController {
  WishesResource _wishesResource;
  final SongsResource _songResource;
  MessageService _messageService;
  RouteProvider _routeProvider;
  Router _router;

  Wish wish;
  bool create;

  Set songs = [];
  String _searchByName = '';
  String _searchByInterpret = '';
  String get searchByName => _searchByName;
  String get searchByInterpret => _searchByInterpret;

  set searchByName(String search) {
    _searchByName = search;
    _songResource.readAll(search).then(_processSongs);
  }

  set searchByInterpret(String search) {
    _searchByInterpret = search;
    _songResource.readAll(search).then(_processSongs);
  }

  _processSongs(Set<Song> songs) {
    var add = true;
    songs.forEach((Song song) {
      this.songs.forEach((Song songInSet) {
        if (song.id == songInSet.id) {
          add = false;
        }
      });
      if (add) {
        this.songs.add(song);
      }
    });
  }


  WishController(this._wishesResource, this._songResource, this._messageService, this._routeProvider, this._router) {
    create = !_routeProvider.parameters.containsKey('id');
    if(create) {
      this.wish = new Wish();
    }
    else {
      _wishesResource.read(_routeProvider.parameters['id']).then((Wish wish) {
        this.wish = new Wish(id: wish.id, name: wish.name, interpret: wish.interpret, note: wish.note, created: wish.created, modified: wish.modified);
        refresh();
      });
    }
  }

  void save() {
    if (create) {
      _wishesResource.create(wish).then((_){
        _messageService.prepareSuccess('Vytvořeno.', 'Nové přání bylo úspěšně vytvořeno.');
        _router.go('wish.view', {'id': wish.id});
      });
    }
    else {
      _wishesResource.edit(wish).then((_){
        _messageService.prepareSuccess('Uloženo.', 'Přání bylo úspěšně uloženo.');
        _router.go('wish.view', {'id': wish.id});
      });
    }
  }

  void refresh() {
    this.songs.clear();
    this.searchByName = wish.name;
    this.searchByInterpret = wish.interpret;
  }
}