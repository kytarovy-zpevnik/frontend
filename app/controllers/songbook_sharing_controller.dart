part of app;

@Controller(selector: '[songbook-sharing]', publishAs: 'ctrl')
class SongbookSharingController {

  final SongbookSharingResource _songbookSharingResource;
  final SongbooksResource _songbooksResource;
  final UserResource _userResource;
  final MessageService _messageService;
  final RouteProvider _routeProvider;
  final Router _router;

  Songbook songbook;
  String userName = "";
  bool editable = false;

  SongbookSharingController(this._songbookSharingResource, this._songbooksResource, this._userResource, this._messageService, this._routeProvider, this._router) {
    _songbooksResource.read(_routeProvider.parameters['id']).then((Songbook songbook){
      this.songbook = songbook;
    });
  }

  void save() {
    _userResource.read(userName).then((User user){
      _songbookSharingResource.create(songbook.id, user.id, editable).then((_) {
        _messageService.prepareSuccess('Uloženo.', 'Zpěvník byl úspěšně nasdílen.');
        _router.go('songbook.view', {'id': songbook.id});
      }).catchError((ApiError e) {
        switch (e.error) {
          case 'DUPLICATE_SHARING':
            _messageService.showError('Opakované sdílení.', 'S tímto uživatelem zpěvník ' + songbook.name + ' již sdílíte.');
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