part of app;

@Controller(selector: '[song]', publishAs: 'ctrl')
class SongController {
  final SongsResource _songsResource;
  final SongbooksResource _songbooksResource;
  final MessageService _messageService;
  final RouteProvider _routeProvider;
  final Router _router;

  Song song;

  bool create;

  int tab = 0;

  List lyrics = [];

  List items = [];

  void computeLyrics() {
    var offset = 0;

    var sections = [];

    if (song != null) {
      song.lyrics.split('\n\n').forEach((String section) {
        var rowOffset = section.indexOf(':') + 1;
        var title = section.substring(0, rowOffset);

        var lines = [];
        section.substring(rowOffset).trim().split('\n').forEach((String line) {
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



  SongController(this._songsResource, this._songbooksResource, this._messageService, this._routeProvider, this._router) {
    create = !_routeProvider.parameters.containsKey('id');

    if (create) {
      song = new Song('', '', '', '', '', '');

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
      _songsResource.read(_routeProvider.parameters['id']).then((Song song) {
        this.song = song;
        computeLyrics();

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

  void addToSongbook(int index) {
    items[index]['included'] = true;
    song.songbooks.add(items[index]['songbook']);
    _songsResource.update(song);
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
    _songsResource.update(song);
  }

  void save() {
    if (create) {
      _songsResource.create(song).then((_) {
        _messageService.addSuccess('Vytvořeno.', 'Nová píseň byla úspěšně vytvořena.');
        _router.go('song.view', {'id': song.id});
      });
    } else {
      _songsResource.update(song).then((_) {
        _messageService.addSuccess('Uloženo.', 'Píseň byla úspěšně uložena.');
        _router.go('song.view', {'id': song.id});
      });
    }
  }
}