part of app;

@Controller(selector: '[songbook]', publishAs: 'ctrl')
class SongbookController {
  SongbooksResource _songbooksResource;
  MessageService _messageService;
  RouteProvider _routeProvider;
  Router _router;

  Songbook songbook;
  bool create;

  SongbookController(this._songbooksResource, this._messageService, this._routeProvider, this._router) {

      create = !_routeProvider.parameters.containsKey('id');
      if(create) {
        this.songbook = new Songbook('','','');
      }

      else {
        _songbooksResource.read(_routeProvider.parameters['id']).then((Songbook songbook) {
          List songs = [];
          List row;
          var index = 0;
          songbook.songs.forEach((Song song) {
            if (index % 4 == 0) {
              row = [];
              row.add(song);
              songs.add(row);
            }
            else {
              row.add(song);
            }
            index++;
          });

          this.songbook = new Songbook(songbook.id, songbook.name, songbook.note, songs: songs);
        });
      }
  }

  void save() {
    if (create) {
      _songbooksResource.create(songbook).then((_){
        _messageService.prepareSuccess('Vytvořeno.', 'Nový zpěvník byl úspěšně vytvořen.');
        _router.go('songbook.view', {'id': songbook.id});
      });
    }
    else {
      _songbooksResource.edit(songbook).then((_){
        _messageService.prepareSuccess('Uloženo.', 'Zpěvník byl úspěšně uložen.');
        _router.go('songbook.view', {'id': songbook.id});
      });
    }
  }
}