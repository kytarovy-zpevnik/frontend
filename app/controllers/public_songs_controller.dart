part of app;

@Controller(selector: '[public-songs]', publishAs: 'ctrl')
class PublicSongsController {

  final SongsResource _songsResource;
  final MessageService _messageService;
  SessionService _sessionService;

  List songs = [];
  List visibleSongs = [];
  String _search = '';
  String get search => _search;
  bool advSearchVisible = false;
  Map<String, String> filters = {};
  Filters filters;

  bool loaded = false;

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

  PublicSongsController(this._sessionService, this._songsResource, this._messageService) {
    this.songs.clear();
    this.visibleSongs.clear();
    filters = new Filters();

    loadSongs().then((_){
      loaded = true;
    });
  }

  Future loadSongs() {
    querySelector('html').classes.add('wait');
    return _songsResource.readAll(songs.length, sort, revert ? 'desc' : 'asc', public: true, filters: filters.filters).then((List<Song> songs) {
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

  void advancedSearch() {
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

  _filterSongs(){
    this.visibleSongs.clear();
    this.songs.forEach((Song song){
      if(song.contains(_search))
        visibleSongs.add(song);
    });
  }
}
