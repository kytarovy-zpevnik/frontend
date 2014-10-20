part of app;

@Controller(selector: '[songs]', publishAs: 'ctrl')
class SongsController {

  final SongsResource _songResource;
  final MessageService _messageService;

  List songs = [];

  SongsController(this._songResource, this._messageService) {
    _songResource.readAll().then((List<Song> songs) {
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
    });
  }


}