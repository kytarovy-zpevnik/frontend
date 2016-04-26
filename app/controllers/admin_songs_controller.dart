part of app;

@Controller(selector: '[admin-songs]', publishAs: 'ctrl')
class AdminSongsController {
  final SongsResource _songsResource;
  final MessageService _messageService;

  List<Song> songs = [];

  bool loaded = false;

  bool existsNext = true;
  String sort = 'id';
  bool revert = false;

  AdminSongsController(this._songsResource, this._messageService) {
    this.songs.clear();
    loadSongs().then((_){
      loaded = true;
    });
  }

  Future loadSongs() {
    querySelector('html').classes.add('wait');
    return _songsResource.readAll(songs.length, sort, revert ? 'desc' : 'asc', admin: true).then((List<Song> songs) {
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
    existsNext = true;
    loadSongs();
  }

  _processSongs(List<Song> songs) {
    songs.forEach((Song song) {
      this.songs.add(song);
    });
  }

  void delete(Song song) {
    song.archived = true;
    _songsResource.delete(song);
  }

  void restore(Song song) {
    song.archived = false;
    _songsResource.delete(song);
  }
}