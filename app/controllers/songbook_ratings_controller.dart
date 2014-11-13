part of app;

@Controller(selector: '[songbook-ratings]', publishAs: 'ctrl')
class SongbookRatingsController {

  final SongbookRatingResource _ratingResource;
  final SongbooksResource _songbooksResource;
  SessionService _sessionService;
  RouteProvider _routeProvider;

  List ratings = [];

  User user;
  Songbook songbook;

  SongbookRatingsController(this._sessionService, this._ratingResource, this._songbooksResource, this._routeProvider) {
    _songbooksResource.read(_routeProvider.parameters['id']).then((Songbook songbook){
      this.songbook = songbook;
      _sessionService.initialized.then((_) {
        user = _sessionService.session.user;
        this.user = new User(user.id, user.username, user.email, user.role, user.lastLogin);
      });
    });
    _ratingResource.readAllRating(_routeProvider.parameters['id']).then(_processRatings);
  }

  void _processRatings(List<Rating> ratings) {
    this.ratings.clear();
    ratings.forEach((Rating rating) {
      this.ratings.add(rating);
    });
  }

}