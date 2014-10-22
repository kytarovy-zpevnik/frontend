part of app;

@Controller(selector: '[songbooks]', publishAs: 'ctrl')
class SongbooksController {

  final SongbooksResource _songbookResource;
  final MessageService _messageService;

  List songbooks = [];



  SongbooksController(this._songbookResource, this._messageService) {
    _songbookResource.readAll().then((List<Songbook> songbooks) {
      songbooks.forEach((Songbook songbook) {
          this.songbooks.add(songbook);
      });
    });
  }


}