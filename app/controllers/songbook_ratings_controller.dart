part of app;

@Controller(selector: '[songbook-ratings]', publishAs: 'ctrl')
class SongbookRatingsController {

  final SongbookRatingResource _ratingResource;
  final SongbooksResource _songbooksResource;
  RouteProvider _routeProvider;

  List ratings = [];

  Songbook songbook;

  SongbookRatingsController(this._ratingResource, this._songbooksResource, this._routeProvider) {
    _songbooksResource.read(_routeProvider.parameters['id']).then((Songbook songbook){
      this.songbook = songbook;
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