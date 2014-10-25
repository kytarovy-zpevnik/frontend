part of app;

@Controller(selector: '[songs]', publishAs: 'ctrl')
class SongsController {

  final SongsResource _songResource;
  final MessageService _messageService;

  List songs = [];

  String _search = '';

  String get search => _search;

  set search(String search) {
    _search = search;
    _songResource.readAll(search).then(_processSongs);
  }

  SongsController(this._songResource, this._messageService) {
    _songResource.readAll().then(_processSongs);
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

}
