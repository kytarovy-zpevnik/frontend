part of app;

@Controller(selector: '[song]', publishAs: 'ctrl')
class SongController {
  final SongsResource _songsResource;
  final SongbooksResource _songbooksResource;
  final UserResource _userResource;
  final MessageService _messageService;
  final SessionService _sessionService;
  final RouteProvider _routeProvider;
  final Router _router;

  Song song;

  User user;

  List lyrics = [];

  List allSongbooks = [];

  int transposition = 0;

  String targetUser = '';

  void computeLyrics() {
    if (song != null) {

      this.lyrics = song.computeLyrics();
    }
  }

  SongController(this._sessionService, this._songsResource, this._songbooksResource, this._userResource, this._messageService, this._routeProvider, this._router) {

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
    if(_sessionService.session != null) {
      User currentUser = _sessionService.session.user;
      this.user = new User(currentUser.id, currentUser.username, currentUser.email, currentUser.role, currentUser.lastLogin);
    }

    _songsResource.read(_routeProvider.parameters['id'], old: (_routeProvider.routeName == "old")).then((Song song) {
      this.song = song;
      computeLyrics();
      if(this.user != null){
        _songbooksResource.readAll(0, null, null, justOwned: true).then((List<Songbook> songbooks) {
          songbooks.forEach((Songbook songbook){
            this.allSongbooks.add(songbook);
          });
          querySelector('html').classes.remove('wait');
        });
      }
      else{
        querySelector('html').classes.remove('wait');
      }

    });
  }

  void transpose(int transposition) {
    this.transposition += transposition;
    this.transposition %= 12;

    String notePattern = 'C#|D#|F#|G#|C|D|E|F|G|A|B|H';
    List<String> chromaticScale = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'B', 'H'];

    this.song.chords.forEach((int k, String chord){

      this.song.chords[k] = chord.replaceAllMapped(new RegExp(notePattern), (Match match){
        int key = chromaticScale.indexOf(match.group(0));
        key += transposition;

        if(key >= chromaticScale.length)
          key -= chromaticScale.length;
        if(key < 0)
          key += chromaticScale.length;

        return chromaticScale[key];
      });
    });
  }

  void addTags(){
    _songsResource.update(song, 'tags').then((_) {
      _messageService.prepareSuccess('Uloženo.', 'Tagy byly k písni úspěšně přidány.');
      _router.go('song.view', {'id': song.id});
    });
  }

  void addToSongbook(Songbook songbook) {
    song.songbooks.add(songbook);
  }

  void removeFromSongbook(Songbook songbook) {
    var toRemove;
    song.songbooks.forEach((songsongbook) {
      if (songsongbook.id == songbook.id) {
        toRemove = songsongbook;
      }
    });
    song.songbooks.remove(toRemove);
  }

  void saveSongbooks(){
    _songsResource.update(song, 'songbooks').then((_){
      _messageService.showSuccess('Aktualizován','Seznam zpěvníků obsahujících tuto píseň byl úspěšně aktualizován.');
    });
  }

  void discardCopy(){
    _songsResource.discardCopy(song).then((_){
      song.copy = null;
      song.old = false;
      _messageService.prepareSuccess('Uloženo.', 'Nadále sledujete aktuální verzi písně.');
      _router.go('song.view', {'id': song.id});
    });
  }

  void share(){
    _songsResource.shareSong(song.id, targetUser).then((_) {
      _messageService.showSuccess('Uloženo.', 'Píseň byla úspěšně nasdílena.');
    }).catchError((ApiError e) {
      switch (e.error) {
        case 'DUPLICATE_SHARING':
          _messageService.showError('Opakované sdílení.', 'S tímto uživatelem píseň ' + song.title + ' již sdílíte.');
          break;
        case 'UNKNOWN_USER':
          _messageService.showError('Neznámý uživatel.', 'Bohužel neznáme žádného uživatele, který by měl zadané uživatelské jméno.');
          break;
      }
    });
  }

  void copySong() {
    _songsResource.copySong(song).then((_) {
      _messageService.prepareSuccess('Vytvořeno.', 'Nová píseň byla úspěšně vytvořena.');
      _router.go('song.view', {'id': song.id});
    });
  }

  void taking() {
    if (song.taken) {
      _songsResource.untakeSong(song).then((_) {
        song.copy = null;
        song.old = false;
        _messageService.showSuccess('Zrušeno.', 'Píseň byla úspěšně odebrána ze seznamu převzatých.');
        song.taken = false;
      });
    }
    else {
      _songsResource.takeSong(song).then((_) {
        _messageService.showSuccess('Převzato.', 'Píseň byla úspěšně převzata.');
        song.taken = true;
      });
    }
  }

  void delete(){
    _songsResource.delete(song).then((_){
      _messageService.prepareSuccess('Smazáno.', 'Píseň byla úspěšně smazána.');
      _router.go('songs', {});
    });
  }

}