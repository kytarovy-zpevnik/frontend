part of app;

@Controller(selector: '[public-songbooks]', publishAs: 'ctrl')
class PublicSongbooksController {

  final SongbooksResource _songbookResource;
  final MessageService _messageService;

  List songbooks = [];
  //String _search = '';
  //String get search => _search;
  //bool advSearchVisible = false;
  //Map<String, String> filters = {};
  SessionService _sessionService;

  /*set search(String search) {
    _search = search;
    /*if (_search == '') {
      _songResource.readAll(searchAllPublic: false).then(_processSongs);
    }
    else {
      _songResource.readAll(searchPublic: search).then(_processSongs);
    }*/
    _songResource.readAll(searchPublic: _search).then(_processSongs);
  }*/

  /*toggleAdvSearch() {
    advSearchVisible = !(advSearchVisible);
  }*/

  /*advSearch() {
    _songResource.readAll(filters: filters).then(_processSongs);
  }*/

  PublicSongbooksController(this._sessionService, this._songbookResource, this._messageService) {
    querySelector('html').classes.add('wait');
    _songbookResource.readAll(searchPublic: ' ').then((List<Songbook> songbooks){
      _processSongbooks(songbooks);
      querySelector('html').classes.remove('wait');
    });
  }

  void _processSongbooks(List<Songbook> songbooks) {
    this.songbooks.clear();
    songbooks.forEach((Songbook songbook) {
      this.songbooks.add(songbook);
    });
  }
}
