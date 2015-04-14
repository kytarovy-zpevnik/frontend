part of app;

@Controller(selector: '[song-rating]', publishAs: 'ctrl')
class SongRatingController {

  SongRatingResource _ratingResource;
  SongsResource _songsResource;
  MessageService _messageService;
  RouteProvider _routeProvider;
  Router _router;

  Rating rating;
  bool create;
  Song song;

  SongRatingController(this._ratingResource, this._songsResource, this._messageService, this._routeProvider, this._router) {
    querySelector('html').classes.add('wait');
    _songsResource.read(_routeProvider.parameters['id']).then((Song song){
      this.song = song;
      _ratingResource.readAllRating(song.id, true).then((List<Rating> ratings){
        if (ratings.isEmpty) {
          create = true;
          this.rating = new Rating();
          this.rating.rating = 1;
          querySelector('html').classes.remove('wait');
        }
        else {
          int id;
          ratings.forEach((Rating rating) {
            id = rating.id;
          });
          create = false;
          _ratingResource.readRating(song.id, id).then((Rating rating) {
            this.rating = new Rating(id: rating.id, comment: rating.comment, rating: rating.rating, created: rating.created, modified: rating.modified);
            querySelector('html').classes.remove('wait');
          });
        }
      });
    });
  }

  void save() {
    if (create) {
      _ratingResource.createRating(song.id, rating).then((_){
        _messageService.prepareSuccess('Vytvořeno.', 'Nové hodnocení bylo úspěšně vytvořeno.');
        _router.go('song.ratings', {'id': song.id});
      });
    }
    else {
      _ratingResource.editRating(song.id, rating).then((_){
        _messageService.prepareSuccess('Uloženo.', 'Hodnocení bylo úspěšně uloženo.');
        _router.go('song.ratings', {'id': song.id});
      });
    }
  }
}