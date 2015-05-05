part of app;

@Controller(selector: '[admin-songbooks]', publishAs: 'ctrl')
class AdminSongbooksController {
  final SongbooksResource _songbooksResource;
  final MessageService _messageService;

  List<Songbook> songbooks = [];

  AdminSongbooksController(this._songbooksResource, this._messageService) {
    _loadSongbooks();
  }

  void delete(Songbook songbook) {
    songbook.archived = true;
    _songbooksResource.delete(songbook);
  }

  void restore(Songbook songbook) {
    songbook.archived = false;
    _songbooksResource.delete(songbook);
  }

  void _loadSongbooks() {
    querySelector('html').classes.add('wait');
    _songbooksResource.readAll(admin: true).then((List<Songbook> songbooks){
      songbooks.forEach((Songbook songbook) {
        this.songbooks.add(songbook);
      });
      querySelector('html').classes.remove('wait');
    });
  }
}