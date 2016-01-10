part of app;

@Controller(selector: '[song-sharing]', publishAs: 'ctrl')
class SongSharingController {

  final SongSharingResource _songSharingResource;
  final SongsResource _songsResource;
  final UserResource _userResource;
  final MessageService _messageService;
  final RouteProvider _routeProvider;
  final Router _router;

  Song song;
  String userName = "";

  SongSharingController(this._songSharingResource, this._songsResource, this._userResource, this._messageService, this._routeProvider, this._router) {
    _songsResource.read(_routeProvider.parameters['id']).then((Song song){
      this.song = song;
    });
  }

  void save() {
    _userResource.read(userName).then((User user){
      _songsResource.shareSong(song.id, user.id).then((_) {
        _messageService.prepareSuccess('Uloženo.', 'Píseň byla úspěšně nasdílena.');
        _router.go('song.view', {'id': song.id});
      }).catchError((ApiError e) {
        switch (e.error) {
          case 'DUPLICATE_SHARING':
            _messageService.showError('Opakované sdílení.', 'S tímto uživatelem píseň ' + song.title + ' již sdílíte.');
            break;
        }
      });
    }).catchError((ApiError e) {
      switch (e.error) {
        case 'UNKNOWN_IDENTIFIER':
          _messageService.showError('Neznámý uživatel.', 'Bohužel neznáme žádného uživatele, který by měl zadané uživatelské jméno.');
          break;
      }
    });


  }

}