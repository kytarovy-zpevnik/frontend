part of app;

@Controller(selector: '[songbooks]', publishAs: 'ctrl')
class SongbooksController {

  final SongbooksResource _songbookResource;
  final MessageService _messageService;
  SessionService _sessionService;
  final UserResource _userResource;

  List songbooks = [];

  List sharedSongbooks = [];

  String _search = '';

  String get search => _search;

  set search(String search) {
    _songbookResource.readAll(search).then(_processSongbooks);
  }

  SongbooksController(this._sessionService, this._songbookResource, this._messageService, this._userResource) {
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
    _songbookResource.readAll().then(_processSongbooks);
    var user = _sessionService.session.user;
    _userResource.readAllSharedSongbooks(user.id).then((List<Songbook> songbooks){
      _processSharedSongbooks(songbooks);
      querySelector('html').classes.remove('wait');
    });
  }

  void _processSongbooks(List<Songbook> songbooks) {
    this.songbooks.clear();
    songbooks.forEach((Songbook songbook) {
      this.songbooks.add(songbook);
    });
  }

  void _processSharedSongbooks(List<Songbook> songbooks) {
    this.sharedSongbooks.clear();
    songbooks.forEach((Songbook songbook) {
      this.sharedSongbooks.add(songbook);
    });
  }

}