part of app;

@Controller(selector: '[song-ratings]', publishAs: 'ctrl')
class SongRatingsController {

  final SongRatingResource _ratingResource;
  final SongsResource _songsResource;
  MessageService _messageService;
  SessionService _sessionService;
  RouteProvider _routeProvider;

  List ratings = [];
  Rating newRating;
  int ratingSum;
  int avgRating;

  var formatter = new DateFormat('d.M.yyyy H:m');

  User user;
  Song song;
  bool rated = false;
  bool admin = false;

  SongRatingsController(this._sessionService, this._ratingResource, this._songsResource, this._messageService, this._routeProvider) {
    querySelector('html').classes.add('wait');
    if (_sessionService.session == null) {
      _sessionService.initialized.then((_) {
        _initialize();
      });
    } else {
      _initialize();
    }
  }

  _initialize(){
    if (_sessionService.session != null) {
      User currentUser = _sessionService.session.user;
      this.user = new User(currentUser.id, currentUser.username, currentUser.email, currentUser.role, currentUser.lastLogin);
    }

    Future.wait([
        _songsResource.read(_routeProvider.parameters['id']).then((Song song){
          this.song = song;
        }),
        _ratingResource.readAllRating(_routeProvider.parameters['id']).then(_processRatings)]
    ).then((List<Future> futures){

      if(_routeProvider.routeName == "rate"){
        js.context.callMethod(r'$', ['#rating']).callMethod('modal', [new js.JsObject.jsify({'show': 'true'})]);
      }
      querySelector('html').classes.remove('wait');
    });
  }

  void _processRatings(List<Rating> ratings) {
    avgRating = 0;
    ratingSum = 0;
    this.ratings.clear();
    List row;
    var index = 0;
    ratings.forEach((Rating rating) {
      ratingSum++;
      avgRating += rating.rating;
      if (this.user != null && rating.userId == this.user.id) {
        this.rated = true;
        this.newRating = rating;
      }

      if(index % 3 == 0){
        row = [];
        row.add(rating);
        this.ratings.add(row);
      }
      else{
        row.add(rating);
      }
      index++;
      //this.ratings.add(rating);
    });
    if(!this.rated){
      this.newRating = new Rating();
      this.newRating.rating = 1;
    }
    if(ratingSum != 0){
      avgRating /= ratingSum;
    }
  }

  void saveRating() {
    querySelector('html').classes.add('wait');
    if (!rated) {
      rated = true;
      _ratingResource.createRating(song.id, newRating).then((_){
        _ratingResource.readAllRating(_routeProvider.parameters['id']).then((List<Rating> ratings){
          _processRatings(ratings);
          _messageService.showSuccess('Vytvořeno.', 'Nové hodnocení bylo úspěšně vytvořeno.');
          querySelector('html').classes.remove('wait');
        });
      });
    }
    else {
      _ratingResource.updateRating(song.id, newRating).then((_){
        _ratingResource.readAllRating(_routeProvider.parameters['id']).then((List<Rating> ratings){
          _processRatings(ratings);
          _messageService.showSuccess('Uloženo.', 'Hodnocení bylo úspěšně uloženo.');
          querySelector('html').classes.remove('wait');
        });
      });
    }
  }

  void deleteRating(Rating rating){
    querySelector('html').classes.add('wait');
    if(rating.id == newRating.id)
      rated = false;
    _ratingResource.deleteRating(song.id, rating).then((_) {
      _ratingResource.readAllRating(_routeProvider.parameters['id']).then((List<Rating> ratings){
        _processRatings(ratings);
        _messageService.showSuccess('Odstraněno.', 'Hodnocení bylo úspěšně odebráno.');
        querySelector('html').classes.remove('wait');
      });
    });
  }

}