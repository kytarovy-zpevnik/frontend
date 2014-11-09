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
    _songsResource.read(_routeProvider.parameters['id']).then((Song song){
      this.song = song;
      _ratingResource.editAllRating(song.id).then((int id){
        if (id == 0) {
          print(id);
          create = true;
          this.rating = new Rating();
        }
        else {
          print(id);
          create = false;
          _ratingResource.readRating(song.id, id).then((Rating rating) {
            this.rating = new Rating(id: rating.id, comment: rating.comment, rating: rating.rating, created: rating.created, modified: rating.modified);
          });
        }
      });
    });
  }

  void save() {
    if (create) {
      _ratingResource.createRating(rating).then((_){
        _messageService.prepareSuccess('Vytvořeno.', 'Nové hodnocení bylo úspěšně vytvořeno.');
        _router.go('song.ratings', {'id': song.id});
      });
    }
    else {
      _ratingResource.editRating(rating).then((_){
        _messageService.prepareSuccess('Uloženo.', 'Hodnocení bylo úspěšně uloženo.');
        _router.go('song.ratings', {'id': song.id});
      });
    }
  }
}