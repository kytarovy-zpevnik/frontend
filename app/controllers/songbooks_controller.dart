part of app;

@Controller(selector: '[songbooks]', publishAs: 'ctrl')
class SongbooksController {

  final SongbooksResource _songbookResource;
  final MessageService _messageService;

  List songbooks = [];

  String _search = '';

  String get search => _search;

  set search(String search) {
    _songbookResource.readAll(search).then(_processSongbooks);
  }

  SongbooksController(this._songbookResource, this._messageService) {
    _songbookResource.readAll().then(_processSongbooks);
  }

  void _processSongbooks(List<Songbook> songbooks) {
    this.songbooks.clear();
    songbooks.forEach((Songbook songbook) {
      this.songbooks.add(songbook);
    });
  }

}