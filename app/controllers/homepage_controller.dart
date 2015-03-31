part of app;

@Controller(selector: '[homepage]', publishAs: 'ctrl')
class HomepageController {

  final SongsResource _songResource;
  final Router _router;

  List songs = [];

  HomepageController(this._router, this._songResource){
    _songResource.readAll(randomPublic: true).then(_processSongs);
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