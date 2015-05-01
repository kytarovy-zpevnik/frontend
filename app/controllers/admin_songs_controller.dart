part of app;

@Controller(selector: '[admin-songs]', publishAs: 'ctrl')
class AdminSongsController {
  final SongsResource _songsResource;
  final MessageService _messageService;

  List<Song> songs = [];

  AdminSongsController(this._songsResource, this._messageService) {
    _loadSongs();
  }

  void delete(Song song) {
    song.archived = true;
    _songsResource.delete(song);
  }

  void restore(Song song) {
    song.archived = false;
    _songsResource.update(song);
  }

  void _loadSongs() {
    querySelector('html').classes.add('wait');
    _songsResource.readAll(admin: true).then((List<Song> songs){
      songs.forEach((Song song) {
        this.songs.add(song);
      });
      querySelector('html').classes.remove('wait');
    });
  }
}