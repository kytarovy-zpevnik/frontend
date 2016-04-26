part of app;

@Controller(selector: '[songs]', publishAs: 'ctrl')
class SongsController {

  final SongsResource _songsResource;
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

  bool existsNext = true;
  String sort = 'title';
  bool revert = false;

  set search(String search) {
    _search = search;
    _filterSongs();
  }

  /*toggleAdvSearch() {
    advSearchVisible = !(advSearchVisible);
  }

  advSearch() {
    _songResource.readAll(filters: filters).then(_processSongs);
  }*/

  SongsController(this._sessionService, this._songsResource, this._songbooksResource, this._messageService, this._userResource, this._routeProvider) {
    querySelector('html').classes.add('wait');
    if (_sessionService.session == null) {
      _sessionService.initialized.then((_) {
        _initialize();
      });
    } else {
      _initialize();
    }
  }

  _initialize(){
    this.songs.clear();
    this.visibleSongs.clear();
    var user = _sessionService.session.user;

    loadSongs().then((_){
      if (_routeProvider.parameters.containsKey('songbookId')) {
        querySelector('html').classes.add('wait');
        _songbooksResource.read(_routeProvider.parameters['songbookId']).then((Songbook songbook) {
          this.songbook = songbook;
          loaded = true;
          querySelector('html').classes.remove('wait');
        });
      }
      else {
        loaded = true;
      }
    });
  }

  Future loadSongs() {
    querySelector('html').classes.add('wait');
    return _songsResource.readAll(songs.length, sort, revert ? 'desc' : 'asc').then((List<Song> songs) {
      _processSongs(songs);
      if(songs.length != 20)
        existsNext = false;
      querySelector('html').classes.remove('wait');
      return new Future.value(null);
    });
  }

  void sortBy(String sort) {
    if(this.sort == sort)
      revert = !revert;
    else {
      this.sort = sort;
      revert = false;
    }
    this.songs.clear();
    this.visibleSongs.clear();
    existsNext = true;
    loadSongs();
  }

  _processSongs(List<Song> songs) {
    songs.forEach((Song song) {
      this.songs.add(song);
      this.visibleSongs.add(song);
    });
  }

  _filterSongs() {
    this.visibleSongs.clear();
    this.songs.forEach((Song song){
      if(song.contains(_search))
        visibleSongs.add(song);
    });
  }

  void addToSongbook(Song song) {
    songbook.songs.add(song);
  }

  void removeFromSongbook(Song song) {

    var toRemove;
    songbook.songs.forEach((songbooksong) {
      if (songbooksong.id == song.id) {
        toRemove = songbooksong;
      }
    });
    songbook.songs.remove(toRemove);
  }

  void saveSongbook(){
    _songbooksResource.update(songbook).then((_){
      _messageService.showSuccess("Aktualizován", "Seznam písní ve zpěvníku byl úspěšně aktualizován.");
    });
  }

}
