part of app;

@Controller(selector: '[songs]', publishAs: 'ctrl')
class SongsController {

  final SongsResource _songResource;
  final MessageService _messageService;
  SessionService _sessionService;
  final UserResource _userResource;

  List songs = [];
  List sharedSongs = [];
  String _search = '';
  String get search => _search;
  bool advSearchVisible = false;
  Map<String, String> filters = {};

  set search(String search) {
    _search = search;
    _songResource.readAll(search: search).then(_processSongs);
  }

  toggleAdvSearch() {
    advSearchVisible = !(advSearchVisible);
  }

  advSearch() {
    _songResource.readAll(filters: filters).then(_processSongs);
  }

  SongsController(this._sessionService, this._songResource, this._messageService, this._userResource) {
    querySelector('html').classes.add('wait');
    _sessionService.initialized.then((_) {
      _songResource.readAll().then(_processSongs);
      var user = _sessionService.session.user;
      _userResource.readAllSharedSongs(user.id).then(_processSharedSongs);
      querySelector('html').classes.remove('wait');
    });
  }

  _processSongs(List<Song> songs) {
    this.songs.clear();
    List row;
    var index = 0;
    songs.forEach((Song song) {
      if(index % 4 == 0){
        row = [];
        row.add(song);
        this.songs.add(row);
      }
      else{
        row.add(song);
      }
      index++;
    });
  }

  _processSharedSongs(List<Song> songs) {
    this.sharedSongs.clear();
    List row;
    var index = 0;
    songs.forEach((Song song) {
      if(index % 4 == 0){
        row = [];
        row.add(song);
        this.sharedSongs.add(row);
      }
      else{
        row.add(song);
      }
      index++;
    });
  }

}
