part of app;

@Controller(selector: '[public-songbooks]', publishAs: 'ctrl')
class PublicSongbooksController {

  final SongbooksResource _songbookResource;
  final MessageService _messageService;
  SessionService _sessionService;

  List songbooks = [];
  List visibleSongbooks = [];

  String _search = '';

  String get search => _search;

  set search(String search) {
    _search = search;
    //_songbookResource.readAll(searchPublic: _search).then(_processSongbooks);
    _filterSongbooks();
  }

  PublicSongbooksController(this._sessionService, this._songbookResource, this._messageService) {
    querySelector('html').classes.add('wait');
    _songbookResource.readAll(public: true).then((List<Songbook> songbooks){
      _processSongbooks(songbooks);
      querySelector('html').classes.remove('wait');
    });
  }

  void _processSongbooks(List<Songbook> songbooks) {
    this.songbooks.clear();
    this.visibleSongbooks.clear();
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
