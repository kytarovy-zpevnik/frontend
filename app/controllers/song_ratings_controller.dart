part of app;

@Controller(selector: '[song-ratings]', publishAs: 'ctrl')
class SongRatingsController {

  final SongRatingResource _ratingResource;
  final SongsResource _songsResource;
  SessionService _sessionService;
  RouteProvider _routeProvider;

  List ratings = [];

  User user;
  Song song;

  SongRatingsController(this._sessionService, this._ratingResource, this._songsResource, this._routeProvider) {
    querySelector('html').classes.add('wait');
    _songsResource.read(_routeProvider.parameters['id']).then((Song song){
      this.song = song;
      if (_sessionService.session == null) {  // analogicky u dalších controllerů
        _sessionService.initialized.then((_) {
          user = _sessionService.session.user;
          this.user = new User(user.id, user.username, user.email, user.role, user.lastLogin);
        });
      } else {
        user = _sessionService.session.user;
        this.user = new User(user.id, user.username, user.email, user.role, user.lastLogin);
      }
    });
    _ratingResource.readAllRating(_routeProvider.parameters['id']).then((List<Rating> ratings){
      _processRatings(ratings);
      querySelector('html').classes.remove('wait');
    });
  }

  void _processRatings(List<Rating> ratings) {
    this.ratings.clear();
    ratings.forEach((Rating rating) {
      this.ratings.add(rating);
    });
  }

}