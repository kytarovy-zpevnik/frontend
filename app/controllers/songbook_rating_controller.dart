part of app;

@Controller(selector: '[songbook-rating]', publishAs: 'ctrl')
class SongbookRatingController {

  SongbookRatingResource _ratingResource;
  SongbooksResource _songbooksResource;
  MessageService _messageService;
  RouteProvider _routeProvider;
  Router _router;

  Rating rating;
  bool create;
  Songbook songbook;

  SongbookRatingController(this._ratingResource, this._songbooksResource, this._messageService, this._routeProvider, this._router) {
    _songbooksResource.read(_routeProvider.parameters['id']).then((Songbook songbook){
      this.songbook = songbook;
      _ratingResource.readAllRating(songbook.id, true).then((List<Rating> ratings){
        if (ratings.isEmpty) {
          create = true;
          this.rating = new Rating();
        }
        else {
          int id;
          ratings.forEach((Rating rating) {
            id = rating.id;
          });
          create = false;
          _ratingResource.readRating(songbook.id, id).then((Rating rating) {
            this.rating = new Rating(id: rating.id, comment: rating.comment, rating: rating.rating, created: rating.created, modified: rating.modified);
          });
        }
      });
    });
  }

  void save() {
    if (create) {
      _ratingResource.createRating(songbook.id, rating).then((_){
        _messageService.prepareSuccess('Vytvořeno.', 'Nové hodnocení bylo úspěšně vytvořeno.');
        _router.go('songbook.ratings', {'id': songbook.id});
      });
    }
    else {
      _ratingResource.editRating(songbook.id, rating).then((_){
        _messageService.prepareSuccess('Uloženo.', 'Hodnocení bylo úspěšně uloženo.');
        _router.go('songbook.ratings', {'id': songbook.id});
      });
    }
  }
}