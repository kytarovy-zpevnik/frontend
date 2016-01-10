part of app;

@Controller(selector: '[homepage]', publishAs: 'ctrl')
class HomepageController {

  final SongsResource _songResource;
  final SongbooksResource _songbookResource;
  final Router _router;

  List songs = [];
  List songbooks = [];

  HomepageController(this._router, this._songResource, this._songbookResource){
    querySelector('html').classes.add('wait');
    Future.wait([
      _songbookResource.readAll(randomPublic: true).then(_processSongbooks),
      _songResource.readAll(randomPublic: true).then(_processSongs)]
    ).then((List<Future> futures){
      querySelector('html').classes.remove('wait');
    });
  }

  _processSongs(List<Song> songs) {
    this.songs.clear();
    List row;
    var index = 0;
    songs.forEach((Song song) {
      if(index % 4 == 0){
        row = [];
        row.add(song);
        this.songs.add(row);
      }
      else{
        row.add(song);
      }
      index++;
    });
  }

  _processSongbooks(List<Songbook> songbooks) {
    this.songbooks.clear();
    List row;
    var index = 0;
    songbooks.forEach((Songbook songbook) {
      if(index % 4 == 0){
        row = [];
        row.add(songbook);
        this.songbooks.add(row);
      }
      else{
        row.add(songbook);
      }
      index++;
    });
  }

  void signIn() {
    _router.go('sign', {});
  }
}