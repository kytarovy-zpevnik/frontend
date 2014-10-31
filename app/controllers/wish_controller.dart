part of app;

@Controller(selector: '[wish]', publishAs: 'ctrl')
class WishController {
  WishesResource _wishesResource;
  MessageService _messageService;
  RouteProvider _routeProvider;
  Router _router;

  Wish wish;
  bool create;

  WishController(this._wishesResource, this._messageService, this._routeProvider, this._router) {
    create = !_routeProvider.parameters.containsKey('id');
    if(create) {
      this.wish = new Wish();
    }
    else {
      _wishesResource.read(_routeProvider.parameters['id']).then((Wish wish) {
        this.wish = new Wish(id: wish.id, name: wish.name, note: wish.note, meet: wish.meet, created: wish.created, modified: wish.modified);
      });
    }
  }

  void save() {
    if (create) {
      _wishesResource.create(wish).then((_){
        _messageService.prepareSuccess('Vytvořeno.', 'Nové přání bylo úspěšně vytvořeno.');
        _router.go('wish.view', {'id': wish.id});
      });
    }
    else {
      _wishesResource.edit(wish).then((_){
        _messageService.prepareSuccess('Uloženo.', 'Přání bylo úspěšně uloženo.');
        _router.go('wish.view', {'id': wish.id});
      });
    }
  }

  void mark() {
    wish.meet = !wish.meet;
    save();
  }
}