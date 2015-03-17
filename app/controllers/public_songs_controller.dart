part of app;

@Controller(selector: '[public-songs]', publishAs: 'ctrl')
class PublicSongsController {

  final SongsResource _songResource;
  final MessageService _messageService;

  User user;
  List songs = [];
  String _search = '';
  String get search => _search;
  bool advSearchVisible = false;
  Map<String, String> filters = {};
  SessionService _sessionService;

  set search(String search) {
    _search = search;
    /*if (_search == '') {
      _songResource.readAll(searchAllPublic: false).then(_processSongs);
    }
    else {
      _songResource.readAll(searchPublic: search).then(_processSongs);
    }*/
    _songResource.readAll(searchPublic: _search).then(_processSongs);
  }

  toggleAdvSearch() {
    advSearchVisible = !(advSearchVisible);
  }

  advSearch() {
    _songResource.readAll(filters: filters).then(_processSongs);
  }

  PublicSongsController(this._sessionService, this._songResource, this._messageService) {
    _songResource.readAll(/*searchAllPublic: false*/ searchPublic: ' ').then(_processSongs);
    user = _sessionService.session.user;
    this.user = new User(user.id, user.username, user.email, user.role, user.lastLogin);
  }

  _processSongs(List<Song> songs) {
    this.songs.clear();
    List row;
    var index = 0;
    songs.forEach((Song song) {
      /*if (song.username == this.user.username) {
        index--;
      }
      else*/ if(index % 4 == 0){
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
}
