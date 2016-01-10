part of app;

@Controller(selector: '[songbooks]', publishAs: 'ctrl')
class SongbooksController {

  final SongbooksResource _songbookResource;
  final MessageService _messageService;
  SessionService _sessionService;
  final UserResource _userResource;

  List songbooks = [];
  List visibleSongbooks = [];

  String _search = '';

  String get search => _search;

  set search(String search) {
    _search = search;
    //_songbookResource.readAll(search).then(_processSongbooks);
    _filterSongbooks();
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
    this.songbooks.clear();
    this.visibleSongbooks.clear();
    var user = _sessionService.session.user;

    /* Až bude hotovo přebírání zpěvníků
    Future.wait([_songbookResource.readAll().then(_processSongbooks), // analogicky u dalších
    _userResource.readAllSharedSongbooks(user.id).then(_processSongbooks)]
    ).then((List<Future> futures)*/
    _songbookResource.readAll().then((List<Songbook> songbooks){
      _processSongbooks(songbooks);
      querySelector('html').classes.remove('wait');
    });
  }

  void _processSongbooks(List<Songbook> songbooks) {
    songbooks.forEach((Songbook songbook) {
      this.songbooks.add(songbook);
      this.visibleSongbooks.add(songbook);
    });
  }

  /* Až bude hotovo přebírání zpěvníků
  void _processSharedSongbooks(List<Songbook> songbooks) {
    songbooks.forEach((Songbook songbook) {
      this.songbooks.add(songbook);
      this.visibleSongbooks.add(songbook);
    });
  }*/

  _filterSongbooks(){
    this.visibleSongbooks.clear();
    this.songbooks.forEach((Songbook songbook){
      if(songbook.contains(_search))
        visibleSongbooks.add(songbook);
    });
  }

}