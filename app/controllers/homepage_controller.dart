part of app;

@Controller(selector: '[homepage]', publishAs: 'ctrl')
class HomepageController {

  final SongsResource _songResource;
  final Router _router;

  List songs = [];

  HomepageController(this._router, this._songResource){
    querySelector('html').classes.add('wait');
    _songResource.readAll(randomPublic: true).then((List<Song> songs){
      _processSongs(songs);
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

  void signIn() {
    _router.go('sign', {});
  }
}