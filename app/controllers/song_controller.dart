part of app;

@Controller(selector: '[song]', publishAs: 'ctrl')
class SongController {
  final SongsResource _songsResource;
  final SongbooksResource _songbooksResource;
  final MessageService _messageService;
  final SessionService _sessionService;
  final RouteProvider _routeProvider;
  final Router _router;

  Song song;

  User user;

  bool create;

  int tab = 0;

  String agama;

  bool import = false;

  List lyrics = [];

  List items = [];

  List<ChordPosition> chpos = [];

  void computeLyrics() {
    var offset = 0;

    var sections = [];

    if (song != null) {
      var first = true;
      song.lyrics.split('\n\n').forEach((String section) {
        if (first) {
          first = false;
        } else {
          offset += 2; // count in delimiting \n\n
        }
        var rowOffset = section.indexOf('))');
        var title = '';

        if (section.indexOf('((') == 0 && rowOffset != -1) {
          print(rowOffset);
          title = section.substring(2, rowOffset) + ':';
          rowOffset += 2;
        } else {
          rowOffset = 0;
        }

        first = true;
        var lines = [];
        section.substring(rowOffset).trim().split('\n').forEach((String line) {
          if (first) {
            first = false;
          } else {
            offset++;  // count in delimiting \n
          }
          var chars = [];
          line.split('').forEach((String char) {
            chars.add({
                'offset': offset++,
                'char': char
            });
          });
          lines.add(chars);
        });

        sections.add({
            'title': title,
            'lines': lines
        });
      });
    }

    lyrics = sections;
  }

  SongController(this._sessionService, this._songsResource, this._songbooksResource, this._messageService, this._routeProvider, this._router) {
    import = _routeProvider.routeName == 'importSong';
    create = !_routeProvider.parameters.containsKey('id') || import;

    _sessionService.initialized.then((_) {
      User currentUser = _sessionService.session.user;
      this.user = new User(currentUser.id, currentUser.username, currentUser.email, currentUser.role, currentUser.lastLogin);
    }); // dodělat úplně všude

    if (create) {
      song = new Song('', '', '', '', '', '', false);

      if (_routeProvider.parameters.containsKey('songbookId')) {
        _songbooksResource.read(_routeProvider.parameters['songbookId']).then((Songbook songbook) {
          song.songbooks.add(songbook);
        });
      }

      _songbooksResource.readAll().then((List<Songbook> songbooks) {
        songbooks.forEach((Songbook songbook) {
          this.items.add({
            'songbook': songbook,
            'included': false
          });
        });
      });

    } else {
      querySelector('html').classes.add('wait');
      _songsResource.read(_routeProvider.parameters['id']).then((Song song) {
        this.song = song;
        computeLyrics();
        querySelector('html').classes.remove('wait');

        _songbooksResource.readAll().then((List<Songbook> songbooks) {
          songbooks.forEach((Songbook songbook) {
            var included = false;

            song.songbooks.forEach((Songbook songsongbook) {
              if (songbook.id == songsongbook.id) {
                included = true;
              }
            });

            this.items.add({
              'songbook': songbook,
              'included': included
            });
          });
        });
      });
    }
  }

  void export() {
    _songsResource.export(_routeProvider.parameters['id']).then((String agama) {
      this.agama = agama;
    });
  }

  void transpose(int transposition) {
    transposition %= 12; // shift by 0-12 semitones
    _songsResource.read(_routeProvider.parameters['id'], transposition).then((Song song) {
      this.song = song;
      computeLyrics();
    });
  }

  void addToSongbook(int index) {
    items[index]['included'] = true;
    song.songbooks.add(items[index]['songbook']);
    _songsResource.update(song).then((_){
      _messageService.showSuccess("Přidána", "Písnička byla úspěšně přidána do zpěvníku.");
      _router.go('songs.view', {'id': song.id});
    });
  }

  void removeFromSongbook(int index) {
    items[index]['included'] = false;

    var toRemove;
    song.songbooks.forEach((songbook) {
      if (songbook.id == items[index]['songbook'].id) {
        toRemove = songbook;
      }
    });

    song.songbooks.remove(toRemove);
    _songsResource.update(song).then((_){
      _messageService.showSuccess('Odebrána','Píseň byla úspěšně odebrána ze zpěvníku.');
    });
  }

  void save() {
    if (create) {
      if (import) {
        _songsResource.import(song, agama).then((_) {
          _messageService.prepareSuccess('Imortováno.', 'Nová píseň byla úspěšně naimportována.');
          _router.go('song.view', {
              'id': song.id
          });
        });
      } else {
        _songsResource.create(song).then((_) {
          _messageService.prepareSuccess('Vytvořeno.', 'Nová píseň byla úspěšně vytvořena.');
          _router.go('song.view', {
              'id': song.id
          });
        });
      }
    } else {
      _songsResource.update(song).then((_) {
        _messageService.prepareSuccess('Uloženo.', 'Píseň byla úspěšně uložena.');
        _router.go('song.view', {'id': song.id});
      });
    }
  }

  void addChpos(ChordPosition chpos) {
    this.chpos.add(chpos);
  }

  void hideChordEditors() {
    this.chpos.forEach((chpos) {
      chpos.hideChordEditor();
    });
  }

  void takeSong() {
    _songsResource.takeSong(song).then((_) {
      _messageService.prepareSuccess('Vytvořeno.', 'Nová píseň byla úspěšně vytvořena.');
      _router.go('song.view', {'id': song.id});
    });
  }

}