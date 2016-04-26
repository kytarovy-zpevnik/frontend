part of app;

@Controller(selector: '[songbooks]', publishAs: 'ctrl')
class SongbooksController {

  final SongbooksResource _songbooksResource;
  final MessageService _messageService;
  SessionService _sessionService;
  final UserResource _userResource;

  List songbooks = [];
  List visibleSongbooks = [];

  String _search = '';

  String get search => _search;

  bool loaded = false;

  bool existsNext = true;
  String sort = 'name';
  bool revert = false;

  set search(String search) {
    _search = search;
    _filterSongbooks();
  }

  SongbooksController(this._sessionService, this._songbooksResource, this._messageService, this._userResource) {
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
    this.songbooks.clear();
    this.visibleSongbooks.clear();
    var user = _sessionService.session.user;

    loadSongbooks().then((_){
      loaded = true;
    });

  }

  Future loadSongbooks() {
    querySelector('html').classes.add('wait');
    return _songbooksResource.readAll(songbooks.length, sort, revert ? 'desc' : 'asc').then((List<Songbook> songbooks) {
      _processSongbooks(songbooks);
      if(songbooks.length != 20)
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
    this.songbooks.clear();
    this.visibleSongbooks.clear();
    existsNext = true;
    loadSongbooks();
  }

  void _processSongbooks(List<Songbook> songbooks) {
    songbooks.forEach((Songbook songbook) {
      this.songbooks.add(songbook);
      this.visibleSongbooks.add(songbook);
    });
  }

  _filterSongbooks(){
    this.visibleSongbooks.clear();
    this.songbooks.forEach((Songbook songbook){
      if(songbook.contains(_search))
        visibleSongbooks.add(songbook);
    });
  }

}