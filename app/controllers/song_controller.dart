part of app;

@Controller(selector: '[song]', publishAs: 'ctrl')
class SongController {
  SongsResource _songsResource;
  MessageService _messageService;
  RouteProvider _routeProvider;
  Router _router;

  Song song;

  bool create;

  int tab = 0;

  List lyrics = [];

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

  SongController(this._songsResource, this._messageService, this._routeProvider, this._router) {
    create = !_routeProvider.parameters.containsKey('id');

    if (create) {
      song = new Song('', '', '', '', '');

    } else {
      _songsResource.read(_routeProvider.parameters['id']).then((Song song) {
        this.song = song;
        computeLyrics();
      });
    }
  }

  void save() {
    if (create) {
      _songsResource.create(song).then((_) {
        _messageService.addSuccess('Vytvořeno.', 'Nová píseň byla úspěšně vytvořena.');
      });
    } else {
      _songsResource.update(song).then((_) {
        _messageService.addSuccess('Uloženo.', 'Píseň byla úspěšně uložena.');
      });
    }

    _router.go('song.view', {'id': song.id});
  }
}