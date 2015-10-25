part of app;

@Controller(selector: '[songs]', publishAs: 'ctrl')
class SongsController {

  final SongsResource _songResource;
  final SongbooksResource _songbooksResource;
  final MessageService _messageService;
  SessionService _sessionService;
  final RouteProvider _routeProvider;
  final UserResource _userResource;

  List songs = [];
  List visibleSongs = [];
  String _search = '';
  String get search => _search;
  bool advSearchVisible = false;
  Map<String, String> filters = {};

  bool loaded = false;
  Songbook songbook = null;

  set search(String search) {
    _search = search;
    //_songResource.readAll(search: search).then(_processSongs);
    _filterSongs();
  }

  toggleAdvSearch() {
    advSearchVisible = !(advSearchVisible);
  }

  advSearch() {
    _songResource.readAll(filters: filters).then(_processSongs);
  }

  SongsController(this._sessionService, this._songResource, this._songbooksResource, this._messageService, this._userResource, this._routeProvider) {
    querySelector('html').classes.add('wait');
    if (_sessionService.session == null) {  // analogicky u dalších controllerů
      _sessionService.initialized.then((_) {
        _initialize();
      });
    } else {
      _initialize();
    }
  }

  _initialize(){  // analogicky u dalších controllerů
    this.songs.clear();
    this.visibleSongs.clear();
    var user = _sessionService.session.user;

    /*_songResource.readAll().then(_processSongs);
    _userResource.readAllSharedSongs(user.id).then((List<Song> songs){
      _processSharedSongs(songs);
      querySelector('html').classes.remove('wait');
    });*/
    Future.wait([_songResource.readAll().then(_processSongs), // analogicky u dalších
                _userResource.readAllSharedSongs(user.id).then(_processSharedSongs)]
    ).then((List<Future> futures){
      if (_routeProvider.parameters.containsKey('songbookId')) {
        _songbooksResource.read(_routeProvider.parameters['songbookId']).then((Songbook songbook) {
          this.songbook = songbook;
          loaded = true;
          querySelector('html').classes.remove('wait');
        });
      }
      else {
        loaded = true;
        querySelector('html').classes.remove('wait');
      }
    });
  }

  _processSongs(List<Song> songs) {
    songs.forEach((Song song) {
      this.songs.add(song);
      this.visibleSongs.add(song);
    });
  }

  _processSharedSongs(List<Song> songs) {
    songs.forEach((Song song) {
      this.songs.add(song);
      this.visibleSongs.add(song);
    });
  }

  _filterSongs(){
    this.visibleSongs.clear();
    this.songs.forEach((Song song){
      if(song.contains(_search))
        visibleSongs.add(song);
    });
  }

  void addToSongbook(Song song) {
    songbook.songs.add(song);
    _songbooksResource.update(songbook).then((_){
      _messageService.showSuccess("Přidána", "Písnička byla úspěšně přidána do zpěvníku.");
    });
  }

  void removeFromSongbook(Song song) {

    var toRemove;
    songbook.songs.forEach((songbooksong) {
      if (songbooksong.id == song.id) {
        toRemove = songbooksong;
      }
    });

    songbook.songs.remove(toRemove);
    _songbooksResource.update(songbook).then((_){
      _messageService.showSuccess('Odebrána','Píseň byla úspěšně odebrána ze zpěvníku.');
    });
  }

}
