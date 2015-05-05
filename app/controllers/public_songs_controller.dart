part of app;

@Controller(selector: '[public-songs]', publishAs: 'ctrl')
class PublicSongsController {

  final SongsResource _songResource;
  final MessageService _messageService;

  List songs = [];
  List visibleSongs = [];
  String _search = '';
  String get search => _search;
  bool advSearchVisible = false;
  Map<String, String> filters = {};
  SessionService _sessionService;

  set search(String search) {
    _search = search;
    //_songResource.readAll(searchPublic: _search).then(_processSongs);
    _filterSongs();
  }

  toggleAdvSearch() {
    advSearchVisible = !(advSearchVisible);
  }

  advSearch() {
    _songResource.readAll(filters: filters).then(_processSongs);
  }

  PublicSongsController(this._sessionService, this._songResource, this._messageService) {
    querySelector('html').classes.add('wait');
    _songResource.readAll(searchPublic: ' ').then((List<Song> songs){
      _processSongs(songs);
      querySelector('html').classes.remove('wait');
    });
  }

  _processSongs(List<Song> songs) {
    this.songs.clear();
    this.visibleSongs.clear();
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
