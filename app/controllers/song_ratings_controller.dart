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
    _songsResource.read(_routeProvider.parameters['id']).then((Song song){
      this.song = song;
      user = _sessionService.session.user;
      this.user = new User(user.id, user.username, user.email, user.role, user.lastLogin);
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