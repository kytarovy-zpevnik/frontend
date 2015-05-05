part of app;

@Controller(selector: '[songs]', publishAs: 'ctrl')
class SongsController {

  final SongsResource _songResource;
  final MessageService _messageService;
  SessionService _sessionService;
  final UserResource _userResource;

  List songs = [];
  List visibleSongs = [];
  String _search = '';
  String get search => _search;
  bool advSearchVisible = false;
  Map<String, String> filters = {};

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

  SongsController(this._sessionService, this._songResource, this._messageService, this._userResource) {
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
    _songResource.readAll().then(_processSongs);
    var user = _sessionService.session.user;
    _userResource.readAllSharedSongs(user.id).then((List<Song> songs){
      _processSharedSongs(songs);
      querySelector('html').classes.remove('wait');
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

}
