part of app;

@Controller(selector: '[admin-songbooks]', publishAs: 'ctrl')
class AdminSongbooksController {
  final SongbooksResource _songbooksResource;
  final MessageService _messageService;

  List<Songbook> songbooks = [];

  bool loaded = false;

  bool existsNext = true;
  String sort = 'id';
  bool revert = false;

  AdminSongbooksController(this._songbooksResource, this._messageService) {
    this.songbooks.clear();
    loadSongbooks().then((_){
      loaded = true;
    });
  }

  Future loadSongbooks() {
    querySelector('html').classes.add('wait');
    return _songbooksResource.readAll(songbooks.length, sort, revert ? 'desc' : 'asc', admin: true).then((List<Songbook> songbooks) {
      _processSongs(songbooks);
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
    existsNext = true;
    loadSongbooks();
  }

  _processSongs(List<Songbook> songbooks) {
    songbooks.forEach((Songbook songbook) {
      this.songbooks.add(songbook);
    });
  }

  void delete(Songbook songbook) {
    songbook.archived = true;
    _songbooksResource.delete(songbook);
  }

  void restore(Songbook songbook) {
    songbook.archived = false;
    _songbooksResource.delete(songbook);
  }
}