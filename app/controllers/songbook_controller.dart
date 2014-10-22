part of app;

@Controller(selector: '[songbook]', publishAs: 'ctrl')
class SongbookController {
  SongbooksResource _songbooksResource;
  MessageService _messageService;
  RouteProvider _routeProvider;
  Router _router;

  Songbook songbook;

  SongbookController(this._songbooksResource, this._messageService, this._routeProvider, this._router) {

    _songbooksResource.read(_routeProvider.parameters['id']).then((Songbook songbook) {
      List songs = [];
      List row;
      var index = 0;
      songbook.songs.forEach((Song song) {
        if(index % 4 == 0){
          row = [];
          row.add(song);
          songs.add(row);
        }
        else{
          row.add(song);
        }
        index++;
      });

      this.songbook = new Songbook(songbook.id, songbook.name, songs: songs);

    });
  }

}