part of app;

@Controller(selector: '[song-ratings]', publishAs: 'ctrl')
class SongRatingsController {

  final SongRatingResource _ratingResource;
  final SongsResource _songsResource;
  RouteProvider _routeProvider;

  List ratings = [];

  Song song;

  SongRatingsController(this._ratingResource, this._songsResource, this._routeProvider) {
    _songsResource.read(_routeProvider.parameters['id']).then((Song song){
      this.song = song;
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